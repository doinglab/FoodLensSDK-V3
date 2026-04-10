# AI Meal Coaching (Feedback) Configuration Guide

## Overview

The AI Meal Coaching feature of the FoodLens SDK analyzes user meal records and provides AI-based feedback. To use this feature, configure `FoodLensFeedbackConfig` and call `setFeedbackConfig()`.

## Basic Configuration

```kotlin
val foodLensUiService: FoodLensUIService = ...

// Enable feedback (minimum configuration - only sex is required)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE
))

// Enable feedback (with user info + recommended calorie)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    age = 30.0,
    height = 170.0,
    feedbackPurposeDetail = FeedbackPurposeDetail.KEEP
))
foodLensUiService.setSettingConfig(FoodLensSettingConfig().apply {
    recommendedKcal = 2200f  // Default: 2000
})

// Disable feedback
foodLensUiService.setFeedbackConfig(null)
```

> If you call `setFeedbackConfig(null)` or do not call `setFeedbackConfig()`, the coaching card will not be displayed.

## Configuration Options

### User Information

| Option | Type | Default | Description |
|---|---|---|---|
| `sex` | `Sex` | (required) | Gender (`MALE`, `FEMALE`) |
| `age` | `Double?` | `null` | Age |
| `height` | `Double?` | `null` | Height in cm |
| `feedbackPurposeDetail` | `FeedbackPurposeDetail` | `KEEP` | Goal detail (`KEEP`: maintain, `LOSE`: lose weight, `GAIN`: gain weight) |

> **⚠️ Daily recommended calories (`recommendedKcal`) directly affects feedback quality and must be configured.** Set it via `FoodLensSettingConfig.recommendedKcal`, not `FoodLensFeedbackConfig`. This value is automatically used as the `recommendCalorie` parameter in feedback requests. The default is `2000`, but it is strongly recommended to set the actual recommended calories for accurate personalized feedback.

### Feedback Generation Options

| Option | Type | Default | Description |
|---|---|---|---|
| `generateFeedback` | `Boolean` | `true` | Whether to generate feedback |
| `feedbackMode` | `FeedbackMode` | `ASYNC` | Feedback mode (`SYNC`, `ASYNC`) |
| `feedbackTone` | `List<String>` | `emptyList()` | Feedback tone per rating (server default if empty) |

#### feedbackTone

AI coaching analyzes meals and rates them as **GOOD / NORMAL / BAD**. You can customize the feedback tone for each rating using `feedbackTone`.

Each list index maps to a rating:

| Index | Rating | Server Default Tone |
|---|---|---|
| `[0]` | GOOD | Friendly praise, specifically pointing out what was done well without exaggeration |
| `[1]` | NORMAL | Gently convey areas for improvement, point out issues without blame |
| `[2]` | BAD | Express concern and explain meal issues in detail, no criticism |

- Passing an empty list (`emptyList()`) applies the server default tones above.
- When customizing, you must provide all 3 items in GOOD / NORMAL / BAD order.

```kotlin
// Example: Custom tones
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    feedbackTone = listOf(
        "Praise brightly with a celebratory tone",       // GOOD
        "Calmly suggest areas for improvement",           // NORMAL
        "Seriously warn about health risks"               // BAD
    )
))
```

### UI / Limit Options

| Option | Type | Default | Description |
|---|---|---|---|
| `maxDailyCoachingCount` | `Int` | `-1` | Max coaching count per day |
| `maxRetryCount` | `Int` | `-1` | Retry count per session (meal record) |
| `dataEditMaxRetryCount` | `Int?` | `0` | Retry count for dataEdit mode (`null`: follows `maxRetryCount`) |
| `showFullFeedback` | `Boolean` | `false` | Whether to show full feedback text on coaching card |
| `isShowRecipe` | `Boolean` | `true` | Whether to show recipe recommendations on coaching card |

#### maxDailyCoachingCount / maxRetryCount Values

| Value | Behavior |
|---|---|
| `-1` | Unlimited |
| `0` | Disabled (coaching UI hidden / no retry) |
| Positive | Limited to that count |

> When `maxDailyCoachingCount` is `0`, it behaves the same as `setFeedbackConfig(null)` — the coaching card is not displayed.

#### dataEditMaxRetryCount Values

| Value | Behavior |
|---|---|
| `null` | Follows `maxRetryCount` |
| `-1` | Unlimited |
| `0` | Disabled (shows feedback if available) |
| Positive | Limited to that count |

#### showFullFeedback

| Value | Behavior |
|---|---|
| `false` (default) | Feedback text limited to 2 lines |
| `true` | Full feedback text displayed, card height auto-expands |

#### isShowRecipe

| Value | Behavior |
|---|---|
| `true` (default) | Recipe recommendation area shown on coaching card and detail screen |
| `false` | Recipe recommendation area hidden |

### dataEdit Options

> The following option is a parameter of `startFoodLensDataEdit()`, not `FoodLensFeedbackConfig`.

#### isAutoRefreshFeedback

| Value | Behavior |
|---|---|
| `false` (default) | Shows existing feedback data if available, hides coaching card if none. Shows edit notification snackbar on food modification |
| `true` | Automatically re-fetches feedback if no existing data. Shows "refresh coaching" snackbar on food modification |

> For new recognition (`startFoodLensCamera`, etc.), feedback is always auto-generated, so this option does not apply.

```kotlin
foodLensUiService.startFoodLensDataEdit(
    activity = activity,
    activityResult = activityResultLauncher,
    recognitionResult = recognitionResult,
    handler = handler,
    isAutoRefreshFeedback = true  // Default: false
)
```


## Receiving Feedback Results in Callbacks

You can receive feedback results via `RecognitionResult.feedback` in the SDK completion callback (`UIServiceResultHandler`).

```kotlin
foodLensUiService.startFoodLensCamera(activity, activityResultLauncher,
    object : UIServiceResultHandler {
        override fun onSuccess(result: RecognitionResult?) {
            val feedback = result?.feedback  // FeedbackResult?
            feedback?.let {
                val summary = it.feedbackSummary       // Feedback summary text
                val sections = it.feedback             // Detailed feedback sections
                val recommend = it.nextRecommend       // Next meal recommendation
                val recommendReason = it.nextRecommendReason  // Recommendation reason
                val suitability = it.suitability       // Suitability rating (GOOD/NORMAL/BAD)
                val foodFeedback = it.foodFeedback     // Per-food feedback
            }
        }

        override fun onCancel() { }
        override fun onError(errorReason: BaseError?) { }
    }
)
```

### FeedbackResult Fields

| Field | Type | Description |
|---|---|---|
| `feedbackId` | `String?` | Feedback unique ID |
| `feedbackSummary` | `String?` | Feedback summary text |
| `feedback` | `List<FeedbackSection>?` | Detailed feedback sections (displayed on coaching detail screen) |
| `nextRecommend` | `String?` | Next meal recommendation |
| `nextRecommendReason` | `String?` | Recommendation reason |
| `suitability` | `FeedbackSuitability?` | Suitability rating (`result`: GOOD/NORMAL/BAD, `type`: display text) |
| `foodFeedback` | `List<String>?` | Per-food feedback (currently unsupported, returns empty list, planned for future) |
| `progressState` | `String?` | Feedback progress state (progress/finish/error) |
| `readIndex` | `Int?` | Async streaming read index |

## Notes

- `setFeedbackConfig()` must be called before `startFoodLensCamera()` / `startFoodLensGallery()` / `startFoodLensDataEdit()`.
- Feedback generation requires recognized food data. An error card is displayed if no food is recognized.
- Daily coaching count is stored locally on the device (`SharedPreferences`) and auto-resets when the date changes.
- If the user completes the meal record before feedback generation finishes, the feedback for that record will not be saved.
