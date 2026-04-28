// /api/feedback.js
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
    const { data, error } = await supabase
      .from('feedback').select('*').order('created_at', { ascending: false }).limit(200);
    if (error) return res.status(500).json({ error: error.message });
    return res.json({ feedback: data });
  }

  if (req.method === 'POST') {
    const { type, rating, title, body, page, device, user_email } = req.body || {};
    if (!title || !body || !rating) return res.status(400).json({ error: 'Missing fields' });

    const { data, error } = await supabase
      .from('feedback')
      .insert({ type, rating, title, body, page, device, user_email })
      .select().single();
    if (error) return res.status(500).json({ error: error.message });
    return res.json({ feedback: data });
  }

  if (req.method === 'PATCH') {
    const { id, action, user_email, status } = req.body || {};

    if (action === 'upvote') {
      const { data: fb } = await supabase
        .from('feedback').select('upvotes, upvoted_by').eq('id', id).single();
      if (!fb) return res.status(404).json({ error: 'Not found' });

      const upvoted = fb.upvoted_by || [];
      const has = upvoted.includes(user_email);
      const newUpvoted = has ? upvoted.filter(e => e !== user_email) : [...upvoted, user_email];
      const newCount = has ? Math.max(0, fb.upvotes - 1) : fb.upvotes + 1;

      await supabase.from('feedback').update({
        upvotes: newCount, upvoted_by: newUpvoted
      }).eq('id', id);
      return res.json({ success: true, upvotes: newCount, my_upvote: !has });
    }

    if (action === 'change_status') {
      const adminEmail = req.headers['x-admin-email'];
      const { data: admin } = await supabase
        .from('admins').select('email').eq('email', adminEmail).maybeSingle();
      if (!admin) return res.status(403).json({ error: 'Not an admin' });

      await supabase.from('feedback').update({ status, updated_at: new Date().toISOString() }).eq('id', id);
      return res.json({ success: true });
    }
  }

  res.status(405).json({ error: 'Method not allowed' });
}
