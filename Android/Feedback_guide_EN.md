# AI Meal Coaching (Feedback) Configuration Guide

## Overview

The FoodLens SDK's AI Meal Coaching feature analyzes a user's meal records and provides AI-based feedback. To use this feature, configure `FoodLensFeedbackConfig` and call `setFeedbackConfig()`.

## Basic Setup

```kotlin
val foodLensUiService = FoodLensUI.createFoodLensService(context, FoodLensType.CaloAI)

// Enable feedback (recommended setup)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE
))
foodLensUiService.setSettingConfig(FoodLensSettingConfig().apply {
    recommendedKcal = 2200f  // Defaults to 2000 if not set
})

// Enable feedback (with user info)
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    age = 30.0,
    height = 170.0,
    feedbackPurposeDetail = FeedbackPurposeDetail.KEEP
))

// Disable feedback
foodLensUiService.setSettingConfig(FoodLensSettingConfig().apply {
    isEnabledFeedback = false
})
```

> - Every field on `FoodLensFeedbackConfig` is optional, so it can be created without arguments (`FoodLensFeedbackConfig()`). However, setting `sex` and `recommendedKcal` is recommended for better feedback quality.
> - Feedback enable/disable is controlled by `FoodLensSettingConfig.isEnabledFeedback` (default `true`). When set to `false`, the coaching card is not displayed regardless of whether `setFeedbackConfig()` is called.

## Configuration Options

### FoodLensSettingConfig (Feedback-related)

| Option | Type | Default | Description |
|---|---|---|---|
| `isEnabledFeedback` | `Boolean` | `true` | Whether the feedback feature is enabled. When `false`, the coaching card / feedback UI is not shown regardless of `setFeedbackConfig()` call |

### User Information

| Option | Type | Default | Description |
|---|---|---|---|
| `sex` | `Sex?` | `null` | Gender (`MALE`, `FEMALE`) |
| `age` | `Double?` | `null` | Age (server default is used if not set) |
| `height` | `Double?` | `null` | Height in cm (server default is used if not set) |
| `feedbackPurposeDetail` | `FeedbackPurposeDetail?` | `null` | Purpose detail (`KEEP`: maintain, `LOSE`: lose weight, `GAIN`: gain weight) |

> **⚠️ `sex` and daily recommended calories (`recommendedKcal`) directly affect feedback quality, so setting them is strongly recommended.** `sex` is configured in `FoodLensFeedbackConfig`, and `recommendedKcal` is configured in `FoodLensSettingConfig`. `recommendedKcal` is automatically passed as the `recommendCalorie` parameter when requesting feedback; if not set, the default value `2000` is used.

### Feedback Generation Options

| Option | Type | Default | Description |
|---|---|---|---|
| `generateFeedback` | `Boolean` | `true` | Whether to generate feedback |
| `feedbackMode` | `FeedbackMode` | `ASYNC` | Feedback mode (`SYNC`, `ASYNC`) |
| `feedbackTone` | `List<String>?` | `null` | Per-verdict feedback tone (server default is used if not set or empty) |

#### feedbackTone

AI coaching analyzes each meal and classifies it into one of three verdicts: **GOOD / NORMAL / BAD**. Setting `feedbackTone` lets you customize the feedback tone for each verdict.

The list index maps to the verdict as follows.

| Index | Verdict | Server Default Tone |
|---|---|---|
| `[0]` | GOOD | Warmly compliment, highlighting what was done well concretely without exaggeration |
| `[1]` | NORMAL | Gently convey what could be improved; point out issues without blaming |
| `[2]` | BAD | Explain the meal's problems in detail with a concerned tone; do not blame |

- Passing `null` or an empty list (`emptyList()`) applies the server default tone above.
- When customizing, you must provide all three entries in GOOD / NORMAL / BAD order.

```kotlin
// Example: fully customized tones
foodLensUiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex = Sex.MALE,
    feedbackTone = listOf(
        "Praise brightly with a celebratory feel",   // GOOD
        "Calmly point out what could be improved",   // NORMAL
        "Seriously warn about health risks"          // BAD
    )
))
```

### UI / Count Limit Options

| Option | Type | Default | Description |
|---|---|---|---|
| `maxDailyCoachingCount` | `Int` | `-1` | Max coaching count per day |
| `maxRetryCount` | `Int` | `-1` | Retry count per session (meal record) |
| `dataEditMaxRetryCount` | `Int?` | `0` | Retry count for dataEdit mode (`null` = follows `maxRetryCount`, `0` = retry disabled) |
| `showFullFeedback` | `Boolean` | `false` | Whether to show full feedback content on the coaching card |
| `isShowRecipe` | `Boolean` | `true` | Whether to show recipes (recommended foods) on the coaching card / detail screen |

#### maxDailyCoachingCount / maxRetryCount Value Rules

| Value | Behavior |
|---|---|
| `-1` | Unlimited |
| `0` | Disabled (coaching UI hidden / retry disabled) |
| Positive | Limited to the specified count |

> If `maxDailyCoachingCount` is `0`, the coaching card is not displayed, same as `isEnabledFeedback = false`.

#### dataEditMaxRetryCount Value Rules

| Value | Behavior |
|---|---|
| `null` | Follows `maxRetryCount` |
| `-1` | Unlimited |
| `0` | Disabled (displays if feedback data exists) |
| Positive | Limited to the specified count |

#### showFullFeedback

| Value | Behavior |
|---|---|
| `false` (default) | Feedback body limited to 2 lines |
| `true` | Feedback body fully displayed; card height expands automatically |

#### isShowRecipe

| Value | Behavior |
|---|---|
| `true` (default) | Shows the recipe recommendation area on the coaching card and detail screen |
| `false` | Hides the recipe recommendation area |

### dataEdit Options

> The option below is a parameter of `startFoodLensDataEdit()`, not of `FoodLensFeedbackConfig`.

#### isAutoRefreshFeedback

| Value | Behavior |
|---|---|
| `false` (default) | If existing feedback data exists, display as-is; otherwise hide the coaching card. On food edit, only an edit-notice snackbar is shown |
| `true` | If no existing feedback data, automatically re-call the feedback API. On food edit, a "coach again" snackbar is shown |

> For new recognitions (`startFoodLensCamera`, etc.), feedback is always auto-generated, so this option does not apply.

```kotlin
foodLensUiService.startFoodLensDataEdit(
    activity = activity,
    activityResult = activityResultLauncher,
    recognitionResult = recognitionResult,
    handler = handler,
    isAutoRefreshFeedback = true  // default: false
)
```

## Receiving Feedback Results in the Callback

You can receive the feedback result from `RecognitionResult.feedback` in the SDK completion callback (`UIServiceResultHandler`).

```kotlin
foodLensUiService.startFoodLensCamera(activity, activityResultLauncher,
    object : UIServiceResultHandler {
        override fun onSuccess(result: RecognitionResult?) {
            val feedback = result?.feedback  // FeedbackResult?
            feedback?.let {
                val summary = it.feedbackSummary       // Feedback summary text
                val sections = it.feedback             // Detailed feedback section list
                val recommend = it.nextRecommend       // Next meal recommendation
                val recommendReason = it.nextRecommendReason  // Reason for recommendation
                val suitability = it.suitability       // Suitability verdict (GOOD/NORMAL/BAD)
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
| `feedbackId` | `String?` | Unique feedback ID |
| `feedbackSummary` | `String?` | Feedback summary text |
| `feedback` | `List<FeedbackSection>?` | Detailed feedback section list (shown on the coaching detail screen) |
| `nextRecommend` | `String?` | Next meal recommendation menu |
| `nextRecommendReason` | `String?` | Reason for the recommendation |
| `suitability` | `FeedbackSuitability?` | Suitability verdict (`result`: GOOD/NORMAL/BAD, `type`: display text) |
| `foodFeedback` | `List<String>?` | Per-food feedback (currently not supported; returned as an empty array, to be supported later) |
| `progressState` | `String?` | Feedback progress state (`progress` / `finish` / `error`) |
| `readIndex` | `Int?` | Async streaming read index |

## Notes

- `setFeedbackConfig()` must be called before `startFoodLensCamera()` / `startFoodLensGallery()` / `startFoodLensDataEdit()`, etc.
- Feedback generation requires recognized food data. If no food is recognized, an error card is shown.
- The daily coaching count is stored on the device (`SharedPreferences`) and is automatically reset when the date changes.
- If the user completes the meal record before feedback generation finishes, the feedback for that record is not saved.
