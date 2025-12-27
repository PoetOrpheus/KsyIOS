//
//  BottomProfileMenuNavigation.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct BottomProfileMenuNavigation: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(menuItems.enumerated()), id: \.offset) { index, item in
                RowCategory(
                    text: item,
                    showLine: index != menuItems.count - 1
                )
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, FigmaDimens.fw(15))
    }
    
    private let menuItems = [
        "Заказы",
        "Возвраты",
        "Купленные товары",
        "Избранные магазины и бренды",
        "Отзывы",
        "Сертификаты и промокоды"
    ]
}

struct RowCategory: View {
    let text: String
    let showLine: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Строка с текстом и иконкой
            HStack {
                Text(text)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.black)
                    .lineSpacing(14 - 12)
                
                Spacer()
                
                Group {
                    if let uiImage = UIImage(named: "profile_right_2") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
                .frame(width: 12, height: 12)
            }
            .frame(height: FigmaDimens.fh(35))
            .padding(.horizontal, FigmaDimens.fw(15))
            
            // Разделительная линия
            if showLine {
                Rectangle()
                    .fill(Color(hex: "F0F0F0") ?? Color.gray.opacity(0.1))
                    .frame(height: 1)
                    .padding(.horizontal, FigmaDimens.fw(15))
            }
        }
    }
}

