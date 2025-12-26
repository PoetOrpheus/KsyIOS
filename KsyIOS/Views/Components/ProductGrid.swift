//
//  ProductGrid.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ProductGrid: View {
    let products: [Product]
    let onProductClick: (Product) -> Void
    let onToggleFavorite: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Разбиваем продукты на пары для отображения в ряд
                ForEach(Array(products.chunked(2).enumerated()), id: \.offset) { rowIndex, rowProducts in
                    HStack(spacing: FigmaDimens.fw(10, geometry: geometry)) {
                        ForEach(Array(rowProducts.enumerated()), id: \.element.id) { itemIndex, product in
                            let cardIndex = rowIndex * 2 + itemIndex
                            ProductCard(
                                product: product,
                                geometry: geometry,
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
                    .padding(.bottom, FigmaDimens.fh(10, geometry: geometry))
                }
            }
            .padding(.horizontal, FigmaDimens.fw(10, geometry: geometry))
        }
    }
}

struct ProductCard: View {
    let product: Product
    let geometry: GeometryProxy
    let onClick: () -> Void
    let onFavoriteClick: () -> Void
    let appearanceDelay: Int
    
    @State private var isVisible: CGFloat = 0
    @State private var alpha: Double = 0
    @State private var isPressed = false
    
    var body: some View {
        let oldPrice = product.oldPrice ?? 0
        let discount = product.calculateDiscountPercent() ?? 0
        let accentColor = product.accentColor
        let cardWidth = FigmaDimens.fw(210, geometry: geometry)
        let cardHeight = FigmaDimens.fh(420, geometry: geometry)
        
        Button(action: onClick) {
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
                .frame(height: FigmaDimens.fh(60, geometry: geometry))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // Контент карточки
                VStack(spacing: 0) {
                    // Область изображения
                    ZStack(alignment: .topTrailing) {
                        Rectangle()
                            .fill(Color(hex: "E5E5E5") ?? Color.gray.opacity(0.2))
                            .frame(height: FigmaDimens.fh(280, geometry: geometry))
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                        
                        // Заглушка для изображения (в реальном приложении здесь будет карусель изображений)
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: FigmaDimens.fh(260, geometry: geometry))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        // Иконка избранного
                        FavoriteIconButton(
                            isFavorite: product.isFavorite,
                            geometry: geometry,
                            onClick: onFavoriteClick
                        )
                        .padding(.top, FigmaDimens.fh(5, geometry: geometry))
                        .padding(.trailing, FigmaDimens.fw(5, geometry: geometry))
                    }
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(5, geometry: geometry))
                    
                    // Информация о товаре
                    VStack(spacing: 0) {
                        // Рейтинг и отзывы
                        HStack(spacing: 0) {
                            // Иконка отзывов
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .frame(width: FigmaDimens.fw(10, geometry: geometry))
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(5, geometry: geometry))
                            
                            // Количество отзывов
                            Text("\(product.reviewsCount) отзыва")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .frame(width: FigmaDimens.fw(75, geometry: geometry), alignment: .leading)
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(25, geometry: geometry))
                            
                            // Рейтинг
                            Text(String(format: "%.1f", product.rating))
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: FigmaDimens.fw(50, geometry: geometry), alignment: .trailing)
                            
                            Spacer()
                                .frame(width: FigmaDimens.fw(5, geometry: geometry))
                            
                            // Звезда
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                                .frame(width: FigmaDimens.fw(10, geometry: geometry))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, FigmaDimens.fw(15, geometry: geometry))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10, geometry: geometry))
                        
                        // Название
                        Text(product.name)
                            .font(.system(size: 14, weight: .semibold))
                            .lineLimit(2)
                            .frame(
                                width: FigmaDimens.fw(180, geometry: geometry),
                                height: FigmaDimens.fh(40, geometry: geometry),
                                alignment: .topLeading
                            )
                            .padding(.horizontal, FigmaDimens.fw(15, geometry: geometry))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(5, geometry: geometry))
                        
                        // Цены
                        HStack(spacing: FigmaDimens.fw(5, geometry: geometry)) {
                            if oldPrice > 0 {
                                Text("\(oldPrice) ₽")
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .strikethrough()
                                    .frame(height: FigmaDimens.fh(10, geometry: geometry), alignment: .bottom)
                            }
                            
                            Spacer()
                            
                            Text("\(product.price) ₽")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(accentColor)
                                .frame(height: FigmaDimens.fh(20, geometry: geometry), alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, FigmaDimens.fw(15, geometry: geometry))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(5, geometry: geometry))
                        
                        // Скидка
                        ZStack(alignment: .bottomLeading) {
                            if discount > 0 {
                                Text("-\(discount)%")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.discountRed)
                                    .frame(
                                        width: FigmaDimens.fw(60, geometry: geometry),
                                        height: FigmaDimens.fh(35, geometry: geometry)
                                    )
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            height: FigmaDimens.fh(35, geometry: geometry),
                            alignment: .bottomLeading
                        )
                        .padding(.horizontal, FigmaDimens.fw(15, geometry: geometry))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10, geometry: geometry))
                    }
                }
            }
            .frame(width: cardWidth, height: cardHeight)
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
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = false
                    }
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
    let geometry: GeometryProxy
    let onClick: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onClick) {
            ZStack {
                Circle()
                    .fill(Color(hex: "F2F2F2")?.opacity(0.7) ?? Color.white.opacity(0.8))
                    .frame(
                        width: FigmaDimens.fw(30, geometry: geometry),
                        height: FigmaDimens.fh(30, geometry: geometry)
                    )
                
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .scaleEffect(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
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
