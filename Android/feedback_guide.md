# AI 한 끼 코칭 (Feedback) 설정 가이드

## 개요

FoodLens SDK의 AI 한 끼 코칭 기능은 사용자의 식사 기록을 분석하여 AI 기반 피드백을 제공합니다. 이 기능을 사용하려면 `FoodLensFeedbackConfig`를 설정하여 `setFeedbackConfig()`를 호출해야 합니다.

## 기본 설정

```kotlin
val foodLensUiService: FoodLensUIService = ...

// 피드백 활성화 (최소 설정 - sex만 필수)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE
))

// 피드백 활성화 (사용자 정보 포함)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    age = 30.0,
    height = 170.0,
    feedbackPurposeDetail = FeedbackPurposeDetail.KEEP
))

// 피드백 비활성화
foodLensUiService.setFeedbackConfig(null)
```

> `setFeedbackConfig(null)`을 호출하거나 `setFeedbackConfig()`를 호출하지 않으면 코칭 카드가 표시되지 않습니다.

## 설정 옵션

### 사용자 정보

| 옵션 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `sex` | `Sex` | (필수) | 성별 (`MALE`, `FEMALE`) |
| `age` | `Double?` | `null` | 나이 |
| `height` | `Double?` | `null` | 키 (cm) |
| `feedbackPurposeDetail` | `FeedbackPurposeDetail` | `KEEP` | 목적 상세 (`KEEP`: 유지, `LOSE`: 감량, `GAIN`: 증량) |

> **일일 권장 칼로리(`recommendCalorie`)는 `FoodLensFeedbackConfig`가 아닌 `FoodLensSettingConfig.recommendedKcal`로 설정합니다.** 피드백 요청 시 이 값이 자동으로 `recommendCalorie` 파라미터에 사용되며, 미설정 시 기본값 `2000`이 적용됩니다.
>
> ```kotlin
> foodLensUiService.setSettingConfig(FoodLensSettingConfig(
>     recommendedKcal = 2200f
> ))
> ```

### 피드백 생성 옵션

| 옵션 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `generateFeedback` | `Boolean` | `true` | 피드백 생성 여부 |
| `feedbackMode` | `FeedbackMode` | `ASYNC` | 피드백 모드 (`SYNC`, `ASYNC`) |
| `feedbackTone` | `List<String>` | `emptyList()` | 피드백 톤 설정 (빈 값이면 서버 기본값 사용) |

#### feedbackTone

AI 코칭은 식사를 분석하여 **GOOD / NORMAL / BAD** 세 가지로 판정합니다. `feedbackTone`을 설정하면 각 판정에 맞는 피드백 톤을 커스텀할 수 있습니다.

리스트의 각 인덱스가 판정 결과에 대응합니다.

| 인덱스 | 판정 | 서버 기본 톤 |
|---|---|---|
| `[0]` | GOOD | 친근하게 칭찬, 잘한 점을 구체적으로 짚어주되 과장하지 않기 |
| `[1]` | NORMAL | 부드럽게 아쉬움 전달. 문제점을 지적하되 비난하지 않기 |
| `[2]` | BAD | 걱정하는 톤으로 식사의 문제점을 상세히 알려주기. 비난 금지 |

- 빈 리스트(`emptyList()`)를 전달하면 위 서버 기본 톤이 적용됩니다.
- 커스텀할 경우 반드시 3개 항목을 GOOD / NORMAL / BAD 순서대로 모두 설정해야 합니다.

```kotlin
// 예시: 전체 톤 커스텀
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    feedbackTone = listOf(
        "축하하는 느낌으로 밝게 칭찬해주세요",   // GOOD
        "담담하게 개선점을 알려주세요",           // NORMAL
        "진지하게 건강 위험을 경고해주세요"        // BAD
    )
))
```

### UI/횟수 제한 옵션

| 옵션 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `maxDailyCoachingCount` | `Int` | `-1` | 1일 최대 코칭 횟수 |
| `maxRetryCount` | `Int` | `-1` | 세션(식사 기록)당 다시하기 횟수 |
| `dataEditMaxRetryCount` | `Int?` | `0` | dataEdit 모드 전용 다시하기 횟수 (`null`: maxRetryCount 값을 따름) |
| `showFullFeedback` | `Boolean` | `false` | 코칭 카드 피드백 전체 표시 여부 |
| `isShowRecipe` | `Boolean` | `true` | 코칭 카드 레시피 추천 영역 표시 여부 |

#### maxDailyCoachingCount / maxRetryCount 값 규칙

| 값 | 동작 |
|---|---|
| `-1` | 무제한 |
| `0` | 비활성화 (코칭 UI 미노출 / 다시받기 불가) |
| 양수 | 해당 횟수만큼 제한 |

> `maxDailyCoachingCount`가 `0`이면 `setFeedbackConfig(null)`과 동일하게 코칭 카드 자체가 표시되지 않습니다.

#### dataEditMaxRetryCount 값 규칙

| 값 | 동작 |
|---|---|
| `null` | `maxRetryCount` 값을 따름 |
| `-1` | 무제한 |
| `0` | 비활성화 (피드백 값이 있으면 표시) |
| 양수 | 해당 횟수만큼 제한 |

#### showFullFeedback

| 값 | 동작 |
|---|---|
| `false` (기본) | 피드백 본문 2줄 제한 |
| `true` | 피드백 본문 전체 표시, 카드 높이 자동 확장 |

#### isShowRecipe

| 값 | 동작 |
|---|---|
| `true` (기본) | 코칭 카드 및 코칭 자세히 화면에 레시피 추천 영역 표시 |
| `false` | 레시피 추천 영역 숨김 |

### dataEdit 옵션

> 아래 옵션은 `FoodLensFeedbackConfig`가 아닌 `startFoodLensDataEdit()`의 파라미터입니다.

#### isAutoRefreshFeedback

| 값 | 동작 |
|---|---|
| `false` (기본) | 기존 피드백 데이터가 있으면 그대로 표시, 없으면 코칭 카드 미노출. 음식 수정 시 수정 안내 스낵바만 표시 |
| `true` | 기존 피드백 데이터가 없으면 자동으로 피드백 API 재호출. 음식 수정 시 코칭 다시 받기 스낵바 표시 |

> 신규 인식(`startFoodLensCamera` 등)에서는 항상 피드백을 자동 생성하므로 이 옵션이 적용되지 않습니다.

```kotlin
foodLensUiService.startFoodLensDataEdit(
    activity = activity,
    activityResult = activityResultLauncher,
    recognitionResult = recognitionResult,
    handler = handler,
    isAutoRefreshFeedback = true  // 기본값: false
)
```


## 콜백에서 피드백 결과 받기

SDK 완료 콜백(`UIServiceResultHandler`)에서 `RecognitionResult.feedback`으로 피드백 결과를 받을 수 있습니다.

```kotlin
foodLensUiService.startFoodLensCamera(activity, activityResultLauncher,
    object : UIServiceResultHandler {
        override fun onSuccess(result: RecognitionResult?) {
            val feedback = result?.feedback  // FeedbackResult?
            feedback?.let {
                val summary = it.feedbackSummary       // 피드백 요약 텍스트
                val sections = it.feedback             // 상세 피드백 섹션 목록
                val recommend = it.nextRecommend       // 다음 식사 추천
                val recommendReason = it.nextRecommendReason  // 추천 이유
                val suitability = it.suitability       // 적합성 평가 (GOOD/NORMAL/BAD)
                val foodFeedback = it.foodFeedback     // 개별 음식 피드백
            }
        }

        override fun onCancel() { }
        override fun onError(errorReason: BaseError?) { }
    }
)
```

### FeedbackResult 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `feedbackId` | `String?` | 피드백 고유 ID |
| `feedbackSummary` | `String?` | 피드백 요약 텍스트 |
| `feedback` | `List<FeedbackSection>?` | 상세 피드백 섹션 목록 (코칭 자세히 화면에 표시) |
| `nextRecommend` | `String?` | 다음 식사 추천 메뉴 |
| `nextRecommendReason` | `String?` | 추천 이유 설명 |
| `suitability` | `FeedbackSuitability?` | 적합성 평가 (`result`: GOOD/NORMAL/BAD, `type`: 표시 텍스트) |
| `foodFeedback` | `List<String>?` | 개별 음식별 피드백 (현재 미지원, 빈 배열로 전달되며 추후 지원 예정) |
| `progressState` | `String?` | 피드백 진행 상태 (progress/finish/error) |
| `readIndex` | `Int?` | 비동기 스트리밍 읽기 인덱스 |

## 주의사항

- `setFeedbackConfig()`는 `startFoodLensCamera()` / `startFoodLensGallery()` / `startFoodLensDataEdit()` 등 호출 전에 설정해야 합니다.
- 피드백 생성에는 인식된 음식 데이터가 필요합니다. 인식된 음식이 없으면 에러 카드가 표시됩니다.
- 1일 코칭 횟수는 디바이스 로컬(`SharedPreferences`)에 저장되며, 날짜가 바뀌면 자동 리셋됩니다.
- 피드백 생성 완료 전에 사용자가 식사 기록을 완료하면, 해당 기록의 피드백은 저장되지 않습니다.
