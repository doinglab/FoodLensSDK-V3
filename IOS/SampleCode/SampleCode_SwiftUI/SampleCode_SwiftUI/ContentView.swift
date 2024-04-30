//
//  ContentView.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/29/24.
//

import SwiftUI
import FoodLensUI
import FoodLensCore

let json = """
"{"date":"2024-04-29 17:42:27","foods":[{"candidates":[{"bcaa":-1.0,"betaCarotene":0.0,"biotin":0.0,"calcium":3.75,"carbohydrate":2.48,"cholesterol":0.0,"counts":"종지","dha":0.0,"energy":15.45,"epa":0.0,"fat":0.0,"foodName":"간장","foodType":"","fruits":-1.0,"fullFoodName":"간장","grains":-1.0,"id":-1,"iron":0.24,"isoleucine":63.6,"leucine":94.95,"magnesium":10.35,"manufacturer":"","niacin":0.2,"oils":-1.0,"omega3FattyAcid":0.0,"omega6FattyAcid":0.0,"phosphorus":21.75,"potassium":72.0,"protein":1.37,"proteins":-1.0,"retinol":0.0,"riboflavin":0.24,"saturatedFattyAcid":0.0,"selenium":0.0,"servingSize":15.0,"sodium":717.45,"thiamin":0.01,"totalDietaryFiber":0.12,"totalFolate":5.4,"totalServingSize":0.0,"totalSugars":0.0,"transFattyAcid":0.0,"unit":"g","valine":64.5,"vegetables":-1.0,"vitaminA":0.0,"vitaminB6":0.0,"vitaminC":0.0,"vitaminD":0.0,"vitaminE":0.01,"vitaminK":0.0,"zinc":0.12}],"eatAmount":1.0,"estimatedAmount":{"estimatedServingAmount":-1.0,"estimatedServingSize":-1.0},"fullName":"간장","ingredients":[{"gram":15.0,"name":"간장"}],"name":"간장","position":{"xmax":1400,"xmin":1032,"ymax":472,"ymin":160},"userSelected":{"bcaa":-1.0,"betaCarotene":0.0,"biotin":0.0,"calcium":3.75,"carbohydrate":2.48,"cholesterol":0.0,"counts":"종지","dha":0.0,"energy":15.45,"epa":0.0,"fat":0.0,"foodName":"간장","foodType":"","fruits":-1.0,"fullFoodName":"간장","grains":-1.0,"id":-1,"iron":0.24,"isoleucine":63.6,"leucine":94.95,"magnesium":10.35,"manufacturer":"","niacin":0.2,"oils":-1.0,"omega3FattyAcid":0.0,"omega6FattyAcid":0.0,"phosphorus":21.75,"potassium":72.0,"protein":1.37,"proteins":-1.0,"retinol":0.0,"riboflavin":0.24,"saturatedFattyAcid":0.0,"selenium":0.0,"servingSize":15.0,"sodium":717.45,"thiamin":0.01,"totalDietaryFiber":0.12,"totalFolate":5.4,"totalServingSize":0.0,"totalSugars":0.0,"transFattyAcid":0.0,"unit":"g","valine":64.5,"vegetables":-1.0,"vitaminA":0.0,"vitaminB6":0.0,"vitaminC":0.0,"vitaminD":0.0,"vitaminE":0.01,"vitaminK":0.0,"zinc":0.12}},{"candidates":[{"bcaa":-1.0,"betaCarotene":189.39,"biotin":0.99,"calcium":105.11,"carbohydrate":42.84,"cholesterol":38.84,"counts":"대접","dha":0.0,"energy":403.77,"epa":0.0,"fat":15.18,"foodName":"만둣국","foodType":"","fruits":-1.0,"fullFoodName":"만둣국","grains":-1.0,"id":-1,"iron":5.84,"isoleucine":850.57,"leucine":1424.39,"magnesium":65.5,"manufacturer":"","niacin":1.76,"oils":-1.0,"omega3FattyAcid":0.2,"omega6FattyAcid":2.17,"phosphorus":233.91,"potassium":507.03,"protein":23.23,"proteins":-1.0,"retinol":1.6,"riboflavin":0.25,"saturatedFattyAcid":5.42,"selenium":24.24,"servingSize":498.5,"sodium":1327.02,"thiamin":0.7,"totalDietaryFiber":8.74,"totalFolate":73.58,"totalServingSize":0.0,"totalSugars":0.74,"transFattyAcid":0.15,"unit":"g","valine":887.84,"vegetables":-1.0,"vitaminA":17.39,"vitaminB6":0.0,"vitaminC":0.06,"vitaminD":0.0,"vitaminE":1.46,"vitaminK":2.84,"zinc":3.57}],"eatAmount":1.0,"estimatedAmount":{"estimatedServingAmount":-1.0,"estimatedServingSize":-1.0},"fullName":"만둣국","ingredients":[{"gram":2.0,"name":"소금"},{"gram":0.5,"name":"후추"},{"gram":5.0,"name":"간장"},{"gram":1.0,"name":"오일"},{"gram":300.0,"name":"물"},{"gram":40.0,"name":"소고기"},{"gram":150.0,"name":"만두"}],"name":"만둣국","position":{"xmax":1295,"xmin":107,"ymax":1046,"ymin":101},"userSelected":{"bcaa":-1.0,"betaCarotene":189.39,"biotin":0.99,"calcium":105.11,"carbohydrate":42.84,"cholesterol":38.84,"counts":"대접","dha":0.0,"energy":403.77,"epa":0.0,"fat":15.18,"foodName":"만둣국","foodType":"","fruits":-1.0,"fullFoodName":"만둣국","grains":-1.0,"id":-1,"iron":5.84,"isoleucine":850.57,"leucine":1424.39,"magnesium":65.5,"manufacturer":"","niacin":1.76,"oils":-1.0,"omega3FattyAcid":0.2,"omega6FattyAcid":2.17,"phosphorus":233.91,"potassium":507.03,"protein":23.23,"proteins":-1.0,"retinol":1.6,"riboflavin":0.25,"saturatedFattyAcid":5.42,"selenium":24.24,"servingSize":498.5,"sodium":1327.02,"thiamin":0.7,"totalDietaryFiber":8.74,"totalFolate":73.58,"totalServingSize":0.0,"totalSugars":0.74,"transFattyAcid":-1.0,"vitaminA":17.39,"vitaminB6":0.0,"vitaminC":0.06,"vitaminD":0.0,"vitaminE":1.46,"vitaminK":2.84,"zinc":3.57}}],"imagePath":"/data/user/0/com.example.foodlensv3_sample/files/temp/origin_img.jpg","type":"dinner","userComment":""}
"""

let json2 = """
{"date":"2024-04-29 18:21:46+0900","foods":[{"candidates":[{"bcaa":-1,"betaCarotene":-1,"biotin":-1,"calcium":-1,"carbohydrate":3,"cholesterol":105,"counts":"총 내용량","dha":-1,"energy":165,"epa":-1,"fat":2.21,"foodName":"Eat Mate Monster Sliced ​​Chicken Breast Original","foodType":"","fruits":-1,"fullFoodName":"Eat Mate Monster Sliced ​​Chicken Breast Original","grains":-1,"id":90407,"iron":-1,"isoleucine":-1,"leucine":-1,"magnesium":-1,"manufacturer":"(주)푸드나무","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":-1,"potassium":-1,"protein":33,"proteins":-1,"retinol":-1,"riboflavin":-1,"saturatedFattyAcid":1.01,"selenium":-1,"servingSize":150,"sodium":650,"thiamin":-1,"totalDietaryFiber":-1,"totalFolate":-1,"totalServingSize":150,"totalSugars":3,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":-1,"vitaminC":-1,"vitaminD":-1,"vitaminE":-1,"vitaminK":-1,"zinc":-1},{"bcaa":-1,"betaCarotene":-1,"biotin":-1,"calcium":-1,"carbohydrate":3,"cholesterol":120,"counts":"총 내용량","dha":-1,"energy":165,"epa":-1,"fat":2.5099999999999998,"foodName":"Eat Mate Monster Sliced ​​Smoked Chicken Breast","foodType":"","fruits":-1,"fullFoodName":"Eat Mate Monster Sliced ​​Smoked Chicken Breast","grains":-1,"id":90445,"iron":-1,"isoleucine":-1,"leucine":-1,"magnesium":-1,"manufacturer":"(주)푸드나무","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":-1,"potassium":-1,"protein":33,"proteins":-1,"retinol":-1,"riboflavin":-1,"saturatedFattyAcid":1.2,"selenium":-1,"servingSize":150,"sodium":650,"thiamin":-1,"totalDietaryFiber":-1,"totalFolate":-1,"totalServingSize":150,"totalSugars":3,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":-1,"vitaminC":-1,"vitaminD":-1,"vitaminE":-1,"vitaminK":-1,"zinc":-1},{"bcaa":-1,"betaCarotene":-1,"biotin":-1,"calcium":-1,"carbohydrate":5,"cholesterol":70,"counts":"총 내용량","dha":-1,"energy":145,"epa":-1,"fat":7,"foodName":"Eat Mate Chicken Breast Sausage Curry","foodType":"","fruits":-1,"fullFoodName":"Eat Mate Chicken Breast Sausage Curry","grains":-1,"id":90431,"iron":-1,"isoleucine":-1,"leucine":-1,"magnesium":-1,"manufacturer":"(주)푸드나무","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":-1,"potassium":-1,"protein":15,"proteins":-1,"retinol":-1,"riboflavin":-1,"saturatedFattyAcid":2,"selenium":-1,"servingSize":100,"sodium":490,"thiamin":-1,"totalDietaryFiber":-1,"totalFolate":-1,"totalServingSize":100,"totalSugars":2,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":-1,"vitaminC":-1,"vitaminD":-1,"vitaminE":-1,"vitaminK":-1,"zinc":-1},{"bcaa":-1,"betaCarotene":-1,"biotin":-1,"calcium":-1,"carbohydrate":6,"cholesterol":50,"counts":"총 내용량","dha":-1,"energy":140,"epa":-1,"fat":6,"foodName":"Eat Mate Crispy Chicken Breast Curry","foodType":"","fruits":-1,"fullFoodName":"Eat Mate Crispy Chicken Breast Curry","grains":-1,"id":90457,"iron":-1,"isoleucine":-1,"leucine":-1,"magnesium":-1,"manufacturer":"(주)푸드나무","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":-1,"potassium":-1,"protein":16,"proteins":-1,"retinol":-1,"riboflavin":-1,"saturatedFattyAcid":1.6000000000000001,"selenium":-1,"servingSize":90,"sodium":580,"thiamin":-1,"totalDietaryFiber":-1,"totalFolate":-1,"totalServingSize":90,"totalSugars":1,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":-1,"vitaminC":-1,"vitaminD":-1,"vitaminE":-1,"vitaminK":-1,"zinc":-1},{"bcaa":-1,"betaCarotene":0,"biotin":0,"calcium":0,"carbohydrate":1.1000000000000001,"cholesterol":0,"counts":"pack","dha":-1,"energy":112,"epa":-1,"fat":0.5,"foodName":"Achim Chickenbreast","foodType":"","fruits":-1,"fullFoodName":"Achim Chickenbreast","grains":-1,"id":12764,"iron":0,"isoleucine":-1,"leucine":-1,"magnesium":0,"manufacturer":"아침","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":0,"potassium":0,"protein":25.699999999999999,"proteins":-1,"retinol":0,"riboflavin":0,"saturatedFattyAcid":0,"selenium":0,"servingSize":100,"sodium":270,"thiamin":0,"totalDietaryFiber":0,"totalFolate":-1,"totalServingSize":100,"totalSugars":0,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":0,"vitaminC":0,"vitaminD":0,"vitaminE":0,"vitaminK":-1,"zinc":0}],"eatAmount":1,"estimatedAmount":{"estimatedServingAmount":-1,"estimatedServingSize":-1},"fullName":"Eat Mate Monster Sliced ​​Chicken Breast Original","ingredients":[],"name":"Eat Mate Monster Sliced ​​Chicken Breast Original","position":{"xmax":2375,"xmin":383,"ymax":4007,"ymin":239},"userSelected":{"bcaa":-1,"betaCarotene":-1,"biotin":-1,"calcium":-1,"carbohydrate":3,"cholesterol":105,"counts":"총 내용량","dha":-1,"energy":165,"epa":-1,"fat":2.21,"foodName":"Eat Mate Monster Sliced ​​Chicken Breast Original","foodType":"","fruits":-1,"fullFoodName":"Eat Mate Monster Sliced ​​Chicken Breast Original","grains":-1,"id":90407,"iron":-1,"isoleucine":-1,"leucine":-1,"magnesium":-1,"manufacturer":"(주)푸드나무","niacin":-1,"oils":-1,"omega3FattyAcid":-1,"omega6FattyAcid":-1,"phosphorus":-1,"potassium":-1,"protein":33,"proteins":-1,"retinol":-1,"riboflavin":-1,"saturatedFattyAcid":1.01,"selenium":-1,"servingSize":150,"sodium":650,"thiamin":-1,"totalDietaryFiber":-1,"totalFolate":-1,"totalServingSize":150,"totalSugars":3,"transFattyAcid":0,"unit":"g","valine":-1,"vegetables":-1,"vitaminA":0,"vitaminB6":-1,"vitaminC":-1,"vitaminD":-1,"vitaminE":-1,"vitaminK":-1,"zinc":-1}}],"imagePath":"full_image.jpg","type":"dinner","userComment":""}
"""

struct ContentView: View {
    @Environment (\.viewController) var viewControllerHolder
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 40.0) {
            VStack(spacing: 8.0) {
                Button("Start FoodLens Core") {
                    DispatchQueue.main.async {
                        self.viewModel.isShowPhotoPicker = true
                    }
                }
                .buttonStyle(FoodLensButtonStyle())
                
                Button("Start FoodLens camera") {
                    let foodlensUIService = FoodLensUIService(type: .foodlens)
                    
                    var options: FoodLensSettingConfig = .init()
                    options.isEnableCameraOrientation = true    // 카메라 회전 기능 지원 여부 (defalut : true)
                    options.isShowPhotoGalleryIcon = true       // 카메라 화면에서 갤러리 버튼 활성화 여부 (defalut : true)
                    options.isShowManualInputIcon = true        // 카메라 화면에서 검색 버튼 활성화 여부 (defalut : true)
                    options.isShowHelpIcon = true               // 카메라 화면에서 help 아이콘 활성화 여부 (defalut : true)
                    options.isSaveToGallery = true              // 촬영한 이미지 갤러리 저장 여부 (defalut : false)
                    options.isUseEatDatePopup = true            // 갤러리에서 이미지 불러올 때 촬영 일자 사용여부 (ture일 경우 선택 팝업 표시)
                    options.imageResizingType = .normal         // //이미지 리사이즈 방식 옵션, SPEED(속도우선), NORMAL, QUALITY(결과 품질 우선) (defalut : NORMAL)
                    options.language = .en                      // 제동되는 음식 정보 언어 설정 (음식정보 외에 UI에 표시되는 텍스트의 언어는 기기에 설정된 언어로 표시) (defalut : device)
                    options.eatDate = Date()                    // 식시 시간 설정(default: 현재 시간, isUseEatDatePopup == true 시 팝업에서 입력 받은 시간으로 설정)
                    options.mealType = .lunch                   // 식사 타입 설정(default: 시간에 맞는 식사 타입)
                    options.recommendedKcal = 2400              // 1일 권장 칼로리 (defalut : 2,000)
                    
                    var uiConfig: FoodLensUIConfig = .init()
                    uiConfig.mainColor = .green
                    uiConfig.mainTextColor = .white
                    
                    foodlensUIService.setSettingConfig(options)
                    foodlensUIService.setUIConfig(uiConfig)
                    foodlensUIService.startFoodLensCamera(
                        parent: self.viewControllerHolder,
                        completionHandler: self.viewModel
                    )
                }
                .buttonStyle(FoodLensButtonStyle())
                
                Button("Edit mode") {
                    FoodLensStorage.shared.save(image: self.viewModel.predictedFoodImage, fileName: "image.jpg")
                    let foodlensUIService = FoodLensUIService(type: .foodlens)
                    foodlensUIService.startFoodLensDataEdit(
                        recognitionResult: self.viewModel.result,
                        parent: self.viewControllerHolder,
                        completionHandler: self.viewModel
                    )
                }
                .buttonStyle(FoodLensButtonStyle())
            }
            .padding(.horizontal)
            
            ResultView(fullImage: self.viewModel.predictedFoodImage, foods: self.viewModel.result.foods)
            
            Spacer()
        }
        .sheet(isPresented: self.$viewModel.isShowPhotoPicker) {
            PHPicker(selectedImage: self.$viewModel.selectedImage)
        }
        .onChange(of: self.viewModel.selectedImage) { image in
            self.viewModel.predict(image: image)
        }
        .padding(.vertical)
    }
}

struct ResultView: View {
    let fullImage: UIImage
    let foods: [Food]
    let isUseEditMode: Bool
    let editModeAction: (() -> Void)?
    
    init(fullImage: UIImage, foods: [Food], isUseEditMode: Bool = false, editModeAction: (() -> Void)? = nil) {
        self.fullImage = fullImage
        self.foods = foods
        self.isUseEditMode = isUseEditMode
        self.editModeAction = editModeAction
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            Text("RESULTS")
                .font(.system(size: 14))
                .foregroundColor(.black)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Spacer()
                .frame(height: 20.0)
            
            ScrollView {
                VStack(spacing: 0.0) {
                    ForEach(self.foods, id: \.self) {
                        ResultItemView(image: self.fullImage.cropToBox($0.position) ?? UIImage(), food: $0)
                        
                        Divider()
                            .foregroundColor(.gray)
                            .padding(.vertical, 14)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ResultItemView: View {
    let image: UIImage
    let food: Food
    
    var body: some View {
        VStack(spacing: 15.0) {
            HStack(spacing: 20.0) {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 6.0))
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 5.0) {
                    let selectedFood = food.userSelected ?? food.candidates.first ?? .init()
                    
                    Text(food.candidates.first?.fullFoodName ?? food.name)
                    
                    let box = food.position
                    Text("Location: \(box?.xmin ?? 0) \(box?.ymin ?? 0) \(box?.xmax ?? 0) \(box?.ymax ?? 0)")
                    
                    Text("carlorie: \(selectedFood.energy.roundedInt()) amount: \(food.eatAmount.roundedTenths())")
                    
                    Text("Carbs: \(selectedFood.carbohydrate.roundedTenths()) Protein: \(selectedFood.protein.roundedTenths()) Fat: \(selectedFood.fat.roundedTenths())")
                }
                .font(.system(size: 12.0))
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6.0) {
                    ForEach(self.food.candidates, id: \.self) { candidate in
                        Button {
                            
                        } label: {
                            Text(candidate.fullFoodName)
                                .font(.system(size: 12.0))
                        }
                        .buttonStyle(BorderButtonStyle())
                        .disabled(true)
                    }
                }
            }
            .padding(.trailing, -20)
        }
    }
}

#Preview {
    ContentView(viewModel: .init())
}

fileprivate extension Double {
    func roundedInt() -> Int {
        Int(self.rounded())
    }
    
    func roundedTenths() -> String {
        let roundedNumber = String(((self*10).rounded())/10)
        let split = roundedNumber.components(separatedBy: ".")
        return split[1] == "0" ? split[0] : roundedNumber
    }
}

fileprivate extension UIImage {
    func cropToBox(_ box: Position?) -> UIImage? {
        guard let box = box else { return nil }
        let width = box.xmax - box.xmin
        let height = box.ymax - box.ymin
        return self.cropToBounds(posX: CGFloat(box.xmin), posY: CGFloat(box.ymin), width: CGFloat(width), height: CGFloat(height))
    }
    
    private func cropToBounds(posX: CGFloat, posY : CGFloat, width: CGFloat, height: CGFloat) -> UIImage {
        let cgwidth: CGFloat = CGFloat(width)
        let cgheight: CGFloat = CGFloat(height)
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        guard let cgImage = self.cgImage ,
              let imageRef = cgImage.cropping(to: rect) else {
            return UIImage()
        }
        let ret_image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return ret_image
    }
}
