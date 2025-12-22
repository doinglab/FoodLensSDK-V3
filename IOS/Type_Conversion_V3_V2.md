## V3 -> V2 타입 변환

### 1. RecognitionResult 변환

#### V3 → V2 변환

```swift
// RecognitionResult(V3) → LegacyPredictionResult(V2)
let legacyResult = recognitionResult.toLegacyPredictionResult()

// RecognitionResult(V3) → V2 JSON String
let v2JsonString = recognitionResult.toV2JSONString()
```

### 2. mealType 변환

#### 시간대별 분배 기준

*V3에는 `snack` 타입이 없으므로 시간대에 따라 적절한 타입으로 분배됩니다.

| 시간대 | 변환되는 MealType |
|:------:|:-----------------:|
| 05:00 ~ 09:59 | breakfast |
| 10:00 ~ 10:59 | morning_snack |
| 11:00 ~ 12:59 | lunch |
| 13:00 ~ 16:59 | afternoon_snack |
| 17:00 ~ 19:59 | dinner |
| 20:00 ~ 04:59 | late_night_snack |

### 3. 사용 예시

```swift
// V2 데이터를 V3로 변환
let legacyResult = LegacyPredictionResult.create(json: jsonString)
let v3Result = legacyResult.toRecognitionResult()

// V3 데이터를 V2로 변환
let legacyResult = v3Result.toLegacyPredictionResult()
let v2JsonString = v3Result.toV2JSONString()

// 개별 타입 변환
let legacyFoodPosition = food.toLegacyFoodPosition()
let legacyFood = nutrition.toLegacyFood()
let legacyNutrition = nutrition.toLegacyNutrition()
```

---

## V3 ↔ V2 타입 대응표

### 최상위 타입

| V3 | V2 (Legacy) |
|:--:|:-----------:|
| `RecognitionResult` | `LegacyPredictionResult` |
| `Food` | `LegacyFoodPosition` |
| `Nutrition` | `LegacyFood` |
| `Position` | `LegacyBox` |
| - | `LegacyNutrition` |

### 필드 매핑

#### RecognitionResult ↔ LegacyPredictionResult

| V3 | V2 |
|:--:|:--:|
| `imagePath` | `predictedImagePath` |
| `date` | `eatDate` |
| `type` | `mealType` |
| `foods` | `foodPositionList` |
| `version` | `version` |

#### Food ↔ LegacyFoodPosition

| V3 | V2 |
|:--:|:--:|
| `imagePath` | `foodImagepath` |
| `name` | `userSelectedFood.foodName` |
| `fullName` | `userSelectedFood.foodName` |
| `position` | `imagePosition` |
| `eatAmount` | `eatAmount` |
| `userSelected` | `userSelectedFood` |
| `candidates` | `foodCandidates` |

#### Nutrition ↔ LegacyFood + LegacyNutrition

| V3 (Nutrition) | V2 (LegacyFood) |
|:--------------:|:---------------:|
| `id` | `foodId` |
| `foodName` | `foodName` |
| `manufacturer` | `manufacturer` |
| *(영양소들)* | `nutrition` → LegacyNutrition |

| V3 (Nutrition) | V2 (LegacyNutrition) |
|:--------------:|:--------------------:|
| `energy` | `calories` |
| `carbohydrate` | `carbonhydrate` |
| `protein` | `protein` |
| `fat` | `fat` |
| `totalSugars` | `sugar` |
| `totalDietaryFiber` | `dietrayfiber` |
| `calcium` | `calcium` |
| `sodium` | `sodium` |
| `cholesterol` | `cholesterol` |
| `saturatedFattyAcid` | `saturatedfat` |
| `transFattyAcid` | `transfat` |
| `vitaminA` | `vitamina` |
| `vitaminB6` | `vitaminb` |
| `vitaminC` | `vitaminc` |
| `vitaminD` | `vitamind` |
| `vitaminE` | `vitamine` |
| `servingSize` | `totalgram` |
| `counts` | `unit` |
| `foodType` | `foodtype` |

#### Position ↔ LegacyBox

| V3 | V2 |
|:--:|:--:|
| `xmin` | `xmin` |
| `xmax` | `xmax` |
| `ymin` | `ymin` |
| `ymax` | `ymax` |
