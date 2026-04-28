# 6단계: 프론트 연동 — 정적 HTML이 Supabase 데이터를 사용하도록 변경

## 왜 필요한가요?
지금까지 만든 marketingjob.html은 모든 데이터가 브라우저(localStorage)에만 저장돼요.
이 단계에서 그걸 *진짜 Supabase 데이터베이스*에서 받아오도록 바꿉니다.

## 작업 시간: 약 30분 (개발자에게 부탁하면 5분)

## 솔직한 안내
이 단계가 **가장 어려운 부분**이에요. HTML을 수동 편집해야 합니다.

두 가지 방법이 있어요:

### 방법 A. Claude(저)에게 부탁 (추천)
**다음 메시지를 저에게 보내주세요**:

> "지금까지 만든 marketingjob.html을 Supabase + Vercel 백엔드와 연동하도록 수정해줘.
> 내 SUPABASE_URL은 https://xxxxx.supabase.co이고, anon key는 eyJ... 야.
> 내 Vercel API 주소는 https://marketingjob-abc123.vercel.app 이야.
> 모든 localStorage 호출을 fetch API 호출로 바꿔줘."

그러면 제가 수정한 HTML 파일을 다시 만들어드릴게요. **이 방법이 가장 간단**합니다.

### 방법 B. 직접 수정
이 가이드 하단의 코드 스니펫들을 marketingjob.html의 `<script>` 영역에 추가하고,
`saveState()` / 각 렌더 함수를 fetch 호출로 교체.

전체 코드 변경량이 많아서 직접 하시는 건 비추천이에요. **방법 A를 권장**합니다.

## 방법 A 진행 시 흐름

1. 저(Claude)에게 위 메시지 보내기
2. 수정된 HTML 파일 받기
3. 그 파일을 GitHub Desktop으로 클론한 폴더의 `public/index.html`로 저장
4. GitHub Desktop → Commit → Push
5. Vercel이 자동으로 재배포 (1~2분)
6. 배포된 URL 접속해서 정상 작동 확인

## 데이터 흐름 (참고)

```
[사용자 브라우저]
       ↓ fetch
[Vercel /api/jobs] → [Supabase jobs 테이블]
       ↓ fetch
[사용자 브라우저 화면 렌더]
```

cron 동기화:
```
[Vercel cron 매 시간]
       ↓
[/api/cron-sync] → [워크넷 API 호출]
       ↓
[Supabase jobs 테이블에 적재]
```

## 다음 단계
✅ 프론트 연동까지 끝나면 [07-admin-system.md](./07-admin-system.md)로
