//
//  ViewModel.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/30/24.
//

import UIKit
import FoodLensUI
import FoodLensCore

final class ViewModel: ObservableObject, @unchecked Sendable {
    @Published var result: RecognitionResult = .init()
    
    @Published var isShowPhotoPicker: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    
    @Published var predictedFoodImage: UIImage = UIImage()
    
    @Published var isLoading: Bool = false
    
    func predict(image: UIImage) async {
        let foodlensCoreService = FoodLensCoreService(type: .caloai)
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let result = await foodlensCoreService.predict(image: image)
        switch result {
        case .success(let response):
            DispatchQueue.main.async {
                self.predictedFoodImage = self.selectedImage
                self.result = response
                self.isLoading = false
                print(response)
            }
        case .failure(let failure):
            print(failure)
        }
    }
}

extension ViewModel: RecognitionResultHandler {
    func onSuccess(_ result: RecognitionResult) {
        self.predictedFoodImage = FoodLensStorage.shared.load(fileName: result.imagePath ?? "") ?? .init()
        self.result = result
        print(result.toJSONString() ?? "")
    }
    
    func onCancel() {
        print("cancel")
    }
    
    func onError(_ error: Error) {
        print(error)
    }
}
