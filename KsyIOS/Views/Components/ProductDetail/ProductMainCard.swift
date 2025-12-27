//
//  ProductMainCard.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct ProductMainCard: View {
    let product: Product
    let selectedVariantId: String?
    
    @State private var currentPage: Int = 0
    
    var body: some View {
        let productName = product.name
        let sale = product.calculateDiscountPercent() ?? 0
        let price = product.price
        let oldPrice = product.oldPrice ?? 0
        let accentColor = product.accentColor
        
        let selectedVariant = selectedVariantId.flatMap { variantId in
            product.variants.first { $0.id == variantId }
        }
        
        let images: [String] = {
            if let variantImages = selectedVariant?.imagesRes, !variantImages.isEmpty {
                return variantImages
            } else if !product.imagesRes.isEmpty {
                return product.imagesRes
            } else {
                return ["placeholder"]
            }
        }()
        
        VStack(spacing: 0) {
            ZStack {
                Color.white
                
                if images.isEmpty || (images.count == 1 && images.first == "placeholder") {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TabView(selection: $currentPage) {
                        ForEach(0..<images.count, id: \.self) { index in
                            let imageName = images[index]
                            Group {
                                if imageName == "placeholder" {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.5))
                                } else if let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .frame(height: FigmaDimens.fh(500)) // Увеличили до 500 для большего фото как в кедах Kotlin
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer().frame(height: FigmaDimens.fh(15))
            
            // Точки индикатора слева
            HStack(spacing: 8) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppTheme.blueButton : Color(hex: "BDBDBD") ?? .gray)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, FigmaDimens.fw(20))
            
            Spacer().frame(height: FigmaDimens.fh(15))
            
            // Название слева
            Text(productName)
                .font(.system(size: 20, weight: .regular)) // Чуть больше шрифт как в Kotlin
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FigmaDimens.fw(20))
            
            Spacer().frame(height: FigmaDimens.fh(15))
            
            // Цена и скидка — прижаты к правому краю с отступом 5dp
            HStack(spacing: FigmaDimens.fw(10)) {
                if sale > 0 {
                    // Блок скидки как в Kotlin: fw(160) x fh(50)
                    HStack(spacing: 0) {
                        Text("Скидка")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(height: FigmaDimens.fh(50))
                        
                        Text("\(sale)%")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(accentColor)
                            .frame(width: FigmaDimens.fw(70), height: FigmaDimens.fh(50))
                    }
                    .frame(width: FigmaDimens.fw(160), height: FigmaDimens.fh(50))
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                // Блок цены как в Kotlin: 140dp x 70dp
                ZStack(alignment: .bottom) {
                    // Градиент внизу (25dp высота)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            accentColor.opacity(0),
                            accentColor.opacity(0.1),
                            accentColor
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: FigmaDimens.fh(25))
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    
                    // Контент
                    VStack(spacing: 4) {
                        // Новая цена сверху справа
                        HStack {
                            Spacer()
                            Text("\(price) ₽")
                                .font(.system(size: 24, weight: .bold)) // Уменьшили с 30 до 24, чтобы помещалась
                                .foregroundColor(accentColor)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Старая цена ниже новой
                        if oldPrice > 0 {
                            HStack {
                                Spacer()
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 15))
                                    .strikethrough()
                                    .foregroundColor(Color(hex: "999999") ?? .gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .frame(width: FigmaDimens.fw(140), height: FigmaDimens.fh(70))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // Прижимаем к правому краю
            .padding(.leading, FigmaDimens.fw(20)) // Отступ слева как было
            .padding(.trailing, FigmaDimens.fw(5)) // Отступ справа 5dp как в Kotlin
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}