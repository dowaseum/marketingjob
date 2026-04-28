# 2단계: GitHub 가입 + 저장소 만들기

## 왜 필요한가요?
Vercel(우리 백엔드 호스팅)이 GitHub에 있는 코드를 자동으로 가져와서 배포해줘요. 코드 보관소 + 자동 배포의 다리 역할입니다.

## 작업 시간: 약 15분

## 단계별 진행

### ① GitHub 회원가입
1. https://github.com 접속
2. 우측 상단 **Sign up** 클릭
3. 이메일 → 비밀번호 → 사용자명 (예: `kimminji2025`) 설정
4. 이메일 인증 완료

> 💡 사용자명은 나중에 URL에 노출돼요 (`github.com/kimminji2025/marketingjob`). 깔끔한 이름 추천.

### ② 빈 저장소(Repository) 만들기
1. 로그인 후 우측 상단 **+ 버튼** → **New repository** 클릭
2. 다음 정보 입력:
   - **Repository name**: `marketingjob` (또는 원하는 이름)
   - **Description**: "마케팅 신입 채용 매칭 사이트" (선택)
   - **Public** / Private — **Public 추천** (Vercel 무료 플랜 호환성↑)
   - **Add a README file** ✅ 체크
3. **Create repository** 클릭

### ③ 저장소 URL 메모
생성된 저장소 페이지의 URL을 메모장에 저장하세요. 형식:
```
https://github.com/사용자명/marketingjob
```

### ④ GitHub Desktop 설치 (코드 업로드용 — 가장 쉬운 방법)
명령어 모르셔도 클릭으로 업로드할 수 있는 도구예요.

1. https://desktop.github.com 접속
2. **Download for Windows/Mac** 클릭 → 설치
3. 실행 후 GitHub 계정으로 로그인
4. **Clone a repository from the Internet** 클릭
5. 방금 만든 저장소 선택 → **Local path** 지정 (예: `바탕화면/marketingjob`)
6. **Clone** 클릭

> 💡 이제 그 폴더가 GitHub와 연결됐어요. 이 폴더에 파일을 넣고 GitHub Desktop에서 *Commit + Push* 만 누르면 GitHub에 자동 업로드됩니다.

## 다음 단계
✅ GitHub 저장소 URL 메모해두셨으면 [03-supabase.md](./03-supabase.md)로 넘어가세요.

## 자주 묻는 질문

**Q. 코드를 직접 작성해야 하나요?**
아니요. 제가 드릴 모든 파일을 GitHub Desktop으로 클론한 폴더에 그대로 복사·붙여넣기만 하시면 됩니다.

**Q. Public이면 누구나 코드를 보는데 괜찮나요?**
코드 자체는 공개돼도 안전해요. 진짜 비밀(API 키, 비밀번호)은 코드에 넣지 않고 Vercel 환경변수에 따로 저장하니까요.
