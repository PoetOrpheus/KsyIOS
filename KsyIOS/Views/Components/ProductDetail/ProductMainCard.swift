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
            
            // Цена и скидка — центрирование без скидки
            HStack {
                if sale > 0 {
                    // Блок скидки как в часах
                    HStack {
                        Text("Скидка \(sale)%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(accentColor)
                    }
                    .padding(.horizontal, FigmaDimens.fw(20))
                    .frame(height: FigmaDimens.fh(50))
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Spacer()
                }
                
                // Блок цены — шире и центрировано без скидки
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [accentColor.opacity(0), accentColor.opacity(0.3), accentColor]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: FigmaDimens.fh(30), alignment: .bottom)
                    
                    VStack(spacing: 4) {
                        Text("\(price) ₽")
                            .font(.system(size: 36, weight: .bold)) // Больше шрифт как в кедах
                            .foregroundColor(accentColor)
                        
                        if oldPrice > 0 {
                            Text("\(oldPrice) ₽")
                                .font(.system(size: 18))
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, FigmaDimens.fh(10))
                }
                .frame(width: sale > 0 ? FigmaDimens.fw(160) : FigmaDimens.fw(300), height: FigmaDimens.fh(80)) // Шире без скидки для центра
                .background(Color.white)
                .cornerRadius(15) // Больше radius как в Kotlin
                .shadow(radius: 5)
            }
            .padding(.horizontal, FigmaDimens.fw(20))
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}