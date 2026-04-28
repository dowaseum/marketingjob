# 5단계: 도메인 연결 (선택)

## 왜 필요한가요?
`marketingjob-abc123.vercel.app` 같은 무료 도메인 대신
`marketingjob.kr` 같은 본인만의 깔끔한 도메인을 쓰고 싶다면 진행하세요.

**도메인 안 쓰셔도 됩니다.** 무료 vercel 도메인으로도 정상 작동해요.

## 작업 시간: 30분
## 비용: 도메인에 따라 연 1.5~3만원

## 도메인 구입

### 추천 업체 (한국)
- **가비아** (https://www.gabia.com) — 한국에서 가장 대중적, .kr 도메인 강세
- **카페24** (https://www.cafe24.com)
- **후이즈** (https://whois.co.kr)

### 추천 업체 (해외, 더 저렴)
- **Cloudflare Registrar** (https://www.cloudflare.com/products/registrar/) — 원가 판매, 가장 저렴 (.com 약 $10/년)
- **Namecheap** (https://www.namecheap.com)

## 단계별 진행

### ① 도메인 구입
원하는 업체에서 `marketingjob.kr` 같은 이름 검색 → 결제

### ② Vercel에 도메인 등록
1. Vercel 대시보드 → 프로젝트 → **Settings** → **Domains**
2. 구입한 도메인 입력 → **Add** 클릭
3. Vercel이 DNS 설정 안내 화면을 보여줌 (보통 2가지 옵션):
   - **A Record**: `76.76.21.21` 같은 IP 주소
   - **CNAME**: `cname.vercel-dns.com`

### ③ 도메인 업체에서 DNS 설정
구입한 업체 관리 페이지에서 **DNS 관리** 또는 **네임서버 설정** 메뉴로 이동:

#### 가비아 예시
1. My가비아 → 도메인 → DNS 관리
2. 레코드 추가:
   - 타입: **A**, 호스트: `@`, 값/위치: `76.76.21.21` (Vercel이 알려준 IP)
   - 타입: **CNAME**, 호스트: `www`, 값/위치: `cname.vercel-dns.com`
3. 저장

### ④ DNS 전파 대기
- 보통 5분~1시간, 길면 24시간
- Vercel Domains 페이지에서 도메인 옆에 **초록색 체크** 표시되면 완료
- 이제 본인 도메인으로 사이트 접속 가능!

## 다음 단계
✅ 도메인 연결 끝나면 [06-frontend-update.md](./06-frontend-update.md)로

## 자주 묻는 질문

**Q. 어떤 도메인이 좋아요?**
- `.kr` — 한국 사이트 인상 (연 2~3만원)
- `.com` — 가장 보편적 (연 1.5만원)
- `.io` — 스타트업 분위기 (연 4~5만원)
- `.app` — 앱 같은 느낌 (연 2만원)

**Q. SSL(https) 직접 설정해야 하나요?**
아니요. Vercel이 자동으로 무료 SSL 인증서를 발급·갱신해줍니다.
