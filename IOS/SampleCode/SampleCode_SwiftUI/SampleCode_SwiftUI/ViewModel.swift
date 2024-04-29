//
//  ViewModel.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/30/24.
//

import UIKit
import FoodLensUI
import FoodLensCore

class ViewModel: ObservableObject, RecognitionResultHandler {
    @Published var result: RecognitionResult = .init()
    
    @Published var isShowPhotoPicker: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    
    @Published var predictedFoodImage: UIImage = UIImage()
    
    func onSuccess(_ result: RecognitionResult) {
        self.predictedFoodImage = FoodLensStorage.shared.load(fileName: result.imagePath ?? "") ?? .init()
        DispatchQueue.main.async {
            self.result = result
        }
        print(result.toJSONString() ?? "")
    }
    
    func onCancel() {
        print("cancel")
    }
    
    func onError(_ error: Error) {
        print(error)
    }
}
