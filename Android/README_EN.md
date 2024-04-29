# Manual for Android FoodLensSDK-V3

This is a combined SDK for Android supporting FoodLens, CaloAI(FoodLens 2.0).  
FoodLens is composed of Core SDK and UI SDK. You may use the functions of FoodLens by using the Core SDK to create your own UI, or you may also use the UI SDK to use the UI screen provided by Doinglab.

## 1. Android Project Setting

### 1.1 Android 13 Support
- Set Compile SDK Version over 33 for Android 13 support.
- Open app > Gradle Scripts > build.gradle (Module: app) in the project and add the text below in the android{} section.

```java
android {
        ....
        compileSdkVersion 33
	....       
    }
```

### 1.2 gradle Setting
#### 1.2.1 minSdkVersion Setting
- Use minSdkVersion over 26.
- Open app > Gradle Scripts > build.gradle (Module: app) in the project and add the text below in the defaultConfig{} section.
```java
   defaultConfig {
        ....
        minSdkVersion 26
	....       
    }
```
#### 1.2.2 gradle dependencies Setting
- Open app > Gradle Scripts > build.gradle (Module: app) in the project and add dependencies.
```java
   //When Using Core SDK Only
   implementation "com.doinglab.foodlens:FoodLensSDK-core:3.0.0" 
   //When Using UI SDK Together 
   implementation "com.doinglab.foodlens:FoodLensSDK-ui:3.0.0"
```

## 2. Resources and Manifests 
- Set Company, AppToken.

### 2.1 AppToken, CompanyToken Setting
- Add the issued AppToken, CompanyToken to /app/res/values/strings.xml.
```xml
<string name="foodlens_app_token">[AppToken]</string>
<string name="foodlens_company_token">[CompanyToken]</string>
```

* Add Meta data
- Add the Meta data in Manifest.xml like below.
```xml
<meta-data android:name="com.doinglab.foodlens.sdk.apptoken" android:value="@string/foodlens_app_token"/> 
<meta-data android:name="com.doinglab.foodlens.sdk.companytoken" android:value="@string/foodlens_company_token"/> 
```

### 2.2 Common
* Setting ProGuard
If you set a code obfuscation technique in the app through proguard, add a proguard like below in the setting.
```xml
-keep public class com.doinglab.foodlens.sdk.core.** {
       *;
}
```

## 3. FoodLens Standalone Server Address Setting
 - You can set a server address if you operate a standalone server instead of original FoodLens server. Please discuss with Doinglab for more detailed method.
  - Add Meta data in Manifest.xml like below.
```xml
//Domain address or IP address without protocol and port e.g) www.foodlens.com, 123.222.100.10
<meta-data android:name="com.doinglab.foodlens.sdk.serveraddr" android:value="[server_address]"/> 
```  
## 2. How to Use Core SDK
- FoodLens API is an API that works FoodLens features based on image file.  
- You may use the Core SDK to compose a screen UI through customizing without using the UI provided by Doinglab.

### 2.1 Obtaining Nutritional Information as Food Result
1. Create FoodLensCoreService.
   Parameters are Context and FoodLens Type.  
   You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.     
2. Call predict method.
   Parameters are Jpeg image and RecognitionResultHandler.   
   Jpeg image delievers camera shot or original gallery image.</br>
※ The recognition rate may be lowered when the image is small. 
#### Code Example
```java
//Create FoodLens Service
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.FoodLens)
}

...........

//Call prediction method.
foodLensCoreService.predict(byteData, object : RecognitionResultHandler {
  override fun onSuccess(result: RecognitionResult?) {
    //implement code
  }

  override fun onError(error: BaseError?) {
    Log.d("MSG_LOG", error.getMessage());
  }
})
```

### 2.2 FoodlensCoreSDK Option Change
- Default value will be set when not set.
#### 2.2.1 Language Setting  
```
//You may choose between LanguageConfig.DEVICE, LanguageConfig.KO(Korean), LanguageConfig.EN(English), LanguageConfig.JA(Japanese).
//FoodLens supports KO, EN and CaloAI supports KO, EN, JA.
//Default is Device.
foodLensCoreService.setLanguage(LanguageConfig.EN)
```

#### 2.2.2 API Performance Option
```
//API performance may be changed on demand.
//1. ImageResizeOption.SPEED : Fast processing (1~2 food level)
//2. ImageResizeOption.NORMAL : The most common processing (2~4 food level)
//3. ImageResizeOption.QUALITY : You may choose between three. (More than 4 foods can be handled at once with highest food recognition rate although the spped is low)
//Default is ImageResizeOption.NORMAL.
foodLensCoreService.setImageResizeOption(LImageResizeOption.QUALITY)
```

#### 2.2.3 Nutrition Return Option
```
//This is an option for nutrition returned after recognition.
//1. NutritionRetrieveOption.ALL_NUTRITION : Deliever nutrition about every food candidates
//2. NutritionRetrieveOption.TOP1_NUTRITION_ONLY : Deliver nutrition only for the most likely food 
//3. NutritionRetrieveOption.NO_NUTRITION : Deliever only recognition result and not the nutrition
//Default is ALL_NUTRITION.
foodLensCoreService.setNutritionRetrieveOption(NutritionRetrieveOption.ALL_NUTRITION)
```
### 2.3 Food Information Search
1. Create FoodLensCoreService.
    - Parameteres are Context and FoodLens Type.  
    - You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.     
3. Call foodInfo method.

#### Code Example
```java
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.FoodLens)
}

...........

//Call foodInfo method.
foodLensCoreService.foodInfo(foodId, object : RecognitionResultHandler {
    override fun onSuccess(result: RecognitionResult?) {
	//implement code
    }

    override fun onError(errorReason: BaseError?) {
	//implement code
    }
})
```
### 2.4 Food Information Search
1. Create FoodLensCoreService.
    - Parameters are Context and FoodLens Type.  
    - You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.     
3. Call searchFoodsByName method.

#### Code Example
```java
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.FoodLens)
}

...........

//Call searchFoodsByName method.
foodLensCoreService.searchFoodsByName(foodName, object : SearchResultHandler {
    override fun onSuccess(result: FoodSearchResult?) {
	//implement code
    }

    override fun onError(errorReason: BaseError?) {
	//implement code
    }
})
```


## 3. How to Use UI SDK
- UI SDK has a feature to develop service using the basic UI provided by FoodLens.  
- UI API includes simple screen Customize feature.

### 3.1 UI Service의 인식 기능 사용
1. FoodLensUIService 를 생성합니다.  
파라미터는 Context, FoodLens Type 입니다.  
FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.
2. startFoodLensCamera 메서드를 호출합니다.  
파라미터는 Context, ActivityResultLauncher, UIServiceResultHandler 입니다.   
결과를 처리할 ActivityResultLauncher<Intent>를 전달합니다. </br>
3. 전달한 ActivityResultLauncher 에서 UIService의 onActivityResult 메소드를 호출합니다.  
※ 이미지가 작은경우 인식율이 낮아질 수 있습니다.  
4. 코드 예제
```java
//Create FoodLens Service
private val foodLensUiService by lazy {
  FoodLensUI.createFoodLensService(context, FoodLensType.FoodLens)
}

//Call prediction method.
foodLensUiService?.startFoodLensCamera(this@MainActivity, foodLensActivityResult, object : UIServiceResultHandler {
    override fun onSuccess(result: RecognitionResult?) {
        //implement code
    }

    override fun onError(errorReason: BaseError?) {
        Log.d("MSG_LOG", error.getMessage());
    }

    override fun onCancel() {
        Log.d("MSG_LOG", "Recognition Cancel");
    }
})

private var foodLensActivityResult: ActivityResultLauncher<Intent> =
    registerForActivityResult<Intent, ActivityResult>(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        foodLensUiService?.onActivityResult(result.resultCode, result.data)
    }


```

### 3.2 갤러리 기능 사용
- 카메라 화면을 거치지 않고 갤러리 이미지 선택화면으로 바로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensGallery를 사용합니다.

### 3.3 검색 기능 사용
- 카메라 화면이 거치지 않고 검색 화면으로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensSearch를 사용합니다.

### 3.4 UI Service의 Data 수정 기능 사용
- 3.1, 3.2, 3.3 에서 획득한 영양정보를 다시 활용 할 수 있습니다.
- 작성한 recongitionResult를 startFoodLensDataEdit 호출시 전달합니다.  
- 전달된 데이터로 음식 결과 화면으로 진입합니다.
#### *중요* 수정 기능을 호출하기 이전에 화면에 표시하 이미지를 디바이즈 로컬 경로에 저장하고 RecognitionResult의 imagePath에 설정 해야 합니다. 
1. 코드 예제
```java
//Create FoodLens Service
private val foodLensUiService by lazy {
  FoodLensUI.createFoodLensService(context, FoodLensType.FoodLens)
}

//Call prediction method.
foodLensUiService.startFoodLensDataEdit(this@MainActivity, foodLensActivityResult, recongitionResult, object : UIServiceResultHandler {
    override fun onSuccess(result: RecognitionResult?) {
        //implement code
    }

    override fun onError(errorReason: BaseError?) {
        Log.d("MSG_LOG", error.getMessage());
    }

    override fun onCancel() {
        Log.d("MSG_LOG", "Recognition Cancel");
    }
})

private var foodLensActivityResult: ActivityResultLauncher<Intent> =
    registerForActivityResult<Intent, ActivityResult>(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        foodLensUiService?.onActivityResult(result.resultCode, result.data)
    }


```

### 3.5. UI SDK 옵션 및 매인 컬러 변경 (option)
- 설정하지 않은 경우 기본값으로 설정됩니다.

#### 3.5.1 UI 테마 변경
- FoodLens UI 의 매인 색상을 변경할 수 있습니다.  
- FoodLens UI 의 메인 텍스트 색상을 변경할 수 있습니다.
```
var uiConfig = FoodLensUiConfig()
uiConfig.mainColor = Color.parseColor("#ff0000") //메인 색상 변경 getColor(R.color.red)
uiConfig.mainTextColor = Color.parseColor("#ffffff")  //메인 텍스트 색상 변경 getColor(R.color.white)
foodLensUiService.setUiConfig(uiConfig) 
```

#### 3.5.2 FoodLens 옵션 변경
```
var settingConfig = FoodLensSettingConfig()
settingConfig.isEnableCameraOrientation = true  	//카메라 회전 기능 지원 여부 (defalut : true)
settingConfig.isShowPhotoGalleryIcon = true     	//갤러리 아이콘 활성화 여부 (defalut : true)
settingConfig.isShowManualInputIcon = true      	//검색 입력 아이콘 활성화 여부 (defalut : true)
settingConfig.isShowHelpIcon = true             	//도움말 아이콘 활성화 여부 (defalut : true)
settingConfig.isSaveToGallery = false           	//카메라 촬영 이미지 갤러리 저장 여부 (defalut : false)
settingConfig.isUseEatDatePopup = true          	//갤러리에 저장된 사진의 사진촬영시간을 입력시간으로 사용할지 여부 (defalut : true)
settingConfig.imageResize = ImageResizeOption.NORMAL 	//이미지 리사이즈 방식 옵션, SPEED(속도우선), NORMAL, QUALITY(결과 품질 우선) (defalut : NORMAL)
settingConfig.languageConfig = LanguageConfig.DEVICE 	//결과값 언어 설정, DEVICE, KO, EN, JA (defalut : DEVICE)
settingConfig.eatDate = Date()				// 식시 시간 설정(default: 현재 시간, isUseEatDatePopup == true 시 팝업에서 입력 받은 시간으로 설정)
settingConfig.mealType = MealType.AFTERNOON_SNACK	// 식사 타입 설정(default: 시간에 맞는 식사 타입)
settingConfig.recommendedKcal = 2000f			// 1일 권장 칼로리 (defalut : 2,000)

foodLensUiService.setSettingConfig(settingConfig)
```        

#### 3.5.3 식사 타입 자동 설정
사용자가 MealType을 이용하여 식사타입 설정을 직접 하지 않은 경우, 음식 식사 타입은 기준 시간을 기준으로 자동설정됨
```
아침 : 5시 ~ 10시
아침간신 : 10 ~ 11시
점심 : 11시 ~ 13시
점심간신 : 13시 ~ 17시
저녁 : 17시 ~ 20시
야식 : 20시 ~ 5시
```

## 4. JSON 변환

### 4.1 RecognitionResult -> JSON string
설명설명
```java
code
```

### 4.2 JSON string -> RecognitionResult
설명설명

```swift
code
```

## 5. SDK 상세 스펙  

## 6. SDK 사용 예제 

## 7. JSON Format
[JSON Format](../JSON%20Format)

[JSON Sample](../JSON%20Sample)

## 8. License
FoodLens is available under the MIT license. See the LICENSE file for more info.
