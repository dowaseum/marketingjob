// /api/jobs.js — 공고 조회·관리 API
import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, x-admin-email');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (req.method === 'GET') {
    const { data, error } = await supabase
      .from('jobs')
      .select('*')
      .eq('is_deleted', false)
      .order('created_at', { ascending: false })
      .limit(500);
    if (error) return res.status(500).json({ error: error.message });
    return res.json({ jobs: data });
  }

  if (req.method === 'POST') {
    const body = req.body || {};
    const { data, error } = await supabase
      .from('jobs')
      .insert({ ...body, source: 'user' })
      .select()
      .single();
    if (error) return res.status(500).json({ error: error.message });
    return res.json({ job: data });
  }

  if (req.method === 'DELETE') {
    const adminEmail = req.headers['x-admin-email'];
    if (!adminEmail) return res.status(401).json({ error: 'Admin email required' });

    const { data: admin } = await supabase
      .from('admins').select('email').eq('email', adminEmail).maybeSingle();
    if (!admin) return res.status(403).json({ error: 'Not an admin' });

    const { id, reason } = req.body || {};
    if (!id) return res.status(400).json({ error: 'Job id required' });

    const { error } = await supabase.from('jobs').update({
      is_deleted: true,
      deleted_at: new Date().toISOString(),
      deleted_by: adminEmail,
      delete_reason: reason || ''
    }).eq('id', id);
    if (error) return res.status(500).json({ error: error.message });
    return res.json({ success: true });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
