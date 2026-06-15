# 🐢 SwimLog

> Apple Watch로 기록한 수영 운동을 HealthKit에서 불러와 시각화하는 iOS 앱

SwimLog는 Apple Watch에 기록된 수영 데이터를 가져와 월 목표 대비 진행률을 한눈에 보여주고, 달력으로 운동 기록을 돌아볼 수 있는 앱입니다. 진행률에 따라 거북이가 수영장을 떠오르는 인터랙션으로 동기를 부여합니다.

<!-- 스크린샷 자리 -->
<!--
| 홈 | 기록 | 설정 |
|----|------|------|
| ![홈](docs/home.png) | ![기록](docs/calendar.png) | ![설정](docs/settings.png) |
-->

<br>

## 📱 주요 기능

- **홈** — 이번 달 목표 거리 대비 현재 수영 거리를 진행률로 표시. 진행률에 따라 거북이가 수직 상승하고, 목표 달성 시 특별 효과 표시
- **기록** — 달력에서 수영한 날을 확인하고, 날짜별 상세 기록(거리, 시간, 칼로리, 평균 심박수, 페이스) 조회
- **설정** — 월 목표 거리 조정, HealthKit 권한 상태 확인, 앱 정보
- **온보딩** — 최초 실행 시 환영 → 권한 요청 → 목표 설정 3단계 플로우

<br>

## 🛠 기술 스택

| 분류 | 사용 기술 |
|------|-----------|
| 언어 | Swift |
| UI | SwiftUI |
| 최소 버전 | iOS 17.0+ |
| 상태 관리 | Observation (`@Observable`), Combine (`ObservableObject`) |
| 동시성 | Swift Concurrency (`async/await`, `@MainActor`) |
| 영속화 | SwiftData |
| 외부 연동 | HealthKit |
| 아키텍처 | MVVM + Feature 단위 모듈화 |

<br>

## 🏗 아키텍처

Feature 단위로 모듈을 나누고, 각 Feature는 MVVM 패턴을 따릅니다.

```
SwimLog/
├── App/                    # 앱 진입점, 라우팅, 탭 구성
├── Core/
│   ├── Services/           # HealthKitManager (외부 시스템 연동)
│   └── Extensions/         # Date 등 공통 확장
└── Features/
    ├── PoolTracker/        # 홈 (목표/진행률/거북이)
    ├── SwimCalendar/       # 기록 (달력/상세)
    ├── Settings/           # 설정
    └── Onboarding/         # 온보딩
```

**데이터 흐름**

```
HealthKit ──(sync)──> SwiftData ──(@Query)──> View
              ▲                                  │
        ViewModel(로직)  <───────────────────────┘
```

- 데이터의 소유는 **SwiftData**가 담당하고, 뷰는 `@Query`로 직접 조회
- ViewModel은 데이터를 들고 있지 않고, **HealthKit 동기화 + 파생 상태 계산(순수 함수)** 역할
- 화면 간 의존성 없이 각 뷰가 SwiftData에서 독립적으로 데이터를 가져옴

<br>

## 💡 기술적 의사결정

### 1. iOS 17 `@Observable` 채택, Combine은 의도적으로 일부만

홈/기록 화면의 ViewModel은 iOS 17의 `@Observable` 매크로로 작성했습니다. `ObservableObject` 대비 프로퍼티 단위 추적으로 불필요한 재렌더링을 줄일 수 있고, Apple이 권장하는 최신 방향이기 때문입니다.

반면 **설정 화면의 ViewModel은 의도적으로 `ObservableObject` + Combine으로 작성**했습니다. 실무 코드베이스에는 여전히 `ObservableObject` 기반 코드가 많아, 두 방식을 모두 다룰 수 있음을 보이고 동작 차이를 직접 비교하기 위함입니다.

### 2. ViewModel은 상태를 소유하지 않고, SwiftData에 위임

`@Observable` ViewModel이 `records` 배열을 직접 들고 있는 대신, 뷰가 `@Query`로 SwiftData에서 직접 조회하도록 했습니다. ViewModel의 파생 상태(진행률, 이번 달 거리 등)는 `records`를 입력으로 받는 **순수 함수**로 표현해, 상태 동기화 부담을 없애고 테스트하기 쉽게 만들었습니다.

### 3. HealthKit 권한의 프라이버시 제약을 정직하게 반영

HealthKit은 프라이버시 보호를 위해 **읽기 권한이 거부되었는지 앱에 알려주지 않습니다** (데이터가 없는 것처럼 보일 뿐). 이 때문에 `granted/denied` 상태를 모델링하면 실제 동작과 어긋납니다.

그래서 권한 상태를 "요청 전 / 요청됨 / 기기 미지원"으로만 표현하고, 실제 데이터 유무는 쿼리 결과로 판단하도록 설계했습니다.

### 4. UUID 기반 Delta Sync + 오삭제 방지 가드

HealthKit과 SwiftData를 동기화할 때, 워크아웃 UUID 집합을 비교하는 Delta Sync를 구현했습니다. 추가/수정은 `@Attribute(.unique)` 기반 upsert로, 삭제는 SwiftData에만 존재하는 레코드를 제거하는 방식입니다.

핵심은 **오삭제 방지 가드**입니다. HealthKit이 권한 거부 시에도 빈 배열을 반환하는 특성 때문에, 빈 배열일 때는 삭제를 건너뛰어 사용자 데이터 손실을 방지했습니다.

### 5. Combine debounce로 저장 최적화

설정 화면에서 월 목표를 Slider로 조정할 때, 값이 연속적으로 바뀝니다. Combine의 `debounce`를 적용해 입력이 멈춘 후 0.5초 뒤 한 번만 저장하도록 해 불필요한 쓰기를 줄였습니다.

<br>

## 🔧 트러블슈팅

### HealthKit 권한 페이지 딥링크

특정 앱의 HealthKit 권한 페이지로 직접 이동하는 공식 딥링크가 없습니다. `x-apple-health://`로 건강 앱을 열되, 권한 변경 경로(건강 앱 > 프로필 > 앱 및 서비스)를 안내 텍스트로 제공해 사용자 혼란을 줄였습니다.

<!-- 추가 트러블슈팅이 있으면 여기에 -->

<br>

## 🚀 실행 방법

1. 저장소 클론
   ```bash
   git clone <repository-url>
   ```
2. `SwimLog.xcodeproj` 열기
3. 실기기 또는 시뮬레이터에서 실행 (HealthKit 데이터 확인은 **실기기 권장**)

> HealthKit은 시뮬레이터에서 수영 데이터가 없을 수 있어, 실제 동작은 Apple Watch로 기록한 데이터가 있는 실기기에서 확인하는 것을 권장합니다.

<br>

## 📌 향후 개선 방향

- 빈 상태(Empty State) 및 동기화 에러 UI 보강
- ViewModel 파생 상태에 대한 단위 테스트
- 위젯 / 활동 통계 추가

<br>

---

<sub>개인 학습 및 포트폴리오 목적으로 제작한 프로젝트입니다.</sub>
