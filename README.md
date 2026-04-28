# 마케팅잡픽 백엔드 패키지

## 시작하기 — 가장 먼저 읽으세요

👉 **[docs/00-overview.md](./docs/00-overview.md)** 부터 읽으세요. 전체 흐름이 정리돼 있어요.

워크넷 인증키 신청은 이미 완료하셨어요 → **2단계부터 시작**입니다.

## 폴더 구조

```
marketingjob-backend/
├── README.md                    ← 지금 보고 있는 파일
├── package.json                 ← Node 의존성
├── vercel.json                  ← Vercel 설정 (cron 스케줄)
├── .env.example                 ← 환경변수 예시
├── .gitignore                   ← Git 제외 파일
│
├── api/                         ← Vercel Serverless 함수
│   ├── cron-sync.js            ← 매시간 데이터 정리·검증
│   ├── jobs.js                 ← 공고 조회·삭제 API
│   ├── users.js                ← 가입자 관리 API
│   └── feedback.js             ← 피드백 API
│
├── supabase/
│   └── schema.sql              ← DB 스키마 + 시드 17건 (한 번 실행)
│
└── docs/                       ← 단계별 가이드
    ├── 00-overview.md          ← 전체 개요 [먼저 읽기]
    ├── 01-worknet-api.md       ← 1단계: 워크넷 (나중에 추가)
    ├── 02-github.md            ← 2단계: GitHub
    ├── 03-supabase.md          ← 3단계: Supabase
    ├── 04-vercel.md            ← 4단계: Vercel 배포
    ├── 05-domain.md            ← 5단계: 도메인 (선택)
    ├── 06-frontend-update.md   ← 6단계: 프론트 연동
    └── 07-admin-system.md      ← 7단계: 관리자 시스템
```

## 진행 순서 (워크넷 없이 오늘 배포)

1. `docs/00-overview.md` 읽기 (10분)
2. ~~`docs/01-worknet-api.md`~~ — 워크넷 신청은 이미 완료, 승인 대기 중
3. `docs/02-github.md` — GitHub 가입 + 저장소 (15분)
4. `docs/03-supabase.md` — DB 생성 + schema.sql 실행 (30분)
5. `docs/04-vercel.md` — 배포 (30분)
6. `docs/05-domain.md` — 도메인 (선택)
7. `docs/06-frontend-update.md` — 프론트 연동 (Claude에게 부탁)
8. `docs/07-admin-system.md` — 관리자 등록

**소요 시간**: 약 2시간 → 오늘 안에 사이트가 공개됩니다.

## 워크넷 승인 후

`docs/01-worknet-api.md`의 **"승인 떨어지면 어떻게 추가하나요?"** 섹션 참고.
환경변수 추가 + cron-sync.js 한 파일 업데이트만 하면 워크넷 데이터가 매시간 자동 동기화됩니다.

## 막힐 때

각 가이드의 *자주 묻는 질문* 섹션 → 그래도 막히면 화면 캡처 + 에러 메시지를 Claude에게.

## 라이선스

MIT 라이선스. 자유롭게 사용하세요.
