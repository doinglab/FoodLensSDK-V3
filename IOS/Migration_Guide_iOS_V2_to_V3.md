# FoodLens SDK 마이그레이션 가이드 - iOS (V2 → V3)

이 문서는 FoodLens SDK V2에서 V3로 마이그레이션하기 위한 가이드입니다.  
V3는 FoodLens와 CaloAI(FoodLens 2.0)를 모두 지원하는 통합 SDK입니다.

---

## 🔴 필수 변경사항

> 아래 항목들은 **반드시 변경해야** SDK가 정상 동작합니다.

### 1. Requirements 변경

| 구분 | V2 | V3 |
|------|----|----|
| iOS 버전 | 12.0 이상 | **14.0 이상** |
| Swift 버전 | 4.2 이상 | **5.5 이상** |

---

### 2. SDK 설치 방법 변경

#### V2: CocoaPods 또는 SPM
```ruby
# Podfile
pod 'FoodLens', '2.6.7'
```
```
# SPM
https://bitbucket.org/doing-lab/ios_foodlenssdk.git
```

#### V3: SPM만 지원
```
# SPM - UI SDK 사용할 경우
https://bitbucket.org/doing-lab/ios_foodlensuisdk
```

> ⚠️ **CocoaPods 지원 중단**: V3는 SPM만 지원합니다.

---

### 3. 인증 설정 변경 (AccessToken 사용자만 해당)

> ⚠️ **AppToken + CompanyToken 사용 중이라면 변경 없음**

AccessToken만 사용 중이었다면, Doinglab에 문의하여 AppToken과 CompanyToken을 발급받아야 합니다.

#### info.plist 설정
```diff
- // V2: AccessToken 사용 가능했음

+ // V3: AppToken + CompanyToken 필수
+ <key>FoodLensAppToken</key>
+ <string>App Token</string>
+ <key>FoodLensCompanyToken</key>
+ <string>Company Token</string>
```

---

### 4. UI SDK 코드 변경

#### 4.1 서비스 생성
```diff
- FoodLens.uiServiceMode = .userSelectedWithCandidates
- let uiService = FoodLens.createUIService(accessToken: "<Access Token>")
- // 또는
- let uiService = FoodLens.createUIService(appToken: "<App Token>", companyToken: "<Company Token>")

+ let foodlensUIService = FoodLensUIService(type: .foodlens)
+ // FoodLensType: .foodlens 또는 .caloai 선택
```

#### 4.2 카메라/갤러리/검색 시작
```diff
- uiService?.startCameraUIService(parent: self, completionHandler: self)
- uiService?.startGalleryUIService(parent: self, completionHandler: self)
- uiService?.startSearchUIService(parent: self, completionHandler: self)

+ foodlensUIService.startFoodLensCamera(parent: self, completionHandler: handler)
+ foodlensUIService.startFoodLensGallery(parent: self, completionHandler: handler)
+ foodlensUIService.startFoodLensSearch(parent: self, completionHandler: handler)
```

#### 4.3 데이터 수정 기능
```diff
- uiService.startEditUIService(mealData, parent: self, completionHandler: handler)

+ foodlensUIService.startFoodLensDataEdit(recognitionResult: mealData, parent: self, completionHandler: handler)
```

> 전체 구현 예시는 위 V3 전체 코드의 `startDataEdit` 참조

#### 4.4 콜백 핸들러 변경
```diff
- protocol UserServiceResultHandler {
+ protocol RecognitionResultHandler {
      func onSuccess(_ result: RecognitionResult)
      func onCancel()
-     func onError(_ error: BaseError)
+     func onError(_ error: Error)
  }
```

**V3 전체 코드**
```swift
import FoodLensUI
import FoodLensCore

class ViewController: UIViewController {
    let foodlensUIService = FoodLensUIService(type: .foodlens)
    
    // 카메라 시작
    func startCamera() {
        foodlensUIService.startFoodLensCamera(parent: self, completionHandler: ResultHandler())
    }
    
    // 갤러리 시작
    func startGallery() {
        foodlensUIService.startFoodLensGallery(parent: self, completionHandler: ResultHandler())
    }
    
    // 검색 시작
    func startSearch() {
        foodlensUIService.startFoodLensSearch(parent: self, completionHandler: ResultHandler())
    }
    
    // 데이터 수정
    func startDataEdit(image: UIImage, jsonString: String) {
        let imagePath = "my_food_image"
        
        // 1. 수정 화면에 표시할 이미지 저장
        FoodLensStorage.shared.save(image: image, fileName: imagePath)
        
        // 2. RecognitionResult 생성 및 이미지 경로 설정
        let mealData = RecognitionResult.create(json: jsonString)
        mealData.imgPath = imagePath  // 저장한 파일명과 동일해야 함
        
        // 3. 데이터 수정 화면 호출
        foodlensUIService.startFoodLensDataEdit(
            recognitionResult: mealData,
            parent: self,
            completionHandler: ResultHandler()
        )
    }
}

class ResultHandler: RecognitionResultHandler {
    func onSuccess(_ result: FoodLensCore.PredictResult) {
        // 사용자가 선택한 이미지 가져오기
        let image = FoodLensStorage.shared.load(fileName: result.imagePath ?? "")
        
        // 결과 처리
    }
    
    func onCancel() {
        // 취소 처리
    }
    
    func onError(_ error: Error) {
        // 에러 처리
        print(error.localizedDescription)
    }
}
```


---

### 5. 필수 변경사항 요약 테이블

| 구분 | V2 | V3 |
|------|----|----|
| iOS 버전 | 12.0 | **14.0** |
| Swift 버전 | 4.2 | **5.5** |
| 설치 방법 | CocoaPods / SPM | **SPM만** |
| 인증 | AccessToken 가능 | **AppToken+CompanyToken만** |
| 서비스 생성 | `FoodLens.createUIService()` | `FoodLensUIService(type:)` |
| 카메라 시작 | `startCameraUIService()` | `startFoodLensCamera()` |
| 갤러리 시작 | `startGalleryUIService()` | `startFoodLensGallery()` |
| 검색 시작 | `startSearchUIService()` | `startFoodLensSearch()` |
| 데이터 수정 | `startEditUIService()` | `startFoodLensDataEdit()` |
| 콜백 프로토콜 | `UserServiceResultHandler` | `RecognitionResultHandler` |

---

## 🟡 선택적 변경사항

> 아래 항목들은 해당 기능을 사용하는 경우에만 변경하면 됩니다.

### 1. UI 테마 설정 (사용 중인 경우만)

```diff
- let navTheme = NavigationBarTheme(foregroundColor: .white, backgroundColor: .black)
- let toolbarTheme = ToolBarButtonTheme(backgroundColor: .white, buttonTheme: ButtonTheme(...))
- let buttonTheme = ButtonTheme(backgroundColor: .blue, textColor: .green, borderColor: .black)
- let uiService = FoodLens.createUIService(accessToken: "...", 
-                                          navigationBarTheme: navTheme,
-                                          toolbarTheme: toolbarTheme,
-                                          buttonTheme: buttonTheme)

+ let uiConfig = FoodLensUIConfig(
+     mainColor: .green,
+     mainTextColor: .white
+ )
+ foodlensUIService.setUIConfig(uiConfig)
```

### 2. 기능 옵션 설정 (사용 중인 경우만)

```diff
- FoodLens.isEnableCameraOrientation = false
- FoodLens.isEnableManualInput = true
- FoodLens.isSaveToGallery = false
- FoodLens.isUseImageRecordDate = false
- FoodLens.eatType = MealType.init(rawValue: 1)
- FoodLens.isEnablePhtoGallery = true
- FoodLens.language = .en

+ let settingConfig = FoodLensSettingConfig(
+     isEnableCameraOrientation: false,
+     isShowPhotoGalleryIcon: true,
+     isShowManualInputIcon: true,
+     isSaveToGallery: false,
+     isUseEatDatePopup: false,
+     language: .en,
+     eatType: .lunch
+ )
+ foodlensUIService.setSettingConfig(settingConfig)
```

**옵션 매핑**
| V2 | V3 (FoodLensSettingConfig) |
|----|---------------------------|
| `FoodLens.isEnableCameraOrientation` | `isEnableCameraOrientation` |
| `FoodLens.isEnableManualInput` | `isShowManualInputIcon` |
| `FoodLens.isEnablePhtoGallery` | `isShowPhotoGalleryIcon` |
| `FoodLens.isSaveToGallery` | `isSaveToGallery` |
| `FoodLens.isUseImageRecordDate` | `isUseEatDatePopup` |
| `FoodLens.eatType` | `eatType` |
| `FoodLens.eatDate` | `eatDate` |
| `FoodLens.language` | `language` |

### 3. UIServiceMode 변경

V3에서는 `FoodLens.uiServiceMode` 대신 FoodLensType 선택과 옵션으로 대체됩니다.

```diff
- FoodLens.uiServiceMode = .userSelectedWithCandidates
```

**V3 방식**
- `FoodLensType.foodlens` 선택 시 → 기본적으로 candidates 포함
- `FoodLensType.caloai` 선택 시 → `isGenerateCaloAiCandidate` 옵션으로 선택
  ```swift
  let settingConfig = FoodLensSettingConfig(
      isGenerateCaloAiCandidate: true  // candidates 포함 여부
  )
  ```

---

## 🟢 V3 기능 옵션 (선택 사용)

사용하고 싶은 경우에만 추가하면 됩니다.

**FoodLensSettingConfig 전체 옵션**
```swift
let settingConfig = FoodLensSettingConfig(
    isEnableCameraOrientation: true,        // 카메라 회전 기능 (default: true)
    isShowPhotoGalleryIcon: true,           // 갤러리 버튼 표시 (default: true)
    isShowManualInputIcon: true,            // 검색 버튼 표시 (default: true)
    isShowHelpIcon: true,                   // 도움말 버튼 표시 (default: true)
    isSaveToGallery: false,                 // 촬영 이미지 갤러리 저장 (default: false)
    isUseEatDatePopup: true,                // 갤러리 이미지 촬영일 사용 팝업 (default: true)
    imageResizingType: .normal,             // .speed, .normal, .quality (default: .normal)
    language: .ko,                          // .device, .ko, .en, .ja (default: .device)
    eatDate: Date(),                        // 식사 시간 (default: 현재 시간)
    eatType: .lunch,                        // 식사 타입 (default: 시간 기준 자동)
    recommendKcal: 2000,                    // 1일 권장 칼로리 (default: 2000)
    isEnableThousandSeparator: false,       // 천 단위 콤마 (default: false)
    nutrientSummaryDisplayOption: .hidden,  // .hidden, .percentage, .weight (default: .hidden)
    isGenerateCaloAiCandidate: false,       // CaloAI candidates 포함 (default: false)
    isEnableNutritionFactsScan: false,      // 영양성분표 스캔 (default: false)
    isShowMealMemo: true                    // 식사 메모 (default: true)
)
foodlensUIService.setSettingConfig(settingConfig)
```

**FoodLensStorage 사용법**
사용자가 UI에서 선택하여 분석한 이미지를 가져올 수 있고, Data 수정 기능을 사용할 때 이미지를 저장하여 전달할 수 있습니다.

```swift
// 사용자가 선택하여 분석한 사진 가져오기
FoodLensStorage.shared.load(fileName: "food_image")

// 해당 메소드를 통해 UIImage와 이미지 파일 이름만 전달하여 FoodLens 전용 폴더에 저장
FoodLensStorage.shared.save(image: UIImage, fileName: "food_image")
```

---

## 마이그레이션 체크리스트

### 🔴 필수
- [ ] iOS Deployment Target 14.0 이상으로 변경
- [ ] Swift Version 5.5 이상 확인
- [ ] CocoaPods → SPM으로 변경
- [ ] info.plist에 AppToken, CompanyToken 설정
- [ ] 서비스 생성 코드 변경 + FoodLensType 지정
- [ ] 메서드명 변경 (startCameraUIService → startFoodLensCamera 등)
- [ ] 콜백 핸들러 변경 (UserServiceResultHandler → RecognitionResultHandler, BaseError → Error)

### 🟡 선택 (사용 중인 경우만)
- [ ] UI 테마 설정 변경
- [ ] 기능 옵션 설정 변경 (FoodLens.xxx → FoodLensSettingConfig)
- [ ] setUiServiceMode 사용 중이면 제거 (3. UIServiceMode 변경 참조)

---

## 문의

마이그레이션 중 문제가 발생하면 Doinglab 담당자에게 문의해 주세요.
