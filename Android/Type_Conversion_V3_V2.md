## V3 -> V2 타입 변환

### 1. RecognitionResult 변환

#### V3 → V2 변환

```kotlin
// RecognitionResult(V3) → RecognitionLegacyResult(V2)
val legacyResult = recognitionResult.toRecognitionLegacyResult()

// RecognitionResult(V3) → V2 JSON String
val v2JsonString = recognitionResult.toV2JSONString()
```

### 2. eatType ↔ MealType 변환

#### 타입 매핑 테이블

| eatType (Int) | MealTypeLegacy (V2) | MealType (V3) |
|:-------------:|:-------------------:|:-------------:|
| 0 | breakfast | breakfast |
| 1 | lunch | lunch |
| 2 | dinner | dinner |
| 3 | snack | 시간대별 분배* |
| 4 | morning_snack | morning_snack |
| 5 | afternoon_snack | afternoon_snack |
| 6 | late_night_snack | late_night_snack |
| 7 | unknown | 시간대별 분배* |
| -1 또는 그 외 | unknown | 시간대별 분배* |

> *V3에는 `snack` 타입이 없으므로 시간대에 따라 적절한 타입으로 분배됩니다.

#### 시간대별 분배 기준

| 시간대 | 변환되는 MealType |
|:------:|:-----------------:|
| 05:00 ~ 09:59 | breakfast |
| 10:00 ~ 10:59 | morning_snack |
| 11:00 ~ 12:59 | lunch |
| 13:00 ~ 16:59 | afternoon_snack |
| 17:00 ~ 19:59 | dinner |
| 20:00 ~ 04:59 | late_night_snack |

---

#### 변환 API

```kotlin
// eatType → MealType
val mealType = MealType.fromEatType(eatType)
val mealType = MealType.fromEatType(eatType, date)  // 시간대 기반 분배 시

// MealType → eatType
val eatType = mealType.toEatType()
```

---

### 3. 사용 예시

```kotlin
// V3 데이터를 V2로 변환
val v3Result: RecognitionResult = ...

// RecognitionLegacyResult(V2) 객체로 변환
val v2Result = v3Result.toRecognitionLegacyResult()

// V2 JSON String으로 변환
val v2JsonString = v3Result.toV2JSONString()

// MealType만 변환
val eatType = v3Result.type.toEatType()
val mealTypeLegacy = MealTypeLegacy.fromEatType(eatType)
```

---

## V3 ↔ V2 (Legacy) 타입 대응표

### 클래스 대응

| V3 (현재) | V2 (Legacy) | 설명 |
|:----------|:------------|:-----|
| `RecognitionResult` | `RecognitionLegacyResult` | 인식 결과 |
| `Food` | `FoodPosition` | 음식 위치 및 정보 |
| `Nutrition` | `FoodLegacy` + `NutritionLegacy` | 영양 정보 |
| `Position` | `Box` | 이미지 내 위치 좌표 |
| `MealType` | `MealTypeLegacy` / `eatType(Int)` | 식사 유형 |

---

### RecognitionResult ↔ RecognitionLegacyResult

| V3 (RecognitionResult) | V2 (RecognitionLegacyResult) |
|:-----------------------|:-----------------------------|
| `date: Date?` | `eatDate: String?` (yyyy-MM-dd HH:mm:ss) |
| `type: MealType` | `eatType: Int` / `mealType: MealTypeLegacy` |
| `imagePath: String?` | `predictedImagePath: String?` |
| `foods: ArrayList<Food>` | `foodPositionList: ArrayList<FoodPosition>` |
| `version: Int` (3) | `version: Int` (1~2) |

---

### Food ↔ FoodPosition

| V3 (Food) | V2 (FoodPosition) |
|:----------|:------------------|
| `name: String?` | `userSelectedFood?.foodName` |
| `position: Position?` | `imagePosition: Box?` |
| `imagePath: String?` | `foodImagePath: String` |
| `candidates: List<Nutrition>?` | `foodCandidates: ArrayList<FoodLegacy>` |
| `eatAmount: Double` | `eatAmount: Float` |
| `userSelected: Nutrition?` | `userSelectedFood: FoodLegacy?` |

---

### Nutrition ↔ FoodLegacy + NutritionLegacy

| V3 (Nutrition) | V2 (FoodLegacy / NutritionLegacy) |
|:---------------|:----------------------------------|
| `id: Int` | `foodId: Int` |
| `foodName: String` | `foodName: String?` |
| `manufacturer: String` | `manufacturer: String?` |
| `foodType: String` | `nutrition.foodtype: String?` |
| `servingSize: Double` | `nutrition.totalgram: Float` |
| `unit: String?` | `nutrition.unit: String` |
| `energy: Double` | `nutrition.calories: Float` |
| `carbohydrate: Double` | `nutrition.carbonhydrate: Float` |
| `protein: Double` | `nutrition.protein: Float` |
| `fat: Double` | `nutrition.fat: Float` |
| `totalSugars: Double` | `nutrition.sugar: Float` |
| `totalDietaryFiber: Double` | `nutrition.dietrayfiber: Float` |
| `calcium: Double` | `nutrition.calcium: Float` |
| `sodium: Double` | `nutrition.sodium: Float` |
| `cholesterol: Double` | `nutrition.cholesterol: Float` |
| `saturatedFattyAcid: Double` | `nutrition.saturatedfat: Float` |
| `transFattyAcid: Double` | `nutrition.transfat: Float` |
| `vitaminA: Double` | `nutrition.vitamina: Float` |
| `vitaminC: Double` | `nutrition.vitaminc: Float` |
| `vitaminD: Double` | `nutrition.vitamind: Float` |
| `vitaminE: Double` | `nutrition.vitamine: Float` |

---

### Position ↔ Box

| V3 (Position) | V2 (Box) |
|:--------------|:---------|
| `xmin: Int` | `xmin: Int` |
| `xmax: Int` | `xmax: Int` |
| `ymin: Int` | `ymin: Int` |
| `ymax: Int` | `ymax: Int` |

---

### MealType ↔ MealTypeLegacy

| V3 (MealType) | V2 (MealTypeLegacy) | eatType (Int) |
|:--------------|:--------------------|:-------------:|
| `breakfast` | `breakfast` | 0 |
| `lunch` | `lunch` | 1 |
| `dinner` | `dinner` | 2 |
| - | `snack` | 3 |
| `morning_snack` | `morning_snack` | 4 |
| `afternoon_snack` | `afternoon_snack` | 5 |
| `late_night_snack` | `late_night_snack` | 6 |
| `unknown` | `unknown` | 7 |
