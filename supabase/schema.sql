-- =====================================================================
-- 마케팅잡픽 데이터베이스 스키마
-- Supabase SQL Editor에 통째로 붙여넣고 RUN
-- =====================================================================

-- 1. 가입자 정보
create table users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  name text not null,
  initial text,
  education text,
  major text,
  loc text[],
  interest_roles text[],
  skills jsonb default '{}'::jsonb,
  quals text[],
  experiences jsonb default '[]'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  last_login_at timestamptz
);
create index idx_users_email on users(email);
create index idx_users_created on users(created_at desc);

-- 2. 채용 공고
create table jobs (
  id bigserial primary key,
  external_id text unique,
  source text not null check (source in ('worknet', 'user', 'manual', 'seed')),
  company text not null,
  title text not null,
  role text check (role in ('content','performance','brand','growth','crm','ae','mp','cw')),
  loc text,
  deadline date,
  salary integer,
  tags text[],
  urgent boolean default false,
  is_new boolean default true,
  description text,
  duties text[],
  requirements text[],
  preferences text[],
  skills text[],
  external_links jsonb,
  direct_url text,
  direct_url_source text,
  company_type text,
  company_types text[],
  company_info jsonb,
  reported_by integer default 0,
  is_user_reported boolean default false,
  is_verified boolean default false,
  is_deleted boolean default false,
  deleted_at timestamptz,
  deleted_by text,
  delete_reason text,
  last_synced_at timestamptz default now(),
  created_at timestamptz default now()
);
create index idx_jobs_deadline on jobs(deadline);
create index idx_jobs_role on jobs(role);
create index idx_jobs_source on jobs(source);
create index idx_jobs_deleted on jobs(is_deleted);
create index idx_jobs_company on jobs(company);

-- 3. 피드백
create table feedback (
  id uuid primary key default gen_random_uuid(),
  user_email text,
  type text check (type in ('bug','ui','idea','data','other')),
  rating integer check (rating between 1 and 5),
  title text not null,
  body text not null,
  page text,
  device text,
  status text default 'open' check (status in ('open','reviewing','resolved')),
  upvotes integer default 0,
  upvoted_by text[] default array[]::text[],
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create index idx_feedback_created on feedback(created_at desc);
create index idx_feedback_status on feedback(status);

-- 4. 동기화 로그 (cron 실행 기록)
create table sync_logs (
  id bigserial primary key,
  started_at timestamptz default now(),
  finished_at timestamptz,
  status text check (status in ('running','success','failed')),
  jobs_fetched integer default 0,
  jobs_inserted integer default 0,
  jobs_updated integer default 0,
  error_message text,
  source text default 'maintenance'
);
create index idx_sync_logs_started on sync_logs(started_at desc);

-- 5. 관리자 (이 테이블에 등록된 이메일만 관리자 모드 진입 가능)
create table admins (
  email text primary key,
  name text,
  role text default 'admin' check (role in ('super_admin','admin','viewer')),
  created_at timestamptz default now()
);

-- =====================================================================
-- Row Level Security
-- =====================================================================
alter table users enable row level security;
alter table jobs enable row level security;
alter table feedback enable row level security;
alter table sync_logs enable row level security;
alter table admins enable row level security;

create policy "Anyone can read non-deleted jobs"
  on jobs for select using (is_deleted = false);

create policy "Anyone can read feedback" on feedback for select using (true);
create policy "Anyone can insert feedback" on feedback for insert with check (true);
create policy "Anyone can update feedback upvotes" on feedback for update using (true);

create policy "Users can read own data" on users for select using (auth.email() = email);
create policy "Users can insert own data" on users for insert with check (auth.email() = email);
create policy "Users can update own data" on users for update using (auth.email() = email);

-- =====================================================================
-- 시드 데이터 — 사이트 첫 오픈 시 비어 있으면 어색하므로 미리 채워둠
-- =====================================================================
insert into jobs (source, company, title, role, loc, deadline, salary, tags, description, company_type, company_types, is_verified, is_new) values
('seed', '토스', '콘텐츠 마케터 신입 (Toss Brand Studio)', 'content', 'seoul', current_date + 14, 4200, array['콘텐츠 기획','SNS','브랜드 보이스'], '토스 브랜드 스튜디오에서 콘텐츠 마케터를 찾고 있어요. 토스의 보이스로 사용자에게 닿는 콘텐츠를 함께 만들어요.', 'inhouse', array['inhouse'], true, true),
('seed', '카카오', '퍼포먼스 마케터 신입', 'performance', 'pangyo', current_date + 21, 4000, array['메타광고','구글애즈','GA4','ROAS'], '카카오의 다양한 서비스 광고 운영을 함께할 신입 퍼포먼스 마케터를 모십니다.', 'inhouse', array['inhouse'], true, true),
('seed', '네이버', '브랜드 마케터 신입', 'brand', 'pangyo', current_date + 18, 4100, array['브랜딩','BX','캠페인 기획'], '네이버 신규 서비스의 브랜드 정체성을 함께 만들어갈 신입 브랜드 마케터를 찾습니다.', 'inhouse', array['inhouse'], true, true),
('seed', '컬리', 'CRM 마케터 신입', 'crm', 'seoul', current_date + 12, 3800, array['Braze','리텐션','이메일','푸시'], '컬리의 고객 라이프사이클을 분석하고 리텐션을 만들어가는 CRM 마케터.', 'inhouse', array['inhouse'], true, true),
('seed', '쿠팡', '그로스 마케터 신입', 'growth', 'seoul', current_date + 25, 4500, array['SQL','A/B 테스트','퍼널 분석'], '쿠팡의 그로스 팀에서 데이터 기반 실험을 통해 사용자 행동을 분석할 신입을 모집합니다.', 'inhouse', array['inhouse'], true, true),
('seed', '우아한형제들', '카피라이터 신입 (배민)', 'cw', 'seoul', current_date + 16, 3700, array['카피라이팅','크리에이티브','광고 카피'], '배달의민족 광고와 SNS 콘텐츠의 카피를 책임질 신입 카피라이터.', 'inhouse', array['inhouse'], true, true),
('seed', '당근마켓', '콘텐츠 마케터 신입', 'content', 'seoul', current_date + 20, 3900, array['콘텐츠 기획','로컬 마케팅','SNS'], '당근마켓의 동네 콘텐츠를 함께 만들어갈 신입 콘텐츠 마케터.', 'inhouse', array['inhouse'], true, true),
('seed', '무신사', '퍼포먼스 마케터 신입', 'performance', 'seoul', current_date + 8, 3800, array['메타광고','GA4','패션'], '무신사의 퍼포먼스 광고 운영을 함께할 신입.', 'inhouse', array['inhouse'], true, false),
('seed', '올리브영', 'CRM 마케터 신입', 'crm', 'seoul', current_date + 22, 3600, array['리텐션','뷰티','로열티 프로그램'], '올리브영 멤버십과 CRM 캠페인을 운영할 신입.', 'inhouse', array['inhouse'], true, true),
('seed', '이노션 월드와이드', 'AE 신입 (현대차그룹)', 'ae', 'seoul', current_date + 10, 3500, array['광고기획','어카운트','대기업 클라이언트'], '이노션의 신입 AE로 현대차그룹 캠페인을 함께합니다.', 'agency', array['agency'], true, false),
('seed', '제일기획', 'AE 신입', 'ae', 'seoul', current_date + 15, 3500, array['광고기획','어카운트','글로벌 캠페인'], '제일기획 신입 AE 공채.', 'agency', array['agency'], true, true),
('seed', '디블렌트', 'MP 신입 (미디어플래너)', 'mp', 'seoul', current_date + 13, 3400, array['미디어 플래닝','OOH','디지털 미디어'], '통합 미디어 플래닝을 배우고 싶은 신입 환영.', 'agency', array['agency'], true, false),
('seed', '메이크어스', '콘텐츠 마케터 신입 (딩고)', 'content', 'seoul', current_date + 17, 3600, array['숏폼 콘텐츠','SNS','인플루언서'], '딩고 채널에서 숏폼 콘텐츠를 만들어갈 신입 콘텐츠 마케터.', 'agency', array['agency'], true, true),
('seed', '엔비티', 'AE 신입', 'ae', 'seoul', current_date + 9, 3400, array['앱 마케팅','리워드 광고','광고기획'], '캐시슬라이드 등 앱 광고 캠페인의 신입 AE.', 'agency', array['agency'], true, false),
('seed', '잡코리아 채용연계', '그로스 마케터 신입 (시드 단계 SaaS)', 'growth', 'seoul', current_date + 7, 3800, array['GA4','SQL','A/B 테스트'], '시드 단계 SaaS 스타트업의 신입 그로스 마케터를 채용연계로 추천.', 'recruit', array['recruit'], true, true),
('seed', '사람인 채용연계', '마케터 신입 (시리즈A 이커머스)', 'performance', 'pangyo', current_date + 13, 3600, array['메타광고','GA4','퍼포먼스'], '시리즈A 이커머스 스타트업의 신입 마케터 채용연계.', 'recruit', array['recruit'], false, false),
('seed', '원티드 채용연계', 'B2B 마케터 신입 (시리즈B SaaS)', 'brand', 'seoul', current_date + 16, 4000, array['B2B 마케팅','콘텐츠 기획','리드 생성'], '시리즈B SaaS의 신입 B2B 마케터 채용연계.', 'recruit', array['recruit'], true, true);

-- 첫 관리자는 본인 이메일로 직접 INSERT 하세요:
-- insert into admins (email, name, role) values ('your@email.com', '본인이름', 'super_admin');
