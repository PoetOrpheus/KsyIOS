//
//  CardPickUp.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct CardPickUp: View {
    let productName: String
    let imageName: String?
    let stateDelivery: String
    let stateColor: Color
    
    init(
        productName: String = "Брюки прямые ТВОЕ",
        imageName: String? = nil,
        stateDelivery: String = "Доставлено",
        stateColor: Color = Color(hex: "50C878") ?? .green
    ) {
        self.productName = productName
        self.imageName = imageName
        self.stateDelivery = stateDelivery
        self.stateColor = stateColor
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Изображение товара
            Group {
                if let imageName = imageName, let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // Placeholder
                    Rectangle()
                        .fill(Color(hex: "E5E5E5") ?? Color.gray.opacity(0.2))
                }
            }
            .frame(width: FigmaDimens.fw(100), height: FigmaDimens.fh(100))
            .clipped()
            .overlay(
                Rectangle()
                    .stroke(Color.white, lineWidth: 4)
                    .cornerRadius(20, corners: [.topLeft, .bottomLeft])
            )
            .cornerRadius(20, corners: [.topLeft, .bottomLeft])
            
            // Информация о товаре
            VStack(alignment: .leading, spacing: 0) {
                // Название товара
                Text(productName)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.black)
                    .lineLimit(3)
                    .lineSpacing(10 - 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Информация о доставке
                VStack(alignment: .leading, spacing: 0) {
                    Text("Доставка в ПВЗ:")
                        .font(.system(size: 8, weight: .regular))
                        .foregroundColor(Color(hex: "919191") ?? .gray)
                        .lineSpacing(9 - 8)
                    
                    Text(stateDelivery)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(stateColor)
                        .lineSpacing(10 - 9)
                }
            }
            .padding(.horizontal, FigmaDimens.fw(10))
            .padding(.vertical, FigmaDimens.fh(10))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(width: FigmaDimens.fw(200), height: FigmaDimens.fh(100))
        .background(Color.white)
        .cornerRadius(20)
    }
}

