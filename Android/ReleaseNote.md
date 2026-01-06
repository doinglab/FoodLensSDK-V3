# Android FoodLensSDK Release Note

## Latest versions
### Core SDK: 3.3.2
### UI SDK: 3.3.5

<br/>

## 3.3.5
UI SDK (2026.01.06)
1. Enable automatic image saving for food recognition
2. Fixed API type not being passed correctly between screens
    - Fixed an issue where FoodLensType (FoodLens/CaloAI) was not properly passed when navigating from Info/Edit screens to Search screen
    - This caused the Search API to incorrectly call CaloAI instead of FoodLens in certain navigation paths
3. Fixed keyboard not appearing on Search screen
    - Keyboard now automatically appears when entering the Search screen via "Change Food" button

## 3.3.2
UI SDK (2025.12.04)
1.	Added an option to show or hide DietNotes using isShowMealMemo (default: true)
2.	Minor bug fixes

Core SDK (2025.12.23)
1. V2 API Response Format Support
    - Added toV2JSONString() method to convert V3 recognition results to V2 format
    - Added legacy type compatibility (MealTypeLegacy, RecognitionLegacyResult)

## 3.3.1
UI SDK (2025.11.13) (Compatible : Core SDK 3.3.0)
1. Added nutrition label recognition  
2. Improved recognition accuracy and processing performance  
3. Fixed minor bugs

## 3.3.0
Core SDK (2025.11.13)
1. Added nutrition label parsing engine

## 3.2.5
UI SDK (2025.11.03)
1.	Fixed a date-related issue when searching for food
2.	Fixed an error related to custom nutrient settings
3.	Minor bug fixes

## 3.2.4
UI SDK (2025.10.27)
1.	Fixed an issue where the current date was automatically set when searching for food
2.	Minor stability improvements

## 3.2.3   
UI SDK (2025.10.01)
1. Updated text content 

## 3.2.2   
UI SDK (2025.09.29)
1. UI updates  
2. Fixed minor bugs  

## 3.2.1
UI SDK (2025.09.17)
1. UX improvements for better usability  
2. Separated portion editing and food changes for quicker modifications  
4. Other bug fixes

## 3.2.0
Core SDK (2025.09.17)
1. Modified API response: introduced `detailCounts` by refining the `counts` field  
2. Added option to return `candidates` in CaloAI


## v3.1.92
(2025.07.18)
1. Improved text alignment and sizing for better readability
2. Adjusted color contrast to enhance visual clarity
3. Refined overall UI layout for a cleaner interface

## v3.1.7
(2025.07.14)
1. Updated the target SDK version to 35.
2. Fix minor bugs

## v3.1.6
(2025.06.16)
1. Enhanced UI compatibility with Android 15 (API level 35)  
2. Added support for status bar and navigation bar insets  
3. Improved edge-to-edge layout handling for gesture navigation
4. Fix minor bugs

## v3.1.5
(2025.06.12)
1. Added support for 16KB page size on Android 15+ devices
2. Fix minor bugs

## v3.1.4
(2025.05.30)  
1. Improve usability
2. Fix minor bugs

## v3.1.3
(2025.03.11)  
1. Improve usability  
2. Update text content  
3. Fix minor bugs  

## v3.1.2
(2025.03.06)
UI SDK
1. Added option to use commas between thousands

(2025.07.14)
CoreSDK
1. Updated the target SDK version to 35.
2. Fix minor bugs

## v3.1.1
(2025.02.28)
1. Expand customizable UI options for more flexibility

## v3.1.0
(2025.01.16)
(Compatible : Core SDK 3.0.9)
1. Improve the UI for user convenience
2. Fix other bugs

## v3.0.9
(2024.11.20)
UI SDK   
(Compatible : Core SDK 3.0.7)
1. Add Custom Food Provider
2. Change the photo import function to Photo Picker
3. Removed the READ_MEDIA_IMAGES permission
4. Bug Fixes

(2025.02.10)
Core SDK
1. Performance improvements

## v3.0.7
(2024.11.20)
Core SDK   
(Compatible : UI SDK 3.0.9)
1. Performance Improvements   

## v3.0.6
(2024.09.11)
UI SDK
1. Fixed issue with repeated permission requests when adding optional permissions

## v3.0.5
(2024.08.08)
Core, UI SDK
1. Add food search API for CaloAI
2. Add EstimatedAmount, Ingredient fields

## v3.0.4
(2024.07.11)
Core SDK
1. Add nutrition groups

## v3.0.3
(2024.07.11)
UI SDK
1. Add nutrition groups

## v3.0.2
(2024.05.10)
1. Modify and add nutriention groups
2. Add Japanese UI support
3. Add legacy JSON compatibility features
   
## v3.0.1
(2024.04.30)
1. Initial version of FoodLensSDK v3.0
