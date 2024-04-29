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

## 3. Standalone FoodLens Server Address Setting
 - You can set a server address if you operate a standalone server instead of original FoodLens server. Please discuss with Doinglab for more detailed method.
 - Meta data추가 아래와 같이 메타데이터를 Manifest.xml에 추가해 주세요
```xml
//프로토콜과 및 포트를 제외한 순수 도메인 주소 혹은 IP주소 e.g) www.foodlens.com, 123.222.100.10
<meta-data android:name="com.doinglab.foodlens.sdk.serveraddr" android:value="[server_address]"/> 
```  
## 4. Core SDK 사용법
- FoodLens API는 FoodLens 기능을 이미지 파일 기반으로 동작하게 하는 기능입니다.  
- 두잉랩 UI를 사용하지 않고 고객사에서 직접 커스터마이즈 하여 화면을 구성하고자 할 때 Core SDK를 사용할 수 있습니다.

### 4.1 음식 결과 영양정보 얻기
1. FoodLensCoreService 를 생성합니다.  
   파라미터는 Context, FoodLens Type 입니다.  
   FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.     
2. predict 메서드를 호출합니다.  
   파라미터는 Jpeg image, RecognitionResultHandler 입니다.   
   Jpeg이미지는 카메라 촬영 또는 갤러리 원본 이미지를 전달해 줍니다.</br>
※ 이미지가 작은경우 인식율이 낮아질 수 있습니다.  
4. 코드 예제
```java
//Create FoodLens Service
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.FoodLens)
}

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

### 4.2 Option Change
- 설정하지 않은 경우 기본값으로 설정됩니다.
#### 4.2.1 Language Setting 
```
//LanguageConfig.DEVICE, LanguageConfig.KO(한국어), LanguageConfig.EN(영어), LanguageConfig.JA(일본어) 4개 중에 선택할 수 있습니다.
//Foodlens는 KO, EN을 Caloai의 경우 KO, EN, JA를 지원합니다.
//Default는 Device 입니다.
foodLensCoreService.setLanguage(LanguageConfig.EN)
```

#### 4.2.2 API Performance Option
```
//요구사항에 따라 API성능을 변경할 수 잇습니다.
//1. ImageResizeOption.SPEED : 빠른 속도의 처리가 필요한 경우 (음식 1~2개 수준)
//2. ImageResizeOption.NORMAL, 가장 보편적인 사황처리 (음식수 2~4개 수준)
//3. ImageResizeOption.QUALITY 3개 중에 선택할 수 있습니다. (속도가 느리더라도 음식인식율을 최대로 올릴 경우 4개 이상의 음식을 동시에 처리)
//Default는 ImageResizeOption.NORMAL 입니다.
foodLensCoreService.setImageResizeOption(LImageResizeOption.QUALITY)
```

#### 4.2.3 영양소 반환 옵션
```
//인식 후 전달받는 영양소에 대한 옵션 입니다.
//1. NutritionRetrieveOption.ALL_NUTRITION : 모둔 음식 후보군 (Candidates food)에 영양소를 전달 받음
//2. NutritionRetrieveOption.TOP1_NUTRITION_ONLY : 가장 확률이 높은 임식에 대해서만 영양소를 전달 받음 
//3. NutritionRetrieveOption.NO_NUTRITION : 인식결과만 전달받고 영양소는 전달 받지 않음
//Default는 ALL_NUTRITION 입니다.
foodLensCoreService.setNutritionRetrieveOption(NutritionRetrieveOption.ALL_NUTRITION)
```

## 5. How to Use UI SDK
- UI SDK는 FoodLens 에서 제공하는 기본 UI를 활용하여 서비스를 개발 할 수 있는 기능입니다.  
- UI API는 간단한 화면 Customize기능을 포함하고 있습니다.

### 5.1 Use of UI Service Recognition Function
1. FoodLensCoreService 를 생성합니다.  
파라미터는 Context, FoodLens Type 입니다.  
FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.
2. startFoodLensCamera 메서드를 호출합니다.  
파라미터는 Context, Jpeg image, ActivityResultLauncher, RecognitionResultHandler 입니다.   
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

### 5.2 Use of UI Service Gallery Function
- 카메라 화면을 거치지 않고 갤러리 이미지 선택화면으로 바로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensGallery를 사용합니다.

### 5.3 Use of UI Service Search Function
- 카메라 화면이 거치지 않고 검색 화면으로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensSearch를 사용합니다.

### 5.4 Use of UI Service Data Revise Function
- 5.1, 5.2, 5.3 에서 획득한 영양정보를 다시 활용 할 수 있습니다.
- 활용시에 이미지를 디바이즈 로컬 경로에 저장하고 RecognitionResult의 imagePath에 설정 해야 합니다. 
- 작성한 recongitionResult를 startFoodLensDataEdit 호출시 전달합니다.  
- 전달된 데이터로 음식 결과 화면으로 진입합니다.
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

### 5.5. UI SDK Option and Main Color Change (optional)
- 설정하지 않은 경우 기본값으로 설정됩니다.

#### 5.5.1 UI Theme Change
- FoodLens UI 의 매인 색상을 변경할 수 있습니다.  
- FoodLens UI 의 메인 텍스트 색상을 변경할 수 있습니다.
```
var uiConfig = FoodLensUiConfig()
uiConfig.mainColor = Color.parseColor("#ff0000") //메인 색상 변경 getColor(R.color.red)
uiConfig.mainTextColor = Color.parseColor("#ffffff")  //메인 텍스트 색상 변경 getColor(R.color.white)
foodLensUiService.setUiConfig(uiConfig) 
```

#### 5.5.2 Option Change
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
foodLensUiService.setSettingConfig(settingConfig)
```        

## 6. SDK Detailed Specification

## 7. SDK Use Cases

## 8. JSON Format
[JSON Format](../JSON%20Format)

[JSON Sample](../JSON%20Sample)

## 9. License
FoodLens is available under the MIT license. See the LICENSE file for more info.
