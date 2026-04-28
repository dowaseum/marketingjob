// /api/users.js
import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-admin-email');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (req.method === 'GET') {
    const adminEmail = req.headers['x-admin-email'];
    if (adminEmail) {
      const { data: admin } = await supabase
        .from('admins').select('email, role').eq('email', adminEmail).maybeSingle();
      if (admin) {
        const { data } = await supabase
          .from('users').select('*').order('created_at', { ascending: false }).limit(1000);
        return res.json({ users: data, is_admin: true });
      }
    }

    const { email } = req.query;
    if (!email) return res.status(400).json({ error: 'Email required' });
    const { data } = await supabase.from('users').select('*').eq('email', email).maybeSingle();
    return res.json({ user: data });
  }

  if (req.method === 'POST') {
    const profile = req.body || {};
    if (!profile.email) return res.status(400).json({ error: 'Email required' });

    const { data: existing } = await supabase
      .from('users').select('id').eq('email', profile.email).maybeSingle();

    if (existing) {
      const { data } = await supabase
        .from('users').update({ ...profile, updated_at: new Date().toISOString() })
        .eq('email', profile.email).select().single();
      return res.json({ user: data });
    }
    const { data } = await supabase.from('users').insert(profile).select().single();
    return res.json({ user: data });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
