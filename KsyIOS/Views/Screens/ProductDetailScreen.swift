//
//  ProductDetailScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct ProductDetailScreen: View {
    let product: Product
    @ObservedObject var productViewModel: ProductViewModel
    @ObservedObject var cartViewModel: CartViewModel
    
    let onBackClick: () -> Void
    
    @State private var selectedVariantId: String?
    @State private var selectedSizeId: String?
    @State private var quantity: Int = 1
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок с кнопкой назад
                HStack {
                    Button(action: onBackClick) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await productViewModel.toggleFavorite(product.id)
                        }
                    }) {
                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundColor(product.isFavorite ? .red : .gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Изображение продукта
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                        
                        // Информация о продукте
                        VStack(alignment: .leading, spacing: 12) {
                            // Название
                            Text(product.name)
                                .font(.system(size: 24, weight: .bold))
                            
                            // Рейтинг
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 14))
                                
                                Text(String(format: "%.1f", product.rating))
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("(\(product.reviewsCount) отзывов)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            // Цены
                            HStack {
                                if let oldPrice = product.oldPrice, oldPrice > product.price {
                                    Text("\(oldPrice) ₽")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .strikethrough()
                                }
                                
                                Text("\(product.price) ₽")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(product.accentColor)
                                
                                if let discount = product.calculateDiscountPercent(), discount > 0 {
                                    Text("-\(discount)%")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(AppTheme.discountRed)
                                        .cornerRadius(8)
                                }
                            }
                            
                            // Бренд
                            if let brand = product.brand {
                                Text("Бренд: \(brand.name)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            // Продавец
                            if let seller = product.seller {
                                HStack {
                                    Text("Продавец: \(seller.name)")
                                        .font(.system(size: 14))
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 12))
                                        
                                        Text(String(format: "%.1f", seller.rating))
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Описание
                            if let description = product.description {
                                Text("Описание")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text(description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            // Варианты
                            if !product.variants.isEmpty {
                                Text("Варианты")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(product.variants) { variant in
                                            Button(action: {
                                                selectedVariantId = variant.id
                                            }) {
                                                Text(variant.value)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(selectedVariantId == variant.id ? .white : .primary)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(selectedVariantId == variant.id ? AppTheme.brandPurple : Color.gray.opacity(0.2))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Размеры
                            if !product.sizes.isEmpty {
                                Text("Размеры")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(product.sizes) { size in
                                            Button(action: {
                                                if size.isAvailable {
                                                    selectedSizeId = size.id
                                                }
                                            }) {
                                                Text(size.value)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(selectedSizeId == size.id ? .white : (size.isAvailable ? .primary : .gray))
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(selectedSizeId == size.id ? AppTheme.brandPurple : (size.isAvailable ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
                                                    .cornerRadius(8)
                                            }
                                            .disabled(!size.isAvailable)
                                        }
                                    }
                                }
                            }
                            
                            // Характеристики
                            if !product.specifications.isEmpty {
                                Text("Характеристики")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(product.specifications, id: \.name) { spec in
                                        HStack {
                                            Text(spec.name)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Text(spec.value)
                                                .font(.system(size: 14, weight: .medium))
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                // Кнопка добавления в корзину
                HStack(spacing: 12) {
                    // Счетчик количества
                    HStack(spacing: 12) {
                        Button(action: {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 24))
                                .foregroundColor(quantity > 1 ? AppTheme.brandPurple : .gray)
                        }
                        .disabled(quantity <= 1)
                        
                        Text("\(quantity)")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(minWidth: 30)
                        
                        Button(action: {
                            quantity += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.brandPurple)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Button(action: {
                        cartViewModel.addToCart(
                            product: product,
                            selectedVariantId: selectedVariantId,
                            selectedSizeId: selectedSizeId,
                            quantity: quantity
                        )
                    }) {
                        Text("В корзину")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppTheme.brandPurple)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
            }
        }
    }
}

