# FoodLens SDK 마이그레이션 가이드 (V2 → V3)

이 문서는 FoodLens SDK V2에서 V3로 마이그레이션하기 위한 가이드입니다.  
V3는 FoodLens와 CaloAI(FoodLens 2.0)를 모두 지원하는 통합 SDK입니다.

---

## 🔴 필수 변경사항

> 아래 항목들은 **반드시 변경해야** SDK가 정상 동작합니다.

### 1. Gradle 설정

#### 1.1 minSdkVersion 변경
```diff
defaultConfig {
-   minSdkVersion 21
+   minSdkVersion 26
}
```

#### 1.2 compileSdkVersion 설정 (Android 15 지원)
```diff
android {
+   compileSdkVersion 35
}
```

#### 1.3 Data Binding 활성화
```groovy
android {
    buildFeatures {
        dataBinding true
    }
}
```

#### 1.4 Dependencies 변경
```diff
dependencies {
-   implementation "com.doinglab.foodlens:FoodLens:2.6.4"
+   implementation "com.doinglab.foodlens:FoodLensSDK-ui:3.2.1"
}
```

---

### 2. 인증 설정 (AccessToken 사용자만 해당)

> ⚠️ **AppToken + CompanyToken 사용 중이라면 변경 없음**

AccessToken만 사용 중이었다면, Doinglab에 문의하여 AppToken과 CompanyToken을 발급받아야 합니다.

```diff
- <meta-data android:name="com.doinglab.foodlens.sdk.accesstoken" 
-            android:value="@string/foodlens_access_token"/>

+ <meta-data android:name="com.doinglab.foodlens.sdk.apptoken" 
+            android:value="@string/foodlens_app_token"/>
+ <meta-data android:name="com.doinglab.foodlens.sdk.companytoken" 
+            android:value="@string/foodlens_company_token"/>
```

---

### 3. UI SDK 코드 변경

#### 3.1 서비스 생성
```diff
- private UIService uiService;
- uiService = FoodLens.createUIService(context);

+ private val foodLensUiService by lazy {
+     FoodLensUI.createFoodLensService(context, FoodLensType.FoodLens)
+     // FoodLensType.FoodLens 또는 FoodLensType.CaloAI 선택
+ }
```

#### 3.2 Activity Result 처리 방식 변경

```diff
- uiService.startFoodLensCamera(MainActivity.this, handler);
- 
- @Override
- protected void onActivityResult(int requestCode, int resultCode, Intent data) {
-     uiService.onActivityResult(requestCode, resultCode, data);
- }

+ foodLensUiService?.startFoodLensCamera(
+     this@MainActivity, 
+     foodLensActivityResult,
+     object : UIServiceResultHandler { ... }
+ )
+ 
+ private var foodLensActivityResult: ActivityResultLauncher<Intent> =
+     registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
+         foodLensUiService?.onActivityResult(result.resultCode, result.data)
+     }
```

**V3 전체 코드**
```kotlin
import com.doinglab.foodlens.sdk.ui.FoodLensUI
import com.doinglab.foodlens.sdk.ui.FoodLensType
import com.doinglab.foodlens.sdk.ui.UIServiceResultHandler
import com.doinglab.foodlens.sdk.core.RecognitionResult
import com.doinglab.foodlens.sdk.core.BaseError
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts

class MainActivity : AppCompatActivity() {

    private val foodLensUiService by lazy {
        FoodLensUI.createFoodLensService(this, FoodLensType.FoodLens)
    }

    private var foodLensActivityResult: ActivityResultLauncher<Intent> =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            foodLensUiService?.onActivityResult(result.resultCode, result.data)
        }

    // 카메라 시작
    fun startCamera() {
        foodLensUiService?.startFoodLensCamera(
            this@MainActivity,
            foodLensActivityResult,
            object : UIServiceResultHandler {
                override fun onSuccess(result: RecognitionResult?) {
                    // 결과 처리
                }

                override fun onCancel() {
                    // 취소 처리
                }

                override fun onError(errorReason: BaseError?) {
                    // 에러 처리
                }
            }
        )
    }

    // 갤러리 시작
    fun startGallery() {
        foodLensUiService?.startFoodLensGallery(
            this@MainActivity,
            foodLensActivityResult,
            object : UIServiceResultHandler {
                override fun onSuccess(result: RecognitionResult?) { }
                override fun onCancel() { }
                override fun onError(errorReason: BaseError?) { }
            }
        )
    }

    // 검색 시작
    fun startSearch() {
        foodLensUiService?.startFoodLensSearch(
            this@MainActivity,
            foodLensActivityResult,
            object : UIServiceResultHandler {
                override fun onSuccess(result: RecognitionResult?) { }
                override fun onCancel() { }
                override fun onError(errorReason: BaseError?) { }
            }
        )
    }

    // 데이터 수정
    fun startDataEdit(recognitionResult: RecognitionResult) {
        foodLensUiService?.startFoodLensDataEdit(
            this@MainActivity,
            foodLensActivityResult,
            recognitionResult,
            object : UIServiceResultHandler {
                override fun onSuccess(result: RecognitionResult?) { }
                override fun onCancel() { }
                override fun onError(errorReason: BaseError?) { }
            }
        )
    }
}
```

#### 3.3 setUseActivityResult 제거
```diff
- uiService.setUseActivityResult(false)  // 삭제 필요
```

---

### 4. 필수 변경사항 요약 테이블

| 구분 | V2 | V3 |
|------|----|----|
| minSdkVersion | 21 | **26** |
| compileSdkVersion | - | **35** |
| Data Binding | 불필요 | **필수** |
| Dependency | `FoodLens:2.6.4` | `FoodLensSDK-ui:3.2.1` |
| 인증 | AccessToken 가능 | **AppToken+CompanyToken만** |
| 서비스 생성 | `FoodLens.createUIService(context)` | `FoodLensUI.createFoodLensService(context, FoodLensType)` |
| Activity Result | onActivityResult override | **ActivityResultLauncher** |

---

## 🟡 선택적 변경사항

> 아래 항목들은 해당 기능을 사용하는 경우에만 변경하면 됩니다.

### 1. UI 테마 설정 (사용 중인 경우만)

```diff
- BottomWidgetTheme bottomWidgetTheme = new BottomWidgetTheme(this);
- bottomWidgetTheme.setButtonTextColor(0xffffff);
- DefaultWidgetTheme defaultWidgetTheme = new DefaultWidgetTheme(this);
- ToolbarTheme toolbarTheme = new ToolbarTheme(this);
- uiService.setBottomWidgetTheme(bottomWidgetTheme);
- uiService.setDefaultWidgetTheme(defaultWidgetTheme);
- uiService.setToolbarTheme(toolbarTheme);

+ var uiConfig = FoodLensUiConfig()
+ uiConfig.mainColor = Color.parseColor("#ff0000")        // 메인 색상
+ uiConfig.mainTextColor = Color.parseColor("#ffffff")    // 메인 텍스트 색상
+ foodLensUiService.setUiConfig(uiConfig)
```

### 2. 기능 옵션 설정 (사용 중인 경우만)

```diff
- FoodLensBundle bundle = new FoodLensBundle();
- bundle.setEnableManualInput(true);
- bundle.setEatType(1);
- bundle.setSaveToGallery(true);
- uiService.setDataBundle(bundle);

+ var settingConfig = FoodLensSettingConfig()
+ settingConfig.isShowManualInputIcon = true
+ settingConfig.mealType = MealType.BREAKFAST
+ settingConfig.isSaveToGallery = true
+ foodLensUiService.setSettingConfig(settingConfig)
```

**옵션 매핑**
| V2 (FoodLensBundle) | V3 (FoodLensSettingConfig) |
|---------------------|---------------------------|
| `setEnableManualInput()` | `isShowManualInputIcon` |
| `setEatType()` | `mealType` |
| `setSaveToGallery()` | `isSaveToGallery` |
| `setUseImageRecordDate()` | `isUseEatDatePopup` |
| `setEnableCameraOrientation()` | `isEnableCameraOrientation` |
| `setEnablePhotoGallery()` | `isShowPhotoGalleryIcon` |
| `setLanguageConfig()` | `languageConfig` |

### 3. UIServiceMode 변경

V3에서는 `setUiServiceMode` 대신 FoodLensType 선택과 옵션으로 대체됩니다.

```diff
- uiService.setUiServiceMode(UIServiceMode.USER_SELECTED_WITH_CANDIDATES);
```

**V3 방식**
- `FoodLensType.FoodLens` 선택 시 → 기본적으로 candidates 포함
- `FoodLensType.CaloAI` 선택 시 → `isGenerateCaloAiCandidate` 옵션으로 선택
  ```kotlin
  settingConfig.isGenerateCaloAiCandidate = true  // candidates 포함 여부
  ```

### 4. V2 JSON 포맷 추출
`toV2JSONString()` 호출
```
override fun onSuccess(result: RecognitionResult?) {
    result?.let {
        val jsonString = it.toV2JSONString()
        Log.d("FoodLens", jsonString)
    }
}
```

---

## 🟢 V3 기능 옵션 (선택 사용)

사용하고 싶은 경우에만 추가하면 됩니다.

**FoodLensSettingConfig 전체 옵션**
```kotlin
var settingConfig = FoodLensSettingConfig()

settingConfig.isEnableCameraOrientation = true      // 카메라 회전 기능 (default: true)
settingConfig.isShowPhotoGalleryIcon = true         // 갤러리 버튼 표시 (default: true)
settingConfig.isShowManualInputIcon = true          // 검색 버튼 표시 (default: true)
settingConfig.isShowHelpIcon = true                 // 도움말 버튼 표시 (default: true)
settingConfig.isSaveToGallery = false               // 촬영 이미지 갤러리 저장 (default: false)
settingConfig.isUseEatDatePopup = true              // 갤러리 이미지 촬영일 사용 팝업 (default: true)
settingConfig.imageResize = ImageResizeOption.NORMAL    // SPEED, NORMAL, QUALITY (default: NORMAL)
settingConfig.languageConfig = LanguageConfig.DEVICE    // DEVICE, KO, EN, JA (default: DEVICE)
settingConfig.eatDate = Date()                      // 식사 시간 (default: 현재 시간)
settingConfig.mealType = MealType.LUNCH             // 식사 타입 (default: 시간 기준 자동)
settingConfig.recommendedKcal = 2000f               // 1일 권장 칼로리 (default: 2000)
settingConfig.isEnableThousandSeparator = false     // 천 단위 콤마 (default: false)
settingConfig.nutrientSummaryDisplayOption = NutrientSummaryDisplayOption.HIDDEN  // HIDDEN, PERCENTAGE, WEIGHT (default: HIDDEN)
settingConfig.isGenerateCaloAiCandidate = false     // CaloAI candidates 포함 (default: false)
settingConfig.isEnableNutritionFactsScan = false    // 영양성분표 스캔 (default: false)
settingConfig.isShowMealMemo = true                 // 식사 메모 (default: true)

foodLensUiService.setSettingConfig(settingConfig)
```

---

## 마이그레이션 체크리스트

### 🔴 필수
- [ ] minSdkVersion 26으로 변경
- [ ] compileSdkVersion 35로 변경
- [ ] dataBinding 활성화
- [ ] Dependencies 변경
- [ ] 서비스 생성 코드 변경 + FoodLensType 지정
- [ ] ActivityResultLauncher 방식으로 변경
- [ ] setUseActivityResult() 호출 제거

### 🟡 선택 (사용 중인 경우만)
- [ ] UI 테마 설정 변경
- [ ] 기능 옵션 설정 변경 (FoodLensBundle → FoodLensSettingConfig)
- [ ] setUiServiceMode 사용 중이면 제거 (3. UIServiceMode 변경 참조)

---

## 문의

마이그레이션 중 문제가 발생하면 Doinglab 담당자에게 문의해 주세요.
