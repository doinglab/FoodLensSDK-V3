# AI Meal Coaching (Feedback) Configuration Guide

## Overview

The AI Meal Coaching feature of the FoodLens SDK analyzes user meal records and provides AI-based feedback. To use this feature, configure `FoodLensFeedbackConfig` and call `setFeedbackConfig()`.

## Basic Configuration

```swift
let uiService = FoodLensUIService(type: .foodlens)

// Enable feedback (minimum configuration)
uiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex: .male
))

// Enable feedback (with user info + recommended calorie)
uiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex: .male,
    age: 30,
    height: 170,
    feedbackPurposeDetail: .keep
))
var settingConfig = FoodLensSettingConfig()
settingConfig.recommendedKcal = 2200  // Default: 2000
uiService.setSettingConfig(settingConfig)

// Disable feedback
uiService.setFeedbackConfig(nil)
```

> If you call `setFeedbackConfig(nil)` or do not call `setFeedbackConfig()`, the coaching card will not be displayed.

## Configuration Options

### User Information

| Option | Type | Default | Description |
|---|---|---|---|
| `sex` | `Sex` | (required) | Gender (`.male`, `.female`) |
| `age` | `Double?` | `nil` | Age (server default if not set) |
| `height` | `Double?` | `nil` | Height in cm (server default if not set) |
| `feedbackPurposeDetail` | `FeedbackPurposeDetail` | `.keep` | Goal detail (`.keep`: maintain, `.lose`: lose weight, `.gain`: gain weight) |

> **⚠️ Daily recommended calories (`recommendedKcal`) directly affects feedback quality and must be configured.** Set it via `FoodLensSettingConfig.recommendedKcal`, not `FoodLensFeedbackConfig`. This value is automatically used as the `recommendCalorie` parameter in feedback requests. The default is `2000`, but it is strongly recommended to set the actual recommended calories for accurate personalized feedback.

### Feedback Generation Options

| Option | Type | Default | Description |
|---|---|---|---|
| `generateFeedback` | `Bool` | `true` | Whether to generate feedback |
| `feedbackMode` | `FeedbackMode` | `.async` | Feedback mode (`.sync`, `.async`) |
| `feedbackTone` | `[String]` | `[]` | Feedback tone per rating (server default if empty) |

#### feedbackTone

AI coaching analyzes meals and rates them as **GOOD / NORMAL / BAD**. You can customize the feedback tone for each rating using `feedbackTone`.

The array index maps to the rating as follows:

| Index | Rating | Server Default Tone |
|---|---|---|
| `[0]` | GOOD | Friendly praise, specifically pointing out what was done well without exaggeration |
| `[1]` | NORMAL | Gently convey areas for improvement, point out issues without blame |
| `[2]` | BAD | Express concern and explain meal issues in detail, no criticism |

- Passing an empty array (`[]`) applies the server default tones above.
- When customizing, you must provide all 3 items in GOOD / NORMAL / BAD order.

```swift
// Example: Custom tones
uiService.setFeedbackConfig(FoodLensFeedbackConfig(
    sex: .male,
    feedbackTone: [
        "Praise brightly with a celebratory tone",       // GOOD
        "Calmly suggest areas for improvement",           // NORMAL
        "Seriously warn about health risks"               // BAD
    ]
))
```

### UI / Limit Options

| Option | Type | Default | Description |
|---|---|---|---|
| `maxDailyCoachingCount` | `Int` | `-1` | Max coaching count per day |
| `maxRetryCount` | `Int` | `-1` | Retry count per session (meal record) |
| `dataEditMaxRetryCount` | `Int?` | `0` | Retry count for dataEdit mode (`nil` = follows `maxRetryCount`, `0` = no retry) |
| `showFullFeedback` | `Bool` | `false` | Whether to show full feedback text on coaching card |
| `isShowRecipe` | `Bool` | `true` | Whether to show recipe recommendations on coaching card/detail |

#### maxDailyCoachingCount / maxRetryCount Values

| Value | Behavior |
|---|---|
| `-1` | Unlimited |
| `0` | Disabled (coaching UI hidden / no retry) |
| Positive | Limited to that count |

> When `maxDailyCoachingCount` is `0`, it behaves the same as `setFeedbackConfig(nil)` — the coaching card is not displayed.

#### dataEditMaxRetryCount Values

| Value | Behavior |
|---|---|
| `nil` | Follows `maxRetryCount` |
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

```swift
uiService.startFoodLensDataEdit(
    recognitionResult: recognitionResult,
    parent: self,
    completionHandler: handler,
    isAutoRefreshFeedback: true  // Default: false
)
```

## Receiving Feedback Results in Callbacks

You can receive feedback results via `RecognitionResult.feedback` in the SDK completion callback (`RecognitionResultHandler`).

```swift
class MyHandler: RecognitionResultHandler {
    func onSuccess(_ result: RecognitionResult) {
        if let feedback = result.feedback {
            let summary = feedback.feedbackSummary       // Feedback summary text
            let sections = feedback.feedback             // Detailed feedback sections
            let recommend = feedback.nextRecommend       // Next meal recommendation
            let recommendReason = feedback.nextRecommendReason  // Recommendation reason
            let suitability = feedback.suitability       // Suitability rating (GOOD/NORMAL/BAD)
            let foodFeedback = feedback.foodFeedback     // Per-food feedback
        }
    }

    func onCancel() { }
    func onError(_ error: Error) { }
}
```

### FeedbackResult Fields

| Field | Type | Description |
|---|---|---|
| `feedbackId` | `String?` | Feedback unique ID |
| `feedbackSummary` | `String?` | Feedback summary text |
| `feedback` | `[FeedbackSection]?` | Detailed feedback sections (displayed on coaching detail screen) |
| `nextRecommend` | `String?` | Next meal recommendation |
| `nextRecommendReason` | `String?` | Recommendation reason |
| `suitability` | `FeedbackSuitability?` | Suitability rating (`result`: GOOD/NORMAL/BAD, `type`: display text) |
| `foodFeedback` | `[String]?` | Per-food feedback (currently unsupported, returns empty array, planned for future) |
| `progressState` | `FeedbackProgressState?` | Feedback progress state (`.progress` / `.finish` / `.error`) |
| `readIndex` | `Int?` | Async streaming read index |

## Notes

- `setFeedbackConfig()` must be called before `startFoodLensCamera()` / `startFoodLensGallery()` / `startFoodLensDataEdit()`.
- Feedback generation requires recognized food data. An error card is displayed if no food is recognized.
- Daily coaching count is stored locally on the device (`UserDefaults`) and auto-resets when the date changes.
- If the user completes the meal record before feedback generation finishes, the feedback for that record will not be saved.
