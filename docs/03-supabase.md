# 3단계: Supabase — 데이터베이스 만들기

## 왜 필요한가요?
사용자, 공고, 피드백, 동기화 기록을 저장할 데이터베이스예요.
Supabase = "오픈소스 Firebase" 같은 도구로, 무료 플랜으로 시작할 수 있어요.

## 작업 시간: 약 30분

## 단계별 진행

### ① Supabase 회원가입
1. https://supabase.com 접속
2. 우측 상단 **Start your project** 클릭
3. **Continue with GitHub** 클릭 (조금 전 만든 GitHub 계정 사용 — 가장 쉬워요)
4. 권한 승인

### ② 새 프로젝트 만들기
1. 대시보드에서 **New project** 클릭
2. 다음 정보 입력:
   - **Organization**: 자동 생성된 본인 이름 그대로
   - **Project name**: `marketingjob`
   - **Database Password**: 강력한 비밀번호 생성 + **반드시 메모장에 저장** (분실 시 복구 어려움)
   - **Region**: `Northeast Asia (Seoul)` 선택 (속도 빠름)
   - **Pricing Plan**: **Free** 선택
3. **Create new project** 클릭
4. 약 2분 정도 프로비저닝 대기 (커피 한 잔 ☕)

### ③ 테이블 생성 — SQL Editor 사용
1. 좌측 사이드바에서 **SQL Editor** 아이콘 클릭 (📝 모양)
2. **+ New query** 클릭
3. 제가 드린 `supabase/schema.sql` 파일을 메모장으로 열어 **전체 내용 복사**
4. SQL Editor 화면에 **붙여넣기**
5. 우측 하단 **RUN** 버튼 클릭
6. *"Success. No rows returned"* 메시지가 나오면 성공!

### ④ API 키 복사
1. 좌측 사이드바 하단 **Project Settings** (⚙️ 아이콘) 클릭
2. **API** 메뉴 클릭
3. 다음 두 값을 메모장에 저장:

   - **Project URL** (예: `https://abcdefgh.supabase.co`) → 메모장에 `SUPABASE_URL =` 옆에 붙여넣기
   - **API Keys** 섹션 → **anon (public)** 키 → `SUPABASE_ANON_KEY =` 옆에 붙여넣기
   - 같은 페이지의 **service_role** 키 (📋 reveal 클릭해야 보임) → `SUPABASE_SERVICE_ROLE_KEY =` 옆에 붙여넣기

> ⚠️ **service_role 키는 절대 공개되면 안 돼요.** 이 키는 모든 데이터를 읽고 쓸 수 있는 만능 키예요. 코드에 직접 넣지 말고 Vercel 환경변수에만 넣으세요.

### ⑤ 테이블 확인
1. 좌측 사이드바 **Table Editor** (📊 아이콘) 클릭
2. 다음 5개 테이블이 보이면 정상:
   - `users` — 가입자 정보
   - `jobs` — 채용 공고
   - `feedback` — 오류 리포트
   - `sync_logs` — cron 동기화 기록
   - `admins` — 관리자 권한

### ⑥ 첫 관리자 계정 등록
본인이 관리자가 되려면 admins 테이블에 본인 이메일을 직접 등록해야 해요.

1. **Table Editor** → `admins` 테이블 클릭
2. 우측 상단 **+ Insert row** 클릭
3. 다음 입력:
   - `email`: 본인 이메일 (관리자 모드 진입할 때 사용할 이메일)
   - `name`: 본인 이름 (예: 김민지)
   - `role`: `super_admin`
4. **Save** 클릭

## 다음 단계
✅ 메모장에 다음 4개가 저장됐는지 확인하고 [04-vercel.md](./04-vercel.md)로 넘어가세요.

```
SUPABASE_URL = https://...supabase.co
SUPABASE_ANON_KEY = eyJ...
SUPABASE_SERVICE_ROLE_KEY = eyJ...
DB_PASSWORD = ...
```

## 자주 묻는 질문

**Q. 무료 플랜으로 충분한가요?**
- 무료 플랜: 데이터베이스 500MB, API 호출 무제한
- 채용 공고 데이터는 매우 가벼워서 (1만 건도 50MB 미만), 첫 1~2년은 충분합니다
- 사용자가 늘어 한도를 넘으면 월 $25 Pro 플랜으로 업그레이드

**Q. SQL이 뭐예요? 무서워요**
SQL은 데이터베이스에 명령하는 언어인데, 우리는 작성할 필요 없이 제가 만든 파일을 복붙만 하면 돼요. 한 번만 실행하면 끝.

**Q. 비밀번호를 잊어버렸어요**
프로젝트 설정에서 재설정 가능하지만 어려워요. **반드시** 처음에 메모장에 저장하세요.
