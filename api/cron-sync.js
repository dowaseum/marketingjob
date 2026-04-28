// =====================================================================
// /api/cron-sync.js
// 매시간 자동 실행 — 데이터 정리·검증 작업
//
// [현재 버전: 워크넷 미연동]
//   1. 마감일 지난 공고 자동 비활성화 (deadline < today)
//   2. 사용자 제보 3건 이상 누적된 공고를 자동 검증 (is_verified=true)
//   3. 동기화 로그 기록
//
// [워크넷 연동 후 추가 예정 — 인증키 발급 후 활성화]
//   - 워크넷 API 호출 → 마케팅 키워드 필터 → Supabase 적재
//   - 워크넷 데이터와 사용자 제보 중복 시 머지
// =====================================================================
import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
  // CRON_SECRET으로 인증
  if (req.headers.authorization !== `Bearer ${process.env.CRON_SECRET}`) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  const { data: log } = await supabase
    .from('sync_logs')
    .insert({ status: 'running', source: 'maintenance' })
    .select()
    .single();
  const logId = log?.id;

  const stats = { expired_deactivated: 0, auto_verified: 0, errors: [] };

  try {
    // 1. 마감일 지난 공고 비활성화
    const today = new Date().toISOString().split('T')[0];
    const { data: expired, error: expiredErr } = await supabase
      .from('jobs')
      .update({
        is_deleted: true,
        deleted_at: new Date().toISOString(),
        delete_reason: '마감일 경과 (자동)'
      })
      .lt('deadline', today)
      .eq('is_deleted', false)
      .select('id');
    if (expiredErr) stats.errors.push(`expired: ${expiredErr.message}`);
    else stats.expired_deactivated = expired?.length || 0;

    // 2. 사용자 제보 3건 이상 자동 검증
    const { data: toVerify, error: verifyErr } = await supabase
      .from('jobs')
      .update({ is_verified: true })
      .gte('reported_by', 3)
      .eq('is_verified', false)
      .eq('source', 'user')
      .select('id');
    if (verifyErr) stats.errors.push(`verify: ${verifyErr.message}`);
    else stats.auto_verified = toVerify?.length || 0;

    // 3. 로그 완료
    const finalStatus = stats.errors.length > 0 ? 'failed' : 'success';
    await supabase.from('sync_logs').update({
      finished_at: new Date().toISOString(),
      status: finalStatus,
      jobs_updated: stats.expired_deactivated + stats.auto_verified,
      error_message: stats.errors.length > 0 ? stats.errors.join(' | ') : null
    }).eq('id', logId);

    return res.json({ success: true, stats });
  } catch (error) {
    if (logId) {
      await supabase.from('sync_logs').update({
        finished_at: new Date().toISOString(),
        status: 'failed',
        error_message: error.message
      }).eq('id', logId);
    }
    return res.status(500).json({ error: error.message });
  }
}
