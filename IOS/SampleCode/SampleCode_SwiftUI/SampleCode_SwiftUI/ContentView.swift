//
//  ContentView.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/29/24.
//

import SwiftUI
import FoodLensUI
import FoodLensCore

struct ContentView: View {
    @Environment(\.viewController) var viewControllerHolder
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 40.0) {
                VStack(spacing: 8.0) {
                    Button("Start FoodLens Core") {
                        DispatchQueue.main.async {
                            self.viewModel.isShowPhotoPicker = true
                        }
                    }
                    .buttonStyle(FoodLensButtonStyle())
                    
                    Button("Start FoodLens camera") {
                        let foodlensUIService = FoodLensUIService(type: .caloai)
                        
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
                        FoodLensStorage.shared.save(image: self.viewModel.predictedFoodImage, fileName: viewModel.result.imagePath ?? "")
                        let foodlensUIService = FoodLensUIService(type: .caloai)
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
            
            if self.viewModel.isLoading {
                ProgressView()
            }
        }
        .sheet(isPresented: self.$viewModel.isShowPhotoPicker) {
            PHPicker(selectedImage: self.$viewModel.selectedImage)
        }
        .onChange(of: self.viewModel.selectedImage) { image in
            Task {
                await self.viewModel.predict(image: image)
            }
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
                        ResultItemView(image: self.fullImage.fixedOrientation()?.cropToBox($0.position) ?? UIImage(), food: $0)
                        
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
