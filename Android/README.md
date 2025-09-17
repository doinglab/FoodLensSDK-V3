# Manual for Android FoodLensSDK-V3
## [Android SDK 한글 설명서 보기](README_KO.md)
## [Go to ReleaseNote](ReleaseNote.md)

This is a combined SDK for Android supporting FoodLens, CaloAI(FoodLens 2.0).  
FoodLens is composed of Core SDK and UI SDK. You may use the functions of FoodLens by using the Core SDK to create your own UI, or you may also use the UI SDK to use the UI screen provided by Doinglab.

## 1. Android Project Setting

### 1.1 Android 15 Support
- Set Compile SDK Version over 35 for Android 15 support.
- Open app > Gradle Scripts > build.gradle (Module: app) in the project and add the text below in the android{} section.

```java
android {
        ....
        compileSdkVersion 35
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
#### 1.2.2 Data Binding option (If you want to use UI SDK, please check below)
 - To use UI SDK, you should enable data biding option.
 - Open app > Gradle Scripts > build.gradle (Module: app) in the progject, add the text below in the android{} section.
```xml
android {
    ...
    buildFeatures {
        dataBinding true
    }
}
```

#### 1.2.3 gradle dependencies Setting
- Open app > Gradle Scripts > build.gradle (Module: app) in the project and add dependencies.
- Please refer to [ReleaseNote](ReleaseNote.md) to check latest library version.
```java
   //When Using Core SDK Only
   implementation "com.doinglab.foodlens:FoodLensSDK-core:3.0.9" 
   //When Using UI SDK Together 
   implementation "com.doinglab.foodlens:FoodLensSDK-ui:3.1.0"
```

### 1.3 Resources and Manifests 
- Set Company, AppToken.

### 1.4 AppToken, CompanyToken Setting
- Add the issued AppToken, CompanyToken to /app/res/values/strings.xml.
```xml
<string name="foodlens_app_token">[AppToken]</string>
<string name="foodlens_company_token">[CompanyToken]</string>
```

* Add Meta data
- Add Meta data in Manifest.xml like below.
```xml
<meta-data android:name="com.doinglab.foodlens.sdk.apptoken" android:value="@string/foodlens_app_token"/> 
<meta-data android:name="com.doinglab.foodlens.sdk.companytoken" android:value="@string/foodlens_company_token"/> 
```

### 1.5 Common
* Setting ProGuard
If you set a code obfuscation technique in the app through proguard, add a proguard like below in the setting.
```xml
-keep public class com.doinglab.foodlens.sdk.core.** {
       *;
}
```

### 1.6 FoodLens Standalone Server Address Setting
 - You can set a server address if you operate a standalone server instead of original FoodLens server. Please discuss with Doinglab for more detailed method.
  - Add Meta data in Manifest.xml like below.
```xml
//Domain address or IP address without protocol and port e.g) www.foodlens.com, 123.222.100.10
<meta-data android:name="com.doinglab.foodlens.sdk.serveraddr" android:value="[server_address]"/> 
```  


## 2. How to Use Core SDK
- FoodLens API is an API that works FoodLens features based on image file.  
- You may use the Core SDK to compose a screen UI through customizing without using the UI provided by Doinglab.
- <B> NOTE: BECAUSE OF IMAGE PROCESSING, SDK DO NOT SUPPORT MULTI THREAD ENVIRONMENT. PLEASE DO NOT CALL API CONCURRENTLY. </B>

### 2.1 Obtaining Nutritional Information as Food Result
1. Create FoodLensCoreService instance.
   Parameters are Context and FoodLens Type.  
   You may choose FoodLensType between <b>FoodLensType.FoodLens</b> and <b>FoodLensType.CaloAI</b>.     
2. Call predict method.
   Parameters are Jpeg image and RecognitionResultHandler.   
   Jpeg image delievers camera shot or original gallery image.</br>
※ The recognition quality may be lowered when the image is small. 
#### Code Example
```java
//Create FoodLens Service
private val foodLensCoreService by lazy {
  //Please choose FoodLens or CaloAI option
  FoodLensCore.createFoodLensService(context, FoodLensType.CaloAI)
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

### 2.2 FoodLensCoreSDK Option Change
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
//3. ImageResizeOption.QUALITY : Best qulity processing. (More than 4 foods can be handled at once with highest food recognition rate although the spped is low)
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
1. Create FoodLensCoreService instance.
    - Parameteres are Context and FoodLens Type.  
    - You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.     
3. Call foodInfo method.

#### Code Example
```java
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.CaloAI)
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
1. Create FoodLensCoreService instance.
    - Parameters are Context and FoodLens Type.  
    - You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.     
3. Call searchFoodsByName method.

#### Code Example
```java
private val foodLensCoreService by lazy {
  FoodLensCore.createFoodLensService(context, FoodLensType.CaloAI)
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

### 3.1 Using UI Service Recognition Feature
1. Create FoodLensUIService instance.  
Parameters are Context, FoodLens Type.  
You may choose FoodLensType between FoodLensType.FoodLens and FoodLensType.CaloAI.
2. Call startFoodLensCamera method.  
Parameters are Context, ActivityResultLauncher and UIServiceResultHandler.   
Deliver ActivityResultLauncher<Intent> to process the result. </br>
3. Call onActivity Result method of the delievered UI Service in ActivityResultLauncher.  
※ The recognition rate may be lowered when the image is small. 
4. Code Example
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

### 3.2 Using Gallery Feature
- Enter the gallery image selection screen directly without going through the camera.  
- Implement method is the same with 3.1 by using startFoodLensGallery instead of startFoodLensCamera.

### 3.3 Using Search Feature
- Enter a black screen directly without going through the camera.  
- Implement method is the same with 3.1 by using startFoodLensSearch instead of startFoodLensCamera.

### 3.4 Using Data Revise Feature of UI Service
- You can use nutritional information obtained from 3.1, 3.2, 3.3. 
- Deliver recognitionResult when calling startFoodLensDataEdit.  
- Enter into food result screen with the delivered data.
#### *Important* You shall set to save the image to be shown on the screen in device local path and set imagePath of RecognitionResult before calling revise feature.
1. Code Example
```java
//Create FoodLens Service instance
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

### 3.5. UI SDK Option and Main Color Change (option)
- Default value will be set when not set.

#### 3.5.1 UI Theme Change
- You may change the main color of FoodLens UI.  
- You may change the main text color of FoodLens UI.
```
var uiConfig = FoodLensUiConfig()
uiConfig.mainColor = Color.parseColor("#ff0000") //Main Color Change getColor(R.color.red)
uiConfig.mainTextColor = Color.parseColor("#ffffff")  //Main Text Color Change getColor(R.color.white)
foodLensUiService.setUiConfig(uiConfig) 
```

#### 3.5.2 FoodLens Option Change
```
var settingConfig = FoodLensSettingConfig()
settingConfig.isEnableCameraOrientation = true  			// Camera rotation feature support (defalut : true)
settingConfig.isShowPhotoGalleryIcon = true     			// Gallery icon activation (defalut : true)
settingConfig.isShowManualInputIcon = true      			// Search input icon activation (defalut : true)
settingConfig.isShowHelpIcon = true             			// Help icon activation (defalut : true)
settingConfig.isSaveToGallery = false           			// Camera shot save to gellery (defalut : false)
settingConfig.isUseEatDatePopup = true          			// Save the input time as the time saved in gallery (defalut : true)
settingConfig.imageResize = ImageResizeOption.NORMAL 		// Image resize method option, SPEED(Speed priority), NORMAL, QUALITY(Result quality priority) (defalut : NORMAL)
settingConfig.languageConfig = LanguageConfig.DEVICE 		// Result language setting, DEVICE, KO, EN, JA (defalut : DEVICE)
settingConfig.eatDate = Date()								// Meal time setting (default: Current time, isUseEatDatePopup == true Set as input time at pop-up)
settingConfig.mealType = MealType.AFTERNOON_SNACK			// Meal type setting (default: Meal type based on time)
settingConfig.recommendedKcal = 2000f						// Recommended calorie per day (defalut : 2,000)
settingConfig.isEnableThousandSeparator = false  			// Added option to use commas between thousands (default : false)
settingConfig.nutrientSummaryDisplayOption = .hidden 		// Nutrient display option on the Summary screen - hidden (do not show), percentage (show as %), weight (show as weight) (default: HIDDEN)
settingConfig.isGenerateCaloAiCandidate = false        		// Whether to include candidates in the API response when using CaloAI (default: false)

foodLensUiService.setSettingConfig(settingConfig)
```        

#### 3.5.3 Auto Meal Type Setting
When the user does not set the meal type using MealType, the meal type is automatically set based on the criteria.
```
Breakfast : 5AM ~ 10AM
Morning Snack : 10AM ~ 11AM
Lunch : 11AM ~ 13PM
Afternoon Snack : 13PM ~ 17PM
Dinner : 17PM ~ 20PM
Night Snack : 20PM ~ 5AM
```

## 4. JSON Change

### 4.1 RecognitionResult -> JSON string
You can convert RecognitionResult to JSON string.
```
var json = recognitionResult.toJSONString()
```

### 4.2 JSON string -> RecognitionResult
You can convert JSON string to RecognitionResult.

```
var reconitionResult = RecognitionResult.create(json)
```

## 5. Error Code
### 401: UNAUTHORIZED
 - CompanyToken is empty or wrong.
 - AppToken is empty or wrong.
### 402: PAYMENT REQUIRED
 - API call limit is over or payment is needed.
### 403: FORBIDDEN
 - Use unauthorized function.
### 404: NOT FOUND
 - No existing URL or not supported URL.
### 406: NOT ACCEPTABLE
 - Package name is empty or wrong.
### 5xx: SERVER ERROR
 - Unexpected server error.

## 6. SDK Sample
[Sample Code](SampleCode/)

## 7. JSON Format
[JSON Format](../JSON%20Format)

[JSON Sample](../JSON%20Sample)

## 8. License
FoodLens is available under the MIT license. See the LICENSE file for more info.
