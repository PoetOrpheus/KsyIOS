//
//  CartScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct CartScreen: View {
    @ObservedObject var cartViewModel: CartViewModel
    let onProductClick: (Product) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            HStack {
                Text("Корзина")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Содержимое корзины
            ScrollView {
                VStack(spacing: 12) {
                    if case .success(let items) = cartViewModel.cartState {
                        if items.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "cart")
                                    .font(.system(size: 64))
                                    .foregroundColor(.gray)
                                Text("Корзина пуста")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                        } else {
                            ForEach(items) { item in
                                CartItemCard(
                                    item: item,
                                    onQuantityChange: { newQuantity in
                                        cartViewModel.updateCartItemQuantity(item.id, quantity: newQuantity)
                                    },
                                    onToggleSelection: {
                                        cartViewModel.toggleCartItemSelection(item.id)
                                    },
                                    onRemove: {
                                        cartViewModel.removeFromCart(item.id)
                                    },
                                    onProductClick: {
                                        onProductClick(item.product)
                                    }
                                )
                            }
                            
                            // Итого
                            VStack(spacing: 12) {
                                Divider()
                                
                                HStack {
                                    Text("Итого:")
                                        .font(.system(size: 18, weight: .semibold))
                                    Spacer()
                                    Text("\(cartViewModel.cartTotal) ₽")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppTheme.brandPurple)
                                }
                                .padding(.horizontal, 16)
                                
                                Button(action: {
                                    // Оформить заказ
                                }) {
                                    Text("Оформить заказ")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(AppTheme.brandPurple)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                            }
                            .padding(.top, 16)
                        }
                    } else if case .loading = cartViewModel.cartState {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, 100)
                    } else if case .error(let message, _) = cartViewModel.cartState {
                        Text("Ошибка: \(message ?? "Неизвестная ошибка")")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .task {
            cartViewModel.loadCart()
        }
    }
}

struct CartItemCard: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onToggleSelection: () -> Void
    let onRemove: () -> Void
    let onProductClick: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Чекбокс выбора
            Button(action: onToggleSelection) {
                Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isSelected ? AppTheme.brandPurple : .gray)
                    .font(.system(size: 24))
            }
            
            // Изображение
            Button(action: onProductClick) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Информация
            VStack(alignment: .leading, spacing: 4) {
                Button(action: onProductClick) {
                    Text(item.product.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                if let variantName = item.getSelectedVariantName() {
                    Text(variantName)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                if let sizeName = item.getSelectedSizeName() {
                    Text("Размер: \(sizeName)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("\(item.product.price) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.brandPurple)
                    
                    Spacer()
                    
                    // Счетчик количества
                    HStack(spacing: 8) {
                        Button(action: {
                            if item.quantity > 1 {
                                onQuantityChange(item.quantity - 1)
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(item.quantity)")
                            .font(.system(size: 16, weight: .medium))
                            .frame(minWidth: 30)
                        
                        Button(action: {
                            onQuantityChange(item.quantity + 1)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(AppTheme.brandPurple)
                        }
                    }
                }
            }
            
            // Кнопка удаления
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 18))
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

