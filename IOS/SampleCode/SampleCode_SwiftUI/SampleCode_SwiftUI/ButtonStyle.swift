//
//  ButtonStyle.swift
//  SampleCode_SwiftUI
//
//  Created by doinglab on 4/30/24.
//

import SwiftUI

struct FoodLensButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct BorderButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding(.horizontal, 7)
            .padding(.vertical, 1)
            .overlay(
                Capsule()
                    .stroke(style: .init(lineWidth: 0.3))
            )
    }
}
