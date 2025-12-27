//
//  HistorySectionProduct.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct HistorySectionProduct: View {
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок секции
            HStack {
                Text("История просмотров")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.black)
                    .lineSpacing(25 - 25)
                
                Spacer()
                
                Group {
                    if let uiImage = UIImage(named: "circle_right") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 24, height: 24)
            }
            .frame(height: FigmaDimens.fh(70))
            .padding(.horizontal, FigmaDimens.fw(15))
            
            // Горизонтальный скролл карточек
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FigmaDimens.fw(15)) {
                    ForEach(historyItems, id: \.title) { item in
                        CardProfile(
                            title: item.title,
                            price: item.price,
                            oldPrice: item.oldPrice,
                            discount: item.discount,
                            rating: item.rating,
                            reviews: item.reviews,
                            imageUrl: nil,
                            isTimeLimited: item.isTimeLimited,
                            colorBottom: item.colorBottom,
                            colorText: item.colorText
                        )
                    }
                }
                .padding(.horizontal, FigmaDimens.fw(15))
            }
        }
        .frame(height: FigmaDimens.fh(400))
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, FigmaDimens.fw(15))
    }
    
    private var historyItems: [HistoryItem] {
        [
            HistoryItem(
                title: "Брюки прямые TBOE",
                price: 800,
                oldPrice: 3000,
                discount: 70,
                rating: 4.8,
                reviews: 944,
                isTimeLimited: true,
                colorBottom: Color(hex: "5D76CB") ?? AppTheme.blueButton,
                colorText: Color(hex: "5D76CB") ?? AppTheme.blueButton
            ),
            HistoryItem(
                title: "Часы наручные Кварцевые",
                price: 4200,
                oldPrice: 21000,
                discount: 80,
                rating: 5.0,
                reviews: 23,
                isTimeLimited: true,
                colorBottom: Color(hex: "CC3333") ?? .red,
                colorText: Color(hex: "CC3333") ?? .red
            ),
            HistoryItem(
                title: "Кеды adidas Sportswear Hoops 3.0",
                price: 3743,
                oldPrice: 0,
                discount: 0,
                rating: 4.9,
                reviews: 457,
                isTimeLimited: true,
                colorBottom: Color(hex: "5D76CB") ?? AppTheme.blueButton,
                colorText: Color(hex: "5D76CB") ?? AppTheme.blueButton
            ),
            HistoryItem(
                title: "Xiaomi 15T + часы Xiaomi Watch",
                price: 40000,
                oldPrice: 60000,
                discount: 20,
                rating: 4.9,
                reviews: 437,
                isTimeLimited: true,
                colorBottom: Color(hex: "5D76CB") ?? AppTheme.blueButton,
                colorText: Color(hex: "5D76CB") ?? AppTheme.blueButton
            )
        ]
    }
}

struct HistoryItem {
    let title: String
    let price: Int
    let oldPrice: Int
    let discount: Int
    let rating: Double
    let reviews: Int
    let isTimeLimited: Bool
    let colorBottom: Color
    let colorText: Color
}

