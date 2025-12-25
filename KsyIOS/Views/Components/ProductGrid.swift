//
//  ProductGrid.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct ProductGrid: View {
    let products: [Product]
    let onProductClick: (Product) -> Void
    let onToggleFavorite: (String) -> Void
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 10) {
            ForEach(products) { product in
                ProductCard(
                    product: product,
                    onClick: { onProductClick(product) },
                    onFavoriteClick: { onToggleFavorite(product.id) }
                )
            }
        }
        .padding(.horizontal, 10)
    }
}

struct ProductCard: View {
    let product: Product
    let onClick: () -> Void
    let onFavoriteClick: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: 0) {
                // Изображение продукта
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 200)
                    
                    // Заглушка для изображения (в реальном приложении здесь будет AsyncImage)
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .foregroundColor(.gray)
                    
                    // Кнопка избранного
                    Button(action: onFavoriteClick) {
                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(product.isFavorite ? .red : .gray)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
                
                // Информация о продукте
                VStack(alignment: .leading, spacing: 4) {
                    // Рейтинг и отзывы
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                        
                        Text("\(product.reviewsCount) отзыва")
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(String(format: "%.1f", product.rating))
                            .font(.system(size: 10, weight: .bold))
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                    }
                    
                    // Название
                    Text(product.name)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2)
                        .frame(height: 40, alignment: .topLeading)
                    
                    // Цены
                    HStack {
                        if let oldPrice = product.oldPrice, oldPrice > product.price {
                            Text("\(oldPrice) ₽")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                                .strikethrough()
                        }
                        
                        Spacer()
                        
                        Text("\(product.price) ₽")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(product.accentColor)
                    }
                    
                    // Скидка
                    if let discount = product.calculateDiscountPercent(), discount > 0 {
                        HStack {
                            Text("-\(discount)%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.discountRed)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            product.accentColor.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: isPressed ? Color.black.opacity(0.1) : Color.black.opacity(0.2), radius: isPressed ? 2 : 8, x: 0, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

