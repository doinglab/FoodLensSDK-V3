# Android용 FoodLensSDK-V3 메뉴얼
## [ReleaseNote 바로가기](ReleaseNote.md)
Foodlens, CaloAI(Foodlens 2.0)을 지원하는 통합 Android용 SDK입니다.  
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
#### 1.2.2 데이터 바인딩 활성화(UI SDK)
 - UI SDK를 사용하기 위해서는 데이터 바인딩을 활성화해야 합니다.
 - 프로젝트에서 app > Gradle Scripts(그래들 스크립트) > build.gradle (Module: app)을 연 후 android{} 섹션에 아래와 같은 문구를 추가해 주세요.
```xml
android {
    ...
    buildFeatures {
        dataBinding true
    }
}
```

#### 1.2.3 gradle dependencies 설정
- 프로젝트에서 app > Gradle Scripts(그래들 스크립트) > build.gradle (Module: app)을 연 후 dependencies를 추가해 주세요.
- 최종 라이브러리 버전은 [ReleaseNote](ReleaseNote.md)를 확인해 주세요
```java
   //Core SDK만 사용할 경우
   implementation "com.doinglab.foodlens:FoodLensSDK-core:3.0.2" 
   //UI SDK도 사용할 경우 
   implementation "com.doinglab.foodlens:FoodLensSDK-ui:3.0.2"
```

### 1.3. 리소스(Resources) 및 메니페스트(Manifests) 
- Company, AppToken을 세팅 합니다.

### 1.4 AppToken, CompanyToken 설정
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

### 1.5 공통
* ProGuard 설정
앱에서 proguard를 통한 난독화를 설정할 경우 아래와 같이 proguard 설정을 설정 파일에 추가해 주세요
```xml
-keep public class com.doinglab.foodlens.sdk.core.** {
       *;
}
```

### 1.6 독립 FoodLens 서버 주소 설정
 - 기본 FoodLens 서버가 아닌 독립 서버를 운용할 경우 서버 주소를 설정 할 수 있습니다. 자세한 방법은 당사와 협의해 주시기 바랍니다.
 - Meta data추가 아래와 같이 메타데이터를 Manifest.xml에 추가해 주세요
```xml
//프로토콜과 및 포트를 제외한 순수 도메인 주소 혹은 IP주소 e.g) www.foodlens.com, 123.222.100.10
<meta-data android:name="com.doinglab.foodlens.sdk.serveraddr" android:value="[server_address]"/> 
```

## 2. Core SDK 사용법
- FoodLens API는 FoodLens 기능을 이미지 파일 기반으로 동작하게 하는 기능입니다.  
- 두잉랩 UI를 사용하지 않고 고객사에서 직접 커스터마이즈 하여 화면을 구성하고자 할 때 Core SDK를 사용할 수 있습니다.
- <B>주의 : 이미지 처리로 인하여 Multi-Thread환경을 지원하지 않습니다. 동시에 여러 API를 호출 하지 마십시오.</b>

### 2.1 음식 결과 영양정보 얻기
1. FoodLensCoreService 를 생성합니다.  
   파라미터는 Context, FoodLens Type 입니다.  
   FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.     
2. predict 메서드를 호출합니다.  
   파라미터는 Jpeg image, RecognitionResultHandler 입니다.   
   Jpeg이미지는 카메라 촬영 또는 갤러리 원본 이미지를 전달해 줍니다.</br>
※ 이미지가 작은경우 인식율이 낮아질 수 있습니다.  
#### 코드 예제
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

### 2.2 FoodlensCoreSDK 옵션 변경
- 설정하지 않은 경우 기본값으로 설정됩니다.
#### 2.2.1 언어 설정  
```
//LanguageConfig.DEVICE, LanguageConfig.KO(한국어), LanguageConfig.EN(영어), LanguageConfig.JA(일본어) 4개 중에 선택할 수 있습니다.
//Foodlens는 KO, EN을 Caloai의 경우 KO, EN, JA를 지원합니다.
//Default는 Device 입니다.
foodLensCoreService.setLanguage(LanguageConfig.EN)
```

#### 2.2.2 API Performance 옵션
```
//요구사항에 따라 API성능을 변경할 수 잇습니다.
//1. ImageResizeOption.SPEED : 빠른 속도의 처리가 필요한 경우 (음식 1~2개 수준)
//2. ImageResizeOption.NORMAL, 가장 보편적인 사황처리 (음식수 2~4개 수준)
//3. ImageResizeOption.QUALITY 3개 중에 선택할 수 있습니다. (속도가 느리더라도 음식인식율을 최대로 올릴 경우 4개 이상의 음식을 동시에 처리)
//Default는 ImageResizeOption.NORMAL 입니다.
foodLensCoreService.setImageResizeOption(ImageResizeOption.QUALITY)
```

#### 2.2.3 영양소 반환 옵션
```
//인식 후 전달받는 영양소에 대한 옵션 입니다.
//1. NutritionRetrieveOption.ALL_NUTRITION : 모둔 음식 후보군 (Candidates food)에 영양소를 전달 받음
//2. NutritionRetrieveOption.TOP1_NUTRITION_ONLY : 가장 확률이 높은 임식에 대해서만 영양소를 전달 받음 
//3. NutritionRetrieveOption.NO_NUTRITION : 인식결과만 전달받고 영양소는 전달 받지 않음
//Default는 ALL_NUTRITION 입니다.
foodLensCoreService.setNutritionRetrieveOption(NutritionRetrieveOption.ALL_NUTRITION)
```
### 2.3 음식정보 검색하기
1. FoodLensCoreService 생성합니다.
    - 파라미터는 Context, FoodLens Type 입니다.  
    - FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.     
3. foodInfo 메소드를 호출합니다.

#### 코드 예제
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
### 2.4 음식정보 검색하기
1. FoodLensCoreService 생성합니다.
    - 파라미터는 Context, FoodLens Type 입니다.  
    - FoodLensType은 FoodLensType.FoodLens, FoodLensType.CaloAI 두가지 중에 선택할 수 있습니다.     
3. searchFoodsByName 메소드를 호출합니다.

#### 코드 예제
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


## 3. UI SDK 사용법
- UI SDK는 FoodLens 에서 제공하는 기본 UI를 활용하여 서비스를 개발 할 수 있는 기능입니다.  
- UI API는 간단한 화면 Customize기능을 포함하고 있습니다.

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
- 구현 방식은 3.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensGallery를 사용합니다.

### 3.3 검색 기능 사용
- 카메라 화면이 거치지 않고 검색 화면으로 진입합니다.  
- 구현 방식은 3.1 번과 동일하며 startFoodLensCamera 대신 startFoodLensSearch를 사용합니다.

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
RecognitionResult 객체를 JSON 문자열로 변환할 수 있습니다.
```
var json = recognitionResult.toJSONString()
```

### 4.2 JSON string -> RecognitionResult
JSON 문자열을 RecognitionResult 객체로 변환할 경우, 아래처럼 사용하실 수 있습니다.

```
var reconitionResult = RecognitionResult.create(json)
```

## 5. Error Code
### 401: UNAUTHORIZED
   - CompanyToken 혹은 AppToken 이 잘못되었거나 빈값인 경우
### 402: PAYMENT REQUIRED
   - API 호출 횟수가 계약횟수를 초과한 경우 혹은 비용 결제가 안된경우
### 403: FORBIDDEN
   - 사용할 수 없는 기능
### 404: NOT FOUND
  - 지원하지 않는 URL
### 406: NOT ACCEPTABLE
  - 등록한 패키지명과 API를 호출한 서비스의 패키지명이 다른 경우
### 5xx: SERVER ERROR
 - 서버에러


## 6. SDK 사용 예제 
[Sample 예제](SampleCode/)

## 7. JSON Format
[JSON Format](../JSON%20Format)

[JSON Sample](../JSON%20Sample)

## 8. License
FoodLens is available under the MIT license. See the LICENSE file for more info.
