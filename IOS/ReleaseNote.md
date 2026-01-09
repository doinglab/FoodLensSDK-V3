# iOS FoodLensSDK Release Note

## Latest versions
### Core SDK: 3.3.2
### UI SDK: 3.3.5

<br/>

## Version history

### 3.3.4
UI SDK (2026.01.09)
1. Fixed camera resource not being released when logging nutrition after selecting photo from gallery
    - Previously, when users selected a photo from the gallery (instead of capturing with camera) and successfully logged nutrition, the camera session remained active, causing camera resource leaks
    - Added stopCameraSession() call in FoodCameraView's onDisappear to ensure camera resources are properly released when navigating away from the camera screen

### 3.3.4
UI SDK (2026.01.06)
1. Improved image loading via imagePath when position is not available
    - Support saving images with full file:// path
    - DataEdit mode can now load food images using imagePath without position

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
