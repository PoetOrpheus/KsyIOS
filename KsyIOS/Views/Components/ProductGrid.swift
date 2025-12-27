//
//  ProductGrid.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct ProductGrid: View {
    let products: [Product]
    let onProductClick: (Product) -> Void
    let onToggleFavorite: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Разбиваем продукты на пары для отображения в ряд
            ForEach(Array(products.chunked(into: 2).enumerated()), id: \.offset) { rowIndex, rowProducts in
                HStack(spacing: FigmaDimens.fw(10)) {
                    ForEach(Array(rowProducts.enumerated()), id: \.element.id) { itemIndex, product in
                        let cardIndex = rowIndex * 2 + itemIndex
                        ProductCard(
                            product: product,
                            onClick: { onProductClick(product) },
                            onFavoriteClick: { onToggleFavorite(product.id) },
                            appearanceDelay: cardIndex * 50
                        )
                        .frame(maxWidth: .infinity)
                    }
                    // Если в ряду только один элемент, добавляем пустое место
                    if rowProducts.count == 1 {
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, FigmaDimens.fh(10))
            }
        }
        .padding(.horizontal, FigmaDimens.fw(10))
        .frame(maxWidth: .infinity)
    }
}

struct ProductCard: View {
    let product: Product
    let onClick: () -> Void
    let onFavoriteClick: () -> Void
    let appearanceDelay: Int
    
    @State private var isVisible: CGFloat = 0
    @State private var alpha: Double = 0
    @State private var isPressed = false
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        let oldPrice = product.oldPrice ?? 0
        let discount = product.calculateDiscountPercent() ?? 0
        let accentColor = product.accentColor
        
        ZStack {
                // Градиентный фон внизу карточки
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color(hex: "FFECEC") ?? Color.white.opacity(0.1),
                        accentColor
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: FigmaDimens.fh(60))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // Контент карточки
                VStack(spacing: 0) {
                    // Область изображения (как в Kotlin - белый фон с rounded corners)
                    ZStack(alignment: .topTrailing) {
                        // Белый фон с закругленными углами (как в Kotlin)
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: FigmaDimens.fh(280))
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                        
                        // Используем изображения из продукта для карусели
                        let productImages = product.imagesRes.isEmpty ? ["placeholder"] : product.imagesRes
                        
                        ProductImageCarousel(images: productImages)
                            .frame(height: FigmaDimens.fh(280))
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                            .clipped()
                        
                        // Иконка избранного (модификатор 45x45 как в Kotlin, кнопка 30x30 внутри)
                        FavoriteIconButton(
                            isFavorite: product.isFavorite,
                            onClick: onFavoriteClick
                        )
                        .frame(
                            width: FigmaDimens.fw(45),
                            height: FigmaDimens.fh(45),
                            alignment: .topTrailing
                        )
                    }
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(5))
                    
                    // Информация о товаре
                    VStack(spacing: 0) {
                        // Рейтинг и отзывы
                        HStack(spacing: 0) {
                            // Иконка отзывов (используем оригинальную otz_icon или fallback)
                            Group {
                                if let uiImage = UIImage(named: "otz_icon") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.gray)
                                        .frame(width: FigmaDimens.fw(10), height: FigmaDimens.fh(10))
                                } else {
                                    Image(systemName: "bubble.left.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .frame(width: FigmaDimens.fw(10))
                                }
                            }
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(5))
                            
                            // Количество отзывов
                            Text("\(product.reviewsCount) отзыва")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .frame(width: FigmaDimens.fw(75), height: 8, alignment: .leading)
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(25))
                            
                            // Рейтинг (черный цвет как в Kotlin)
                            Text(String(format: "%.1f", product.rating))
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.black)
                                .frame(width: FigmaDimens.fw(50), height: 10, alignment: .trailing)
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(5))
                            
                            // Звезда (используем оригинальную star_profile_menu или fallback)
                            Group {
                                if let uiImage = UIImage(named: "star_profile_menu") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.yellow)
                                        .frame(width: FigmaDimens.fw(10), height: FigmaDimens.fh(10))
                                } else {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(.yellow)
                                        .frame(width: FigmaDimens.fw(10))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, FigmaDimens.fw(15))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        // Название (черный цвет как в Kotlin)
                        Text(product.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(
                                width: FigmaDimens.fw(180),
                                height: FigmaDimens.fh(40),
                                alignment: .topLeading
                            )
                            .padding(.horizontal, FigmaDimens.fw(15))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(5))
                        
                        // Цены (как в Kotlin - выровнены по bottom)
                        HStack(alignment: .bottom, spacing: FigmaDimens.fw(5)) {
                            if oldPrice > 0 {
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .strikethrough()
                                    .frame(height: FigmaDimens.fh(10), alignment: .bottom)
                            }
                            
                            Spacer()
                            
                            Text("\(product.price) ₽")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(accentColor)
                                .frame(height: FigmaDimens.fh(20), alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, FigmaDimens.fw(15))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(5))
                        
                        // Скидка
                        ZStack(alignment: .bottomLeading) {
                            if discount > 0 {
                                Text("-\(discount)%")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.discountRed)
                                    .frame(
                                        width: FigmaDimens.fw(60),
                                        height: FigmaDimens.fh(35)
                                    )
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                        }
                        .frame(height: FigmaDimens.fh(35))
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        .padding(.horizontal, FigmaDimens.fw(15))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                    }
                }
            }
            .frame(
                width: FigmaDimens.fw(210),
                height: FigmaDimens.fh(420)
            )
            .background(Color.white)
            .cornerRadius(15)
            .shadow(
                color: isPressed ? Color.black.opacity(0.1) : Color.black.opacity(0.2),
                radius: isPressed ? 2 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .scaleEffect((isVisible * (isPressed ? 0.95 : 1.0)))
            .opacity(alpha)
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    dragOffset = value.translation
                    
                    // Если движение преимущественно вертикальное (скролл), не показываем pressed
                    let verticalMovement = abs(value.translation.height)
                    let horizontalMovement = abs(value.translation.width)
                    
                    if verticalMovement > 8 && verticalMovement > horizontalMovement * 1.5 {
                        // Это скролл - не показываем pressed и не блокируем скролл
                        isDragging = true
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isPressed = false
                        }
                    } else if !isDragging {
                        // Это нажатие (не скролл) - показываем визуальную обратную связь
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { value in
                    let verticalMovement = abs(value.translation.height)
                    let horizontalMovement = abs(value.translation.width)
                    
                    // Если движение было минимальным (меньше 10 пикселей), это нажатие
                    // Если движение было преимущественно вертикальным и больше 10 пикселей, это скролл
                    let isScroll = verticalMovement > 10 && verticalMovement > horizontalMovement * 1.5
                    
                    if !isScroll {
                        // Это было нажатие - срабатываем onClick
                        onClick()
                    }
                    
                    // Сбрасываем состояния
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = false
                    }
                    isDragging = false
                    dragOffset = .zero
                }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(appearanceDelay) / 1000.0) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isVisible = 1.0
                }
                withAnimation(.easeIn(duration: 0.3)) {
                    alpha = 1.0
                }
            }
        }
    }
}

struct FavoriteIconButton: View {
    let isFavorite: Bool
    let onClick: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                Circle()
                    .fill(Color(hex: "F2F2F2")?.opacity(0.7) ?? Color.white.opacity(0.8))
                    .frame(
                        width: FigmaDimens.fw(30),
                        height: FigmaDimens.fh(30)
                    )
                
                // Используем оригинальные иконки lover/unlover или fallback
                Group {
                    let iconName = isFavorite ? "lover" : "unlover"
                    if let uiImage = UIImage(named: iconName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isFavorite ? .red : .gray)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                }
            }
            .scaleEffect(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(4)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
        )
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
