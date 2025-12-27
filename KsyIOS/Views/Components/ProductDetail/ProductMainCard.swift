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
                    .onAppear {
                        currentPage = 0
                    }
                }
            }
            .frame(height: FigmaDimens.fh(400)) // Уменьшили высоту для ближе к Kotlin (было 440)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
                .frame(height: FigmaDimens.fh(8)) // Меньше spacer
            
            // Индикаторы — spacing 6, gray BDBDBD
            HStack(spacing: 6) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppTheme.blueButton : Color(hex: "BDBDBD") ?? .gray)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, FigmaDimens.fw(15)) // Левее
            
            Spacer()
                .frame(height: FigmaDimens.fh(8))
            
            // Название
            Text(productName)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FigmaDimens.fw(15)) // Симметрия слева/справа
            
            Spacer()
                .frame(height: FigmaDimens.fh(8))
            
            // Скидка и цена — адаптировали для случаев без скидки (центр цены)
            HStack(spacing: FigmaDimens.fw(10)) {
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
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                
                ZStack {
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
                    
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Text("\(price) ₽")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(accentColor)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        
                        if oldPrice > 0 {
                            HStack {
                                Spacer()
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 15))
                                    .strikethrough()
                                    .foregroundColor(Color(hex: "999999") ?? .gray)
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 15) // Увеличили padding
                    .padding(.vertical, FigmaDimens.fh(5))
                }
                .frame(width: sale > 0 ? FigmaDimens.fw(140) : FigmaDimens.fw(200), height: FigmaDimens.fh(70)) // Шире без скидки для центра
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                if sale == 0 {
                    Spacer() // Для центра без скидки
                }
            }
            .padding(.horizontal, FigmaDimens.fw(15))
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, 15) // Меньше bottom padding
    }
}