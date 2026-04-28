# 4단계: Vercel — 백엔드 + 프론트 호스팅 + cron 실행

## 왜 필요한가요?
GitHub에 올린 코드를 자동으로 인터넷에 배포해서 누구나 접속할 수 있게 해줘요.
또한 매시간 cron 작업으로 워크넷 API를 호출해서 공고를 자동 동기화합니다.

## 작업 시간: 약 30분

## 사전 준비 체크리스트
다음 메모가 모두 있어야 해요:
- [ ] GitHub 저장소 URL
- [ ] SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
- [ ] WORKNET_API_KEY (Decoding 키)

## 단계별 진행

### ① 코드를 GitHub 저장소에 업로드
1. 제가 드린 zip 파일 압축 해제
2. 압축 푼 폴더 안의 모든 파일/폴더를 GitHub Desktop으로 클론한 폴더(예: `바탕화면/marketingjob`)에 **전부 복사**
3. GitHub Desktop 실행 → 좌측에 변경된 파일들이 보임
4. 하단 **Summary** 칸에 `Initial backend setup` 입력
5. **Commit to main** 버튼 클릭
6. 우측 상단 **Push origin** 클릭
7. 잠시 후 GitHub 저장소 페이지를 새로고침하면 파일들이 올라가 있어야 해요

### ② Vercel 가입
1. https://vercel.com 접속
2. **Sign Up** → **Continue with GitHub** 클릭 (가장 간단)
3. 권한 승인

### ③ 새 프로젝트 만들기
1. Vercel 대시보드 → **Add New...** → **Project** 클릭
2. **Import Git Repository** 섹션에서 방금 만든 `marketingjob` 저장소 찾기
3. 못 보이면 **Adjust GitHub App Permissions** 클릭 → 저장소 권한 부여
4. 저장소 옆 **Import** 버튼 클릭

### ④ 환경변수 설정 (가장 중요!)
**Configure Project** 화면에서 **Environment Variables** 섹션 펼치기.
다음 5개를 하나씩 추가합니다:

| Name (이름) | Value (값) |
|---|---|
| `SUPABASE_URL` | (메모해둔 Supabase URL) |
| `SUPABASE_ANON_KEY` | (메모해둔 anon 키) |
| `SUPABASE_SERVICE_ROLE_KEY` | (메모해둔 service_role 키) |
| `WORKNET_API_KEY` | (메모해둔 워크넷 Decoding 키) |
| `CRON_SECRET` | 아무 긴 랜덤 문자열 (예: `marketingjob-cron-secret-2025-abcde`) |

각 항목 입력 후 **Add** 버튼 클릭.

> 💡 CRON_SECRET은 본인이 자유롭게 만드는 비밀번호예요. 길고 추측하기 어렵게.

### ⑤ Deploy 클릭
1. 환경변수 5개 모두 입력 후 **Deploy** 버튼 클릭
2. 약 1~2분 동안 배포 진행 (커피 ☕)
3. *"Congratulations!"* 화면 + 사이트 미리보기가 보이면 성공!

### ⑥ 배포된 URL 확인
- Vercel이 자동으로 무료 도메인을 줘요: 예 `https://marketingjob-abc123.vercel.app`
- 이 URL을 메모장에 저장 (이게 사이트 주소입니다)
- 브라우저로 접속해서 정상 작동하는지 확인

### ⑦ cron 작동 테스트
1. Vercel 대시보드 → 프로젝트 → **Cron Jobs** 메뉴
2. `/api/cron-sync` 항목이 보여야 함
3. 우측 **Run** 버튼으로 즉시 실행 테스트
4. **Logs** 탭에서 실행 결과 확인 (성공이면 워크넷에서 공고를 받아왔다는 로그가 있음)
5. Supabase Table Editor에서 `jobs` 테이블 확인 → 데이터가 들어왔는지 확인

> ⚠️ **워크넷 API 승인이 안 됐으면** 이 단계는 401 에러가 납니다. 승인 받은 후 다시 Run.

## 다음 단계
✅ 사이트가 배포됐으면 [05-domain.md](./05-domain.md)로 (도메인은 선택)
✅ 도메인 안 쓰시면 그냥 [06-frontend-update.md](./06-frontend-update.md)로 가서 프론트 연동

## 자주 묻는 질문

**Q. 무료로 계속 쓸 수 있나요?**
- 개인 취미·작은 프로젝트는 무료 (Hobby 플랜)
- 월 100GB 대역폭, cron job은 hobby에선 하루 2번만 실행됨
- 우리는 매시간 실행하므로 **Pro 플랜 ($20/월)** 이 필요할 수 있음
- → 처음엔 hobby로 시작 → 사용자 늘면 Pro 업그레이드

**Q. cron이 hobby에서 안 된다면?**
대안 1: 무료 외부 cron 서비스 사용 (예: cron-job.org)에서 매시간 `https://사이트/api/cron-sync` 호출
대안 2: vercel.json의 schedule을 `"0 0,12 * * *"` (하루 2번)로 변경

**Q. 배포가 실패해요**
Vercel 대시보드 → Deployments → 실패한 빌드 → Logs 확인. 에러 메시지를 캡처해서 저(Claude)에게 가져오세요.
