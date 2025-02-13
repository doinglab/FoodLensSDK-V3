package com.doinglab.foodlens.sample

import android.content.Intent
import android.graphics.drawable.BitmapDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.doinglab.foodlens.sample.databinding.ActivityMainBinding
import com.doinglab.foodlens.sample.listview.RecognitionItem
import com.doinglab.foodlens.sample.listview.RecognitionListAdapter
import com.doinglab.foodlens.sample.util.BitmapUtil
import com.doinglab.foodlens.sdk.core.FoodLensCore
import com.doinglab.foodlens.sdk.core.RecognitionResultHandler
import com.doinglab.foodlens.sdk.core.error.BaseError
import com.doinglab.foodlens.sdk.core.model.result.RecognitionResult
import com.doinglab.foodlens.sdk.core.type.*
import com.doinglab.foodlens.sdk.ui.FoodLensUI
import com.doinglab.foodlens.sdk.ui.UIServiceResultHandler
import com.doinglab.foodlens.sdk.ui.config.FoodLensSettingConfig
import com.doinglab.foodlens.sdk.ui.config.FoodLensUiConfig

import java.io.File
import java.util.*

class MainActivity : AppCompatActivity() {

    private val binding: ActivityMainBinding by lazy {
        ActivityMainBinding.inflate(layoutInflater)
    }

    private val foodLensCoreService by lazy {
        FoodLensCore.createFoodLensService(this, FoodLensType.CaloAI)
    }

    private val foodLensUiService by lazy {
        FoodLensUI.createFoodLensService(this, FoodLensType.CaloAI)
    }

    private val listAdapter by lazy {
        RecognitionListAdapter()
    }

    private var recognitionResult:RecognitionResult? = null
    private var foodImagePath = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        binding.list.adapter = listAdapter

        binding.btnRunCore.setOnClickListener {
            val intent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
            galleryForResult.launch(intent)
        }

        binding.btnRunUiCamera.setOnClickListener {
            foodLensUiService.startFoodLensCamera(this, foodLensActivityResult, object :
                UIServiceResultHandler {
                override fun onSuccess(result: RecognitionResult?) {
                    result?.let {
                        setRecognitionResultData(result)
                    }
                }

                override fun onError(errorReason: BaseError?) {
                    Toast.makeText(this@MainActivity, errorReason?.getMessage(), Toast.LENGTH_SHORT).show()
                    Log.d("foodLens", "foodLensCameraResult onError ${errorReason?.getMessage()}")
                }

                override fun onCancel() {
                    Log.d("foodLens", "foodLensCameraResult cancel")
                }
            })
        }

        binding.btnRunUiEdit.setOnClickListener {
            if(recognitionResult == null) {
                return@setOnClickListener
            }
            recognitionResult?.let {
                foodLensUiService.startFoodLensDataEdit(this, foodLensActivityResult, it, object : UIServiceResultHandler {
                    override fun onSuccess(result: RecognitionResult?) {
                        result?.let {
                            setRecognitionResultData(result)
                        }
                    }
                    override fun onError(errorReason: BaseError?) {
                        Toast.makeText(this@MainActivity, errorReason?.getMessage(), Toast.LENGTH_SHORT).show()
                        Log.d("foodLens", "foodLensEditResult onError ${errorReason?.getMessage()}")
                    }

                    override fun onCancel() {
                        Log.d("foodLens", "foodLensEditResult cancel")
                    }
                })
            }
        }

        //Set Option
        //setOptionFoodLensCore()
        //setOptionFoodLensUI()
    }

    private fun startFoodLensCore(byteData: ByteArray) {
        foodLensCoreService.predict(byteData, object : RecognitionResultHandler {
            override fun onSuccess(result: RecognitionResult?) {
                result?.let {
                    setRecognitionResultData(result)
                }
            }

            override fun onError(errorReason: BaseError?) {
                Toast.makeText(this@MainActivity, errorReason?.getMessage(), Toast.LENGTH_SHORT).show()
            }
        })
    }

    private var galleryForResult: ActivityResultLauncher<Intent> =
        registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            if (result.resultCode == RESULT_OK) {
                result.data?.data?.let {
                    val filePathColumn = arrayOf(MediaStore.Images.Media.DATA)
                    val cursor = contentResolver?.query(it, filePathColumn, null, null, null)
                    cursor?.moveToFirst()
                    val columnIndex = cursor?.getColumnIndex(filePathColumn[0])
                    foodImagePath = cursor?.getString(columnIndex ?: return@let) ?: return@let
                    cursor.close()

                    val byteData = BitmapUtil.readContentIntoByteArray(File(foodImagePath))
                    startFoodLensCore(byteData)
                }
            }
        }


    private var foodLensActivityResult: ActivityResultLauncher<Intent> =
        registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            foodLensUiService.onActivityResult(result.resultCode, result.data)
        }


    private fun setRecognitionResultData(resultData: RecognitionResult) {
        val mutableList = mutableListOf<RecognitionItem>()
        recognitionResult = resultData

        //ui mode only
        resultData.imagePath?.let { imagePath->
            if(imagePath.isNotEmpty())
                foodImagePath = imagePath
        }

        val originBitmap = BitmapUtil.getBitmapFromFile(foodImagePath)

        resultData.foods.forEach { foodInfo ->
            foodInfo.let {
                val xMin = it.position?.xmin ?: 0
                val yMin = it.position?.ymin ?: 0
                val xMax = it.position?.xmax ?: 0
                val yMax = it.position?.ymax ?: 0
                val bitmap = BitmapUtil.cropBitmap(originBitmap, xMin, yMin, xMax, yMax)

                var carbohydrate = -1.0
                var protein = -1.0
                var fat = -1.0
                var unit = ""
                var energy = 0.0

                it.userSelected?.let { userSelected->
                    carbohydrate = userSelected.carbohydrate
                    protein = userSelected.protein
                    fat = userSelected.fat
                    unit = userSelected.unit?:""
                    energy = userSelected.energy
                }?:run {
                    it.candidates?.let { candidates ->
                        if(candidates.isNotEmpty()) {
                            carbohydrate = candidates[0].carbohydrate
                            protein = candidates[0].protein
                            fat = candidates[0].fat
                            unit = candidates[0].unit?:""
                            energy = candidates[0].energy
                        }
                    }
                }

                mutableList.add(
                    RecognitionItem(
                        name = "${getString(R.string.name)} : ${it.fullName}",
                        icon = BitmapDrawable(resources, bitmap),
                        foodPosition = "${getString(R.string.food_position)} : ${xMin}, ${yMin}, ${xMax}, $yMax",
                        foodNutrition = "${getString(R.string.carbohydrate)} : ${carbohydrate}, " +
                                "${getString(R.string.protein)} : ${protein}, " +
                                "${getString(R.string.fat)} : ${fat}, ",
                        energy = "${getString(R.string.energy)} : ${energy}, ${getString(R.string.amount)} : ${it.eatAmount} Unit : $unit",
                    )
                )

            }
        }
        listAdapter.submitList(mutableList)
    }


    private fun setOptionFoodLensCore() {
        //foodLensCore option
        foodLensCoreService.setLanguage(LanguageConfig.EN)
        foodLensCoreService.setImageResizeOption(ImageResizeOption.QUALITY)
        foodLensCoreService.setNutritionRetrieveOption(NutritionRetrieveOption.TOP1_NUTRITION_ONLY)
    }

    private fun setOptionFoodLensUI() {
        //foodLensUI Theme
        val uiConfig = FoodLensUiConfig()
        uiConfig.mainColor = getColor(R.color.purple_500)
        uiConfig.mainTextColor = getColor(R.color.grey_100)
        foodLensUiService.setUiConfig(uiConfig)

        //foodLensUI Option
        val settingConfig = FoodLensSettingConfig()
        settingConfig.isEnableCameraOrientation = true
        settingConfig.isShowPhotoGalleryIcon = true
        settingConfig.isShowManualInputIcon = true
        settingConfig.isShowHelpIcon = true
        settingConfig.isSaveToGallery = false
        settingConfig.isUseEatDatePopup = true
        settingConfig.imageResize = ImageResizeOption.NORMAL
        settingConfig.languageConfig = LanguageConfig.DEVICE
        settingConfig.eatDate = Date()
        settingConfig.mealType = MealType.afternoon_snack
        settingConfig.recommendedKcal = 2000f
        foodLensUiService.setSettingConfig(settingConfig)
    }


}