//
//  ProductMainCard.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
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
        
        // Получаем изображения для карусели
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
            // Карусель изображений (как в Kotlin: HorizontalPager с clip, фон белый из Column)
            ZStack {
                Color.white // Белый фон как в Kotlin (Column имеет background Color.White)
                
                if images.isEmpty || (images.count == 1 && images.first == "placeholder") {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit() // ContentScale.Fit в Kotlin
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
                                        .scaledToFit() // ContentScale.Fit в Kotlin
                                        .foregroundColor(.gray.opacity(0.5))
                                } else if let uiImage = UIImage(named: imageName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit() // ContentScale.Fit в Kotlin - сохраняет пропорции, вписывает в контейнер
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit() // ContentScale.Fit в Kotlin
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onAppear {
                        currentPage = 0
                    }
                }
            }
            .frame(height: FigmaDimens.fh(440)) // Как в Kotlin: height = fh(440)
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Как в Kotlin: clip(RoundedCornerShape(20.dp))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Индикаторы (точки) - выровнены по левому краю (как в Kotlin: padding start = fw(20))
            HStack(spacing: 4) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppTheme.blueButton : Color(hex: "BDBDBD") ?? .gray)
                        .frame(
                            width: 6,
                            height: 6
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, FigmaDimens.fw(20))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Название - выровнено по левому краю (как в Kotlin: padding horizontal = fw(20), но визуально левый край совпадает с точками)
            Text(productName)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, FigmaDimens.fw(20))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Скидка и цена
            HStack(spacing: FigmaDimens.fw(10)) {
                // Скидка (если есть)
                if sale > 0 {
                    HStack(spacing: 0) {
                        Text("Скидка")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("\(sale)%")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(accentColor)
                            .frame(width: FigmaDimens.fw(70))
                    }
                    .frame(height: FigmaDimens.fh(50))
                    .frame(width: FigmaDimens.fw(160))
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                }
                
                Spacer()
                
                // Блок с ценой (размеры как в Kotlin: 140x70, используем fw/fh)
                ZStack {
                    // Градиент снизу (как в Kotlin: height = 25.dp, align = Alignment.BottomCenter)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            accentColor.opacity(0.0),
                            accentColor.opacity(0.1),
                            accentColor
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: FigmaDimens.fh(25))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
                    // Контент (как в Kotlin: Column с Arrangement.Center, padding horizontal = 10.dp, vertical = 5.dp)
                    VStack(spacing: 0) {
                        // Новая цена (первая в Column, выравнивание по правому краю - align(Alignment.End))
                        HStack {
                            Spacer()
                            Text("\(price) ₽")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(accentColor)
                        }
                        
                        // Старая цена (вторая в Column, как в Kotlin: Box с fillMaxWidth и Alignment.TopEnd)
                        if oldPrice > 0 {
                            HStack {
                                Spacer()
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 15))
                                    .strikethrough()
                                    .foregroundColor(Color(hex: "999999") ?? .gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, FigmaDimens.fw(10))
                    .padding(.vertical, FigmaDimens.fh(5))
                }
                .frame(width: FigmaDimens.fw(140), height: FigmaDimens.fh(70))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
            }
            .padding(.horizontal, FigmaDimens.fw(20))
            // НЕТ Spacer после блока с ценой - padding применяется на уровне VStack (как в Kotlin)
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, FigmaDimens.fh(20)) // Как в Kotlin: .padding(bottom = 20.dp) на Column
    }
}

