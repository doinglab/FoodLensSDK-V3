# Android용 FoodLensSDK-V3 메뉴얼

Android용 FoodLens SDK를 사용하여 FoodLens 기능을 이용할 수 있습니다.  
FoodLens SDK는 Core SDK와 UI SDK로 이루어 지며, 자체 UI를 작성할 경우는 Core SDK를, Doinglab에서 제공하는 UI화면까지 사용할 경우는 UI SDK를 사용하셔서 FoodLens의 기능을 이용하실 수 있습니다.

## 1. 안드로이드 프로젝트 설정

### 1.1 Android 13 지원
- Android 13 지원을 위해 Compile SDK Version을 33이상으로 설정해 주세요. 
- 프로젝트에서 app > Gradle Scripts(그래들 스크립트) > build.gradle (Module: app)을 연 후 android{} 섹션에 아래와 같은 문구를 추가해 주세요.

```java
android {
        ....
        compileSdkVersion 33
	....       
    }
```

### 1.2 gradle 설정
#### 1.2.1 minSdkVersion 설정
- minSdkVersion은 26 이상을 사용하시기 바랍니다.
- 프로젝트에서 app > Gradle Scripts(그래들 스크립트) > build.gradle (Module: app)을 연 후 defaultConfig{} 섹션에 아래와 같은 문구를 추가해 주세요.
```java
   defaultConfig {
        ....
        minSdkVersion 26
	....       
    }
```
#### 1.2.2 gradle dependencies 설정
- 프로젝트에서 app > Gradle Scripts(그래들 스크립트) > build.gradle (Module: app)을 연 후 dependencies를 추가해 주세요.
```java
   //Core SDK만 사용할 경우
   implementation "com.doinglab.foodlens:FoodLensSDK-core:3.0.0" 
   //UI SDK도 사용할 경우 
   implementation "com.doinglab.foodlens:FoodLensSDK-ui:3.0.0"
```

## 2. 리소스(Resources) 및 메니페스트(Manifests) 
- Company, AppToken을 세팅 합니다.

### 2.1 AppToken, CompanyToken 설정
- 발급된 AppToken, CompanyToken을 /app/res/values/strings.xml에 추가 합니다.
```xml
<string name="foodlens_app_token">[AppToken]</string>
<string name="foodlens_company_token">[CompanyToken]</string>
```

* Meta data추가
- 아래와 같이 메타데이터를 Manifest.xml에 추가해 주세요
```xml
<meta-data android:name="com.doinglab.foodlens.sdk.apptoken" android:value="@string/foodlens_app_token"/> 
<meta-data android:name="com.doinglab.foodlens.sdk.companytoken" android:value="@string/foodlens_company_token"/> 
```

### 2.2 공통
* ProGuard 설정
앱에서 proguard를 통한 난독화를 설정할 경우 아래와 같이 proguard 설정을 설정 파일에 추가해 주세요
```xml
-keep public class com.doinglab.foodlens.sdk.core.** {
       *;
}
```

## 3.독립 FoodLens 서버 주소 설정
 - 기본 FoodLens 서버가 아닌 독립 서버를 운용할 경우 서버 주소를 설정 할 수 있습니다. 자세한 방법은 당사와 협의해 주시기 바랍니다.
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

### 4.2 옵션 변경
- 설정하지 않은 경우 기본값으로 설정됩니다.
#### 4.2.1 언어 설정  
```
//LanguageConfig.DEVICE, LanguageConfig.KO, LanguageConfig.EN, LanguageConfig.JP 4개 중에 선택할 수 있습니다.
//Default는 Device 입니다.
foodLensCoreService.setLanguage(LanguageConfig.EN)
```

#### 4.2.2 이미지 리사이즈 방식 옵션
```
//ImageResizeOption.SPEED, ImageResizeOption.NORMAL, ImageResizeOption.QUALITY 3개 중에 선택할 수 있습니다.
//Default는 ImageResizeOption.NORMAL 입니다.
foodLensCoreService.setImageResizeOption(LImageResizeOption.QUALITY)
```

#### 4.2.3 영양소 반환 옵션
```
//NutritionRetrieveOption.ALL_NUTRITION, NutritionRetrieveOption.TOP1_NUTRITION_ONLY, NutritionRetrieveOption.NO_NUTRITION 3개 중에 선택할 수 있습니다.
//Default는 ALL_NUTRITION 입니다.
foodLensCoreService.setNutritionRetrieveOption(NutritionRetrieveOption.ALL_NUTRITION)
```

## 5. UI SDK 사용법
- UI SDK는 FoodLens 에서 제공하는 기본 UI를 활용하여 서비스를 개발 할 수 있는 기능입니다.  
- UI API는 간단한 화면 Customize기능을 포함하고 있습니다.

### 5.1 UI Service의 인식 기능 사용
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

### 5.2 UI Service의 갤러리 기능 사용
- 카메라 화면을 거치지 않고 갤러리 이미지 선택화면으로 바로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensGallery를 사용합니다.

### 5.3 UI Service의 검색 기능 사용
- 카메라 화면이 거치지 않고 검색 화면으로 진입합니다.  
- 구현 방식은 5.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensSearch를 사용합니다.

### 5.4 UI Service의 Data 수정 기능 사용
- 5.1, 5.2, 5.3 에서 획득한 영양정보를 recognitionResult 에 저장합니다.  
- imagePath는 임시 경로이므로 따로 저장시킨후 edit시에는 따로 저장된 경로를 보내야 합니다.   
- 저장한 recongitionResult를 startFoodLensDataEdit 호출시 전달합니다.  
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

### 5.5. UI SDK 옵션 및 매인 컬러 변경 (option)
- 설정하지 않은 경우 기본값으로 설정됩니다.

#### 5.5.1 UI 테마 변경
- FoodLens UI 의 매인 색상을 변경할 수 있습니다.  
- FoodLens UI 의 메인 텍스트 색상을 변경할 수 있습니다.
```
var uiConfig = FoodLensUiConfig()
uiConfig.mainColor = Color.parseColor("#ff0000") //메인 색상 변경 getColor(R.color.red)
uiConfig.mainTextColor = Color.parseColor("#ffffff")  //메인 텍스트 색상 변경 getColor(R.color.white)
foodLensUiService.setUiConfig(uiConfig) 
```

#### 5.5.2 옵션 변경
```
var settingConfig = FoodLensSettingConfig()
settingConfig.isEnableCameraOrientation = true  //카메라 회전 기능 지원 여부 (defalut : true)
settingConfig.isShowPhotoGalleryIcon = true     //갤러리 아이콘 활성화 여부 (defalut : true)
settingConfig.isShowManualInputIcon = true      //검색 입력 아이콘 활성화 여부 (defalut : true)
settingConfig.isShowHelpIcon = true             //도움말 아이콘 활성화 여부 (defalut : true)
settingConfig.isSaveToGallery = false           //카메라 촬영 이미지 갤러리 저장 여부 (defalut : false)
settingConfig.isUseEatDatePopup = true          //갤러리에 저장된 사진의 사진촬영시간을 입력시간으로 사용할지 여부 (defalut : true)

//이미지 리사이즈 방식 옵션, SPEED(속도우선), NORMAL, QUALITY(결과 품질 우선) (defalut : NORMAL)
settingConfig.imageResize = ImageResizeOption.NORMAL 	
//결과값 언어 설정, DEVICE, KO, EN, JA (defalut : DEVICE)
settingConfig.languageConfig = LanguageConfig.DEVICE 		
foodLensUiService.setSettingConfig(settingConfig)
```        

## 6. SDK 상세 스펙  

## 7. SDK 사용 예제 

## 8. JSON Format
[JSON Format](../JSON%20Format)

[JSON Sample](../JSON%20Sample)

## 9. License
FoodLens is available under the MIT license. See the LICENSE file for more info.
