//
//  CardCart.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct CardCart: View {
    let cartItem: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    let onToggleSelection: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        let product = cartItem.product
        let price = product.price
        let oldPrice = product.oldPrice ?? price
        let sale = product.calculateDiscountPercent() ?? 0
        let accentColor = product.accentColor
        let productName = product.name
        
        // Получаем первое изображение продукта или варианта
        let productImage: String = {
            if let variantId = cartItem.selectedVariantId,
               let variant = product.variants.first(where: { $0.id == variantId }),
               !variant.imagesRes.isEmpty {
                return variant.imagesRes[0]
            } else if !product.imagesRes.isEmpty {
                return product.imagesRes[0]
            } else {
                return "placeholder"
            }
        }()
        
        VStack(spacing: 0) {
            // Верхняя часть: изображение и информация
            ZStack(alignment: .topLeading) {
                // Контент (картинка и текст)
                HStack(spacing: 0) {
                    // Изображение
                    Group {
                        if productImage == "placeholder" {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray.opacity(0.5))
                        } else if let uiImage = UIImage(named: productImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                    .frame(width: FigmaDimens.fw(150), height: FigmaDimens.fh(150))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Информация о товаре
                    VStack(alignment: .leading, spacing: 0) {
                        // Цена и скидка
                        HStack {
                            Text("\(price) ₽")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(accentColor)
                            
                            Spacer()
                            
                            // Плашка скидки
                            if sale > 0 {
                                ZStack {
                                    Color.white
                                        .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(30))
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    
                                    Text("- \(sale) %")
                                        .font(.system(size: 16, weight: .black))
                                        .foregroundColor(accentColor)
                                }
                            }
                        }
                        .frame(height: FigmaDimens.fh(30))
                        
                        Spacer().frame(height: FigmaDimens.fh(5))
                        
                        // Старая цена
                        if oldPrice != price {
                            Text("\(oldPrice) ₽")
                                .font(.system(size: 10))
                                .strikethrough()
                                .foregroundColor(Color(hex: "999999") ?? .gray)
                                .frame(height: FigmaDimens.fh(20), alignment: .leading)
                        }
                        
                        Spacer().frame(height: FigmaDimens.fh(20))
                        
                        // Название товара
                        Text(productName)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                            .lineLimit(3)
                            .frame(width: FigmaDimens.fw(150), height: FigmaDimens.fh(70), alignment: .topLeading)
                    }
                    .padding(.horizontal, FigmaDimens.fw(10))
                }
                .padding(.horizontal, FigmaDimens.fw(5))
                .padding(.vertical, FigmaDimens.fh(5))
                .frame(height: FigmaDimens.fh(150))
                
                // Чекбокс выбора (сверху слева)
                Button(action: onToggleSelection) {
                    ZStack {
                        // Белый фон с особыми скруглениями
                        Color.white
                            .frame(width: 35, height: 35)
                            .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
                        
                        // Внутренний квадрат (чекбокс)
                        Group {
                            if cartItem.isSelected {
                                Color(hex: "CC5D76CB") ?? AppTheme.blueButton.opacity(0.8)
                            } else {
                                Color(hex: "F2F2F2") ?? Color.gray.opacity(0.2)
                            }
                        }
                        .frame(width: 25, height: 25)
                        .cornerRadius(6)
                        .overlay(
                            Group {
                                if cartItem.isSelected {
                                    if let uiImage = UIImage(named: "check_icon") {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 14, height: 14)
                                    } else {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        )
                    }
                }
                .frame(width: 35, height: 35)
            }
            
            // Нижняя часть: действия
            HStack {
                HStack(spacing: FigmaDimens.fw(20)) {
                    // Кнопка избранного
                    Button(action: onToggleFavorite) {
                        ZStack {
                            if product.isFavorite {
                                Color(hex: "FFD4D4") ?? Color.pink.opacity(0.3)
                            } else {
                                Color.white
                            }
                        }
                        .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                        .cornerRadius(10)
                        .overlay(
                            Group {
                                if let uiImage = UIImage(named: product.isFavorite ? "lover" : "unlover") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(product.isFavorite ? .red : .gray)
                                        .font(.system(size: 16))
                                }
                            }
                        )
                    }
                    
                    // Кнопка удаления
                    Button(action: onRemove) {
                        ZStack {
                            Color.white
                        }
                        .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "DCDCDC") ?? .gray, lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if let uiImage = UIImage(named: "cart") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                } else {
                                    Image(systemName: "trash")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                            }
                        )
                    }
                    
                    // Счетчик
                    CounterCart(
                        count: cartItem.quantity,
                        onDecrement: {
                            if cartItem.quantity > 1 {
                                onQuantityChange(cartItem.quantity - 1)
                            } else {
                                onRemove()
                            }
                        },
                        onIncrement: {
                            onQuantityChange(cartItem.quantity + 1)
                        }
                    )
                }
                
                Spacer()
                
                // Кнопка "Купить"
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "DCDCDC") ?? .gray, lineWidth: 1)
                }
                .frame(width: FigmaDimens.fw(130), height: FigmaDimens.fh(30))
                .overlay(
                    Text("Купить")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                )
            }
            .padding(.horizontal, FigmaDimens.fw(15))
            .frame(height: FigmaDimens.fh(60))
        }
        .background(Color.white)
    }
}

