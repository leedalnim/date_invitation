# 나랑 데이트 할래요? 🤍

데이트 코스를 고르는 초대장 + 우리 맛집 목록을 관리하는 페이지.
빌드 도구 없이 `index.html` 파일 하나로 동작합니다.

## GitHub Pages 로 올리기

공유 기능(카카오톡 공유, 기본 공유 시트, 클립보드 복사)은 **https 주소**에서만 제대로 동작합니다.
파일을 직접 열거나(`file://`) 다른 사이트에 iframe 으로 끼워 넣으면 브라우저가 공유 권한을 막습니다.

1. GitHub 저장소 → **Settings → Pages**
2. Source 를 **Deploy from a branch**, 브랜치는 **main / (root)** 로 지정
3. 몇 분 뒤 `https://<사용자이름>.github.io/date_invitation/` 으로 접속

## 카카오톡 공유 버튼 켜기

기본값에서는 카카오 버튼이 숨겨져 있고, 기본 공유 시트와 복사만 동작합니다.

1. [Kakao Developers](https://developers.kakao.com) 에서 애플리케이션 추가
2. **앱 키 → JavaScript 키** 복사
3. **플랫폼 → Web → 사이트 도메인**에 위 GitHub Pages 주소를 등록 (이걸 빼먹으면 동작하지 않습니다)
4. `index.html` 안의 `KAKAO_JS_KEY` 에 JavaScript 키를 붙여넣기

```js
var KAKAO_JS_KEY = '여기에_JavaScript_키';
```

SDK `<script>` 태그의 `integrity` 값은 Kakao Developers 문서의 최신 스니펫을 그대로 복사해 쓰세요.
값이 틀리면 SDK 가 통째로 차단됩니다.

## 맛집 관리

랜딩 화면 아래 **🍽 맛집 관리하기** 로 들어갑니다.

- **가볼 곳 / 가본 곳** — 코스를 전송하면 뽑힌 곳이 자동으로 `가본 곳` 으로 넘어갑니다.
- **노출 스위치** — 초대장 메뉴에 실제로 보일 후보를 고릅니다. 담아둔 곳이 많아도 한 번에 보이는 건 점심 5칸 / 저녁 4칸입니다.
- **N번 밀림** — 후보에는 올랐는데 안 뽑힌 횟수. 지운 게 아니라 순서가 밀린 것뿐입니다.
- **🎲 이번 후보 뽑기** — 오래 밀린 곳 위주로 이번 회차 노출을 자동으로 다시 채웁니다.
- **💗 또 가고싶다** — 가본 곳 중 이걸 끄면 후보에서 빠집니다.
- **고정 코스** — 점심과 저녁 사이에 늘 들어가는 코스를 추가/순서변경/on·off 합니다.

노출 칸 수를 바꾸려면 `index.html` 의 `SLOT_LIMIT` 을 수정하세요.

```js
var SLOT_LIMIT = { lunch: 5, dinner: 4 };
```

## 데이터가 저장되는 곳

브라우저 `localStorage` 에 저장되며 **기기·브라우저마다 따로** 관리됩니다.
둘이 같은 목록을 보려면 관리 화면 아래 **💾 내보내기**로 JSON 파일을 만들어 전달하고,
받은 쪽에서 **📂 가져오기**로 불러오세요. 기기를 바꾸기 전 백업 용도로도 씁니다.

사진은 200×200 JPEG 로 줄여서 저장하지만, 너무 많이 넣으면 저장 공간이 찰 수 있습니다.

## 아이콘 바꾸기

아이콘은 `index.html` 상단 `ICONS` 객체 한 곳에 모여 있습니다. 이모지 / 이미지 / 인라인 SVG 전부 됩니다.

```js
var ICONS = {
  map: '🗺',
  edit: '<img class="icon-img" src="icons/edit.svg" alt="">',
  trash: '<svg class="icon-img" viewBox="0 0 24 24">...</svg>'
};
```

`npx shadcn@latest add https://itshover.com/r/<icon>.json` 으로 받은 항목은 React 컴포넌트라
이 프로젝트에 그대로 넣을 수 없습니다. 받은 파일에서 `<svg>...</svg>` 부분만 꺼내
위처럼 문자열로 붙여넣고 `class="icon-img"` 를 추가하면 크기가 맞춰집니다.

## 코스 공유 링크

코스를 전송하면 복사되는 텍스트 끝에 `#c=...` 링크가 함께 붙습니다.
이 링크를 열면 서버 없이도 상대가 고른 코스가 그대로 보입니다.
