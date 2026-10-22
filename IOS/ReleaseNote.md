# iOS FoodLensSDK Release Note

## Latest versions
### Core SDK: 3.4.4
### UI SDK: 3.4.6

<br/>

## Version history
### 3.4.6
UI SDK (2026.10.22)
1. Added ingredient editing
    - Adds an **[Edit Ingredients]** button to the portion edit sheet
    - Change the weight of each ingredient, remove ingredients, or search and add new ones; nutrition is recalculated and applied to the result
    - Enable with `FoodLensSettingConfig.isEnableIngredientEdit = true` (default: `false`)
2. Added Daily Report screen
    - Shows the day's score, nutrition balance, and meal timeline
    - Launch with `FoodLensUIService.startFoodLensDailyReport()`
3. Added a tooltip on the meal summary screen when the meal time does not match the meal type
4. Removed the bundled SF Pro font and the `SFProFont` API — public API change
    - Apps that embed Apple-provided fonts will be rejected by the App Store from 2027.10.01 (ITMS-91182)
    - Remove any `SFProFont.registerFonts()` / `removeFonts()` calls from your app
    - Rendering is unchanged — the registered font was never actually used
    - Resource bundle size: 17MB → 1.0MB
5. Added layout support for foldable devices (iPhone Duo)
    - Handles fold / unfold transitions and asymmetric safe areas
6. Requires Core SDK 3.4.4 or later
7. Bug fixes

### 3.4.5
UI SDK (2026.10.13)
1. Added `outputImageSizeOption` to `FoodLensSettingConfig` (default: `.medium`)
    - Controls the image shown on the result screen and delivered to the host — both are the same file
    - Also applies to nutrition label scans; `Position` is scaled to the delivered image
2. Changed the size of images shown on the result screen and delivered to the host
    - Previously saved at the original size; now follows `outputImageSizeOption` (default 2048)
    - `Position` is based on this image. Set `.high` to keep a size closer to the previous one
3. `FoodLensUIService` is now `@MainActor` (Swift 6 concurrency); call it from the main thread
4. Requires Swift tools 5.10 (Xcode 15.3+)
5. Bug fixes

### 3.4.4
Core SDK (2026.10.22)
1. Added ingredient APIs
    - `searchIngredientByName()`: search ingredients
    - `ingredientInfo()`: get nutrition for a list of ingredients
2. Added daily feedback APIs
    - `feedbackDay()`: request daily feedback
    - `getFeedbackDay()`: fetch the daily feedback result
3. Changed macro values in daily feedback to server-provided ratios — behavior change
    - Previously intake in grams; now a 0–100 ratio whose present values sum to 100
    - Do not recalculate on the client (no Atwater 4·4·9, no ×100)
4. Bug fixes

UI SDK (2026.06.19)
1. Added multi-select in food search
    - Select up to 10 items at once on the food search screen
2. Refreshed meal summary UX
    - Improved date / time picker UX
3. Bug fixes

### 3.4.3
Core SDK (2026.10.13)
1. Added `OutputImageSizeOption` for images delivered to the host
    - `.low` (1024) / `.medium` (2048, default) / `.high` (3072) — a cap on the shorter edge; images smaller than the cap are not upscaled
    - Set with `setOutputImageSizeOption(_:)`, independent of `setImageResizingType(_:)`, which controls only the image sent to the recognition server
    - Applies to `RecognitionResult.imagePath`, the `Food[].imagePath` crops, and the coordinate space of `Position` when `setSaveImageToFile(true)`
2. Changed the size of images delivered to the host
    - Previously saved at the original size; now follows `OutputImageSizeOption` (default 2048)
    - With `setSaveImageToFile(true)`, `Position` is now based on the saved image. Set `.high` to keep a size closer to the previous one
    - With `setSaveImageToFile(false)`, `Position` is unchanged (based on the image you pass in)
3. Server upload JPEG quality now follows `ImageResizingType` (`.speed` 0.8 / `.normal` 0.9 / `.quality` 1.0)
4. Fixed images smaller than the `ImageResizingType` limit being upscaled before upload
5. Requires Swift tools 5.10 (Xcode 15.3+)

UI SDK (2026.04.22)
1. Fixed an issue where feedback POST requests were intermittently sent even when `isEnabledFeedback = false`
    - Ensures no feedback API calls are made when the feature is disabled

### 3.4.2
Core SDK (2026.06.19)
1. Public API change
    - Renamed `recognizeNutritionFacts` → `scanNutritionFacts`
2. Meal feedback API overhaul
    - Migrated endpoint to `/analysis/feedback/meal`
    - Removed `FeedbackOption.nutrientRatio`, added `feedbackDietMethod`
3. Food search autocomplete API extended
    - Added `count` / `detail` parameters
4. Bug fixes

UI SDK (2026.04.16)
1. Added `isEnabledFeedback` option to `FoodLensSettingConfig` (default: true)
    - Controls the overall activation of the AI Meal Coaching (Feedback) feature
    - When `false`, the coaching card/feedback UI is not displayed regardless of whether `setFeedbackConfig()` is called
2. Made `FoodLensFeedbackConfig` fields optional (sex, feedbackPurposeDetail, feedbackTone)
    - `FoodLensFeedbackConfig` can now be created without any arguments

### 3.4.1
Core SDK (2026.04.16)
1. Made FeedbackOptionRequest fields optional (sex, recommendCalorie, feedbackPurposeDetail, eatTime, eatType, feedbackTone)

### 3.4.0
Core SDK (2026.04.10)
1. Added AI Meal Coaching (Feedback) model

UI SDK (2026.04.10)
1. Added AI Meal Coaching (Feedback) feature
    - Provides AI feedback coaching card based on meal record analysis
    - Displays feedback summary, suitability rating (GOOD/NORMAL/BAD), and recipe recommendations
    - Coaching detail screen (detailed feedback sections, nutrient ratio, recommended food tip box)

### 3.3.6                                                                                                                                                                                                             
UI SDK (2026.02.10)                                                                                       
1. Added screen_view logging when switching from camera to gallery
    - Tracks user navigation from camera screen to gallery picker for better analytics                      
2. Added nutrition label scanning related logs
    - Improved analytics tracking for nutrition label scan feature usage
3. Applied mainColor from uiConfig to nutrition label button
    - Nutrition label button now respects the mainColor setting configured in uiConfig for consistent theming
4. Fixed counts displaying empty string instead of default unit
    - When counts value is empty, now properly displays default unit (serving/servings) instead of blank ext
5. Fixed camera/gallery screenView logging issues
    - Corrected screen view event tracking for camera and gallery screens

### 3.3.5
UI SDK (2026.01.09)
1. Fixed camera resource not being released when logging nutrition after selecting photo from gallery
    - Previously, when users selected a photo from the gallery (instead of capturing with camera) and successfully logged nutrition, the camera session remained active, causing camera resource leaks
    - Added stopCameraSession() call in FoodCameraView's onDisappear to ensure camera resources are properly released when navigating away from the camera screen

### 3.3.4
UI SDK (2026.01.06)
1. Improved image loading via imagePath when position is not available
    - Support saving images with full file:// path
    - DataEdit mode can now load food images using imagePath without position
  
### 3.3.3
Core SDK (2026.02.10)                                                                                   
1. Fixed FoodLensType dynamic selection not being applied in Closure/Combine APIs                         
    - Previously, FoodLensType was only dynamically selected in async/await APIs                            
    - Now properly applies dynamic FoodLensType selection across all API styles (Closure, Combine, async/await)  

### 3.3.2
UI SDK (2025.12.23)
1. Enable image file saving by default during food recognition
    - Added FoodLensCoreService.setSaveImageToFile(true) configuration
    - Images used for recognition are now automatically saved to local storage

Core SDK (2025.12.23)
1. V2 API Response Format Support
    - Added toV2JSONString() method to convert V3 recognition results to V2 format
    - Added legacy type compatibility (MealTypeLegacy, RecognitionLegacyResult)

### 3.3.1
UI SDK (2025.12.04)
1.	Added an option to show or hide DietNotes using isShowMealMemo (default: true)
2.	Minor bug fixes

### 3.3.0
UI SDK (2025.11.13)
1. Added nutrition label recognition  
2. Improved recognition accuracy and processing performance  
3. Fixed minor bugs

Core SDK (2025.11.13)
1. Added nutrition label parsing engine

### 3.2.5
UI SDK (2025.10.27)
1. Expanded touch area of the back button
2. Minor stability improvements

### 3.2.4
UI SDK (2025.10.01)
1. Fixed swipe-back behavior  
2. Adjusted ScrollView bounce handling for iOS 26  
3. Other bug fixes  

### 3.2.3
UI SDK (2025.09.29)
1. UI updates  
2. Fixed minor bugs  

### 3.2.2
UI SDK (2025.09.22)
1. Improved image resizing method for better performance and quality

### 3.2.1
UI SDK (2025.09.18)
1. UX improvements for better usability  
2. Separated portion editing and food changes for quicker modifications  
3. Support for iOS 26  
4. Other bug fixes

### 3.2.0
Core SDK (2025.09.17)
1. Modified API response: introduced `detailCounts` by refining the `counts` field  
2. Added option to return `candidates` in CaloAI

### 3.1.81
UI SDK (2025.07.18)
1. Improved text alignment and sizing for better readability
2. Adjusted color contrast to enhance visual clarity
3. Refined overall UI layout for a cleaner interface

### v3.1.6
UI SDK (2025.03.11)
1.	Update text content
2.	Fix minor bugs

### v3.1.5
UI SDK (2025.03.06)
1.	Add an option for thousand separators
2.	Fix minor bugs

### v3.1.4
UI SDK (2025.02.28)
1. Support swipe-back gesture for better navigation
2. Expand customizable UI options for more flexibility
3. Fix other bugs

### v3.1.3
UI SDK (2025.01.24)
1. Improve the UI for user convenience
2. Fix other bugs

### v3.1.0
Core SDK (2025.02.28)
1. Add support for Swift 6

### v3.0.5
Core SDK (2024.11.28)
1. Performance Enhancements

UI SDK (2024.11.28)
1. Add `CustomFoodDelegate`
2. Performance Enhancements
3. Fix other bugs

### v3.0.4
Core SDK (2024.08.08)
1. Add food search API for CaloAI
2. Add EstimatedAmount, Ingredient fields
3. Add PrivacyInfo.xcprivacy

### v3.0.3
UI SDK (2024.08.08)
1. Add PrivacyInfo.xcprivacy

Core SDK (2024.07.10)
1. Add nutrition groups

### v3.0.2
UI SDK (2024.05.14)
1. Add Japanese UI support
2. Add legacy JSON compatibility features

Core SDK (2024.05.14)
1. Modify and add nutrition groups

### v3.0.1
UI SDK, Core SDK (2024.04.30)
1. Initial version of FoodLensSDK v3.0
