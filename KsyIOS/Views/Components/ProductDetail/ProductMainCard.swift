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
            // Карусель изображений
            ZStack {
                Color(hex: "E5E5E5") ?? Color.gray.opacity(0.2)
                
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
                    .onAppear {
                        currentPage = 0
                    }
                }
            }
            .frame(height: FigmaDimens.fh(440))
            .cornerRadius(20)
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Индикаторы (точки)
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
            .padding(.leading, FigmaDimens.fw(20))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Название
            Text(productName)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .padding(.horizontal, FigmaDimens.fw(20))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Скидка и цена
            HStack(spacing: 10) {
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
                
                // Блок с ценой
                ZStack(alignment: .bottom) {
                    // Градиент снизу
                    LinearGradient(
                        gradient: Gradient(colors: [
                            accentColor.opacity(0.0),
                            accentColor.opacity(0.1),
                            accentColor
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 25)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    
                    // Контент
                    VStack(alignment: .trailing, spacing: 0) {
                        if oldPrice > 0 {
                            Text("\(oldPrice) ₽")
                                .font(.system(size: 15))
                                .strikethrough()
                                .foregroundColor(Color(hex: "999999") ?? .gray)
                        }
                        
                        Text("\(price) ₽")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(accentColor)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .frame(width: 140, height: 70)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
            }
            .padding(.horizontal, FigmaDimens.fw(20))
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

