//
//  CardProfile.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct CardProfile: View {
    let title: String
    let price: Int
    let oldPrice: Int
    let discount: Int
    let rating: Double
    let reviews: Int
    let imageUrl: String?
    let isTimeLimited: Bool
    let colorBottom: Color
    let colorText: Color
    
    init(
        title: String,
        price: Int,
        oldPrice: Int = 0,
        discount: Int = 0,
        rating: Double,
        reviews: Int,
        imageUrl: String? = nil,
        isTimeLimited: Bool = false,
        colorBottom: Color = Color.white,
        colorText: Color = Color(hex: "5D76CB") ?? AppTheme.blueButton
    ) {
        self.title = title
        self.price = price
        self.oldPrice = oldPrice
        self.discount = discount
        self.rating = rating
        self.reviews = reviews
        self.imageUrl = imageUrl
        self.isTimeLimited = isTimeLimited
        self.colorBottom = colorBottom
        self.colorText = colorText
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Градиент внизу
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0),
                    Color(hex: "FFECEC") ?? Color.white.opacity(0.1),
                    colorBottom
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: FigmaDimens.fh(35))
            
            VStack(spacing: 0) {
                // Картинка
                ZStack(alignment: .topTrailing) {
                    // Фон для изображения
                    Rectangle()
                        .fill(Color(hex: "E5E5E5") ?? Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                    
                    // Карусель изображений (используем тестовые изображения)
                    ProductImageCarousel(
                        images: [
                            "image_for_product_3",
                            "image_for_product_2",
                            "image_for_product_1"
                        ]
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: FigmaDimens.fh(190))
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    
                    // Иконка лайка
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(hex: "CC3333") ?? .red)
                        .font(.system(size: 16))
                        .padding(8)
                }
                .frame(width: FigmaDimens.fw(210))
                .frame(height: FigmaDimens.fh(190))
                .clipped()
                .overlay(alignment: .bottomTrailing) {
                    // Скидка (в правом нижнем углу, накладывается на картинку)
                    if discount > 0 {
                        Text("-\(discount)%")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(colorText)
                            .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(35))
                            .background(Color.white)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            .offset(y: -FigmaDimens.fh(20))
                    }
                }
                
                Spacer()
                    .frame(height: FigmaDimens.fh(5))
                
                // Информация о товаре
                VStack(alignment: .leading, spacing: 0) {
                    // Рейтинг и отзывы
                    HStack {
                        Group {
                            if let uiImage = UIImage(named: "otz_icon") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: "message.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 10, height: 10)
                        
                        Text("\(reviews) отзыва")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 10, weight: .bold))
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(hex: "FFD700") ?? .yellow)
                            .font(.system(size: 12))
                    }
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Название
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .frame(width: FigmaDimens.fw(180), alignment: .leading)
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(5))
                    
                    // Цены
                    HStack(alignment: .bottom, spacing: FigmaDimens.fw(5)) {
                        if oldPrice != 0 {
                            VStack(alignment: .trailing, spacing: 0) {
                                Spacer()
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .strikethrough()
                                    .lineSpacing(9 - 8)
                            }
                            .frame(height: FigmaDimens.fh(10), alignment: .bottom)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(price) ₽")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(colorText)
                                .lineSpacing(16 - 14)
                            Spacer()
                        }
                        .frame(height: FigmaDimens.fh(20), alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, FigmaDimens.fw(15))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: FigmaDimens.fw(210), height: FigmaDimens.fh(360))
        .background(Color.white)
        .cornerRadius(16)
    }
}

