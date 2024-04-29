//
//  ViewModel.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/30/24.
//

import UIKit
import FoodLensUI
import FoodLensCore

class ViewModel: ObservableObject {
    @Published var result: RecognitionResult = .init()
    
    @Published var isShowPhotoPicker: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    
    @Published var predictedFoodImage: UIImage = UIImage()
    
    func predict(image: UIImage) {
        let foodlensCoreService = FoodLensCoreService(type: .foodlens)
        Task {
            let result = await foodlensCoreService.predict(image: image)
            switch result {
            case .success(let success):
                print(success.toJSONString() ?? "")
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


extension ViewModel: RecognitionResultHandler {
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
