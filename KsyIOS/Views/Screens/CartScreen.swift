//
//  CartScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct CartScreen: View {
    @ObservedObject var cartViewModel: CartViewModel
    @ObservedObject var productViewModel: ProductViewModel
    let onProductClick: (Product) -> Void
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                TopHeaderWithoutSearch()
                
                // Контент
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: FigmaDimens.fh(15))
                        
                        // Секция корзины
                        VStack(spacing: 0) {
                            if case .success(let cartItems) = cartViewModel.cartState {
                                if cartItems.isEmpty {
                                    // Пустая корзина
                                    VStack {
                                        Text("Корзина пуста")
                                            .font(.system(size: 18))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(height: FigmaDimens.fh(400))
                                    .frame(maxWidth: .infinity)
                                } else {
                                    // Товары корзины
                                    ForEach(Array(cartItems.enumerated()), id: \.element.id) { index, cartItem in
                                        if index > 0 {
                                            Rectangle()
                                                .fill(AppTheme.backgroundLight)
                                                .frame(height: FigmaDimens.fh(2))
                                                .frame(maxWidth: .infinity)
                                        }
                                        
                                        CardCart(
                                            cartItem: cartItem,
                                            onQuantityChange: { newQuantity in
                                                cartViewModel.updateCartItemQuantity(cartItem.id, quantity: newQuantity)
                                            },
                                            onRemove: {
                                                cartViewModel.removeFromCart(cartItem.id)
                                            },
                                            onToggleSelection: {
                                                cartViewModel.toggleCartItemSelection(cartItem.id)
                                            },
                                            onToggleFavorite: {
                                                Task {
                                                    await productViewModel.toggleFavorite(cartItem.product.id)
                                                    cartViewModel.refreshCartState()
                                                }
                                            }
                                        )
                                    }
                                    
                                    Spacer().frame(height: FigmaDimens.fh(20))
                                    
                                    // Кнопка "Оформить заказ"
                                    Button(action: {
                                        // Оформить заказ
                                    }) {
                                        Text("Оформить заказ")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: FigmaDimens.fw(340), height: FigmaDimens.fh(40))
                                            .background(Color(hex: "50C878") ?? .green)
                                            .cornerRadius(15)
                                    }
                                    
                                    Spacer().frame(height: FigmaDimens.fh(10))
                                    
                                    // Текст под кнопкой
                                    Text("Далее можно выбрать место доставки и способ оплаты")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .frame(width: FigmaDimens.fw(340), height: FigmaDimens.fh(40))
                                    
                                    // Итоговая сумма
                                    let selectedItems = cartItems.filter { $0.isSelected }
                                    let totalOldPrice = selectedItems.reduce(0) { total, item in
                                        total + (item.product.oldPrice ?? item.product.price) * item.quantity
                                    }
                                    let discount = totalOldPrice - selectedItems.reduce(0) { total, item in
                                        total + item.product.price * item.quantity
                                    }
                                    
                                    TotalCountCart(
                                        count: selectedItems.reduce(0) { $0 + $1.quantity },
                                        countPrice: totalOldPrice,
                                        salePrice: discount,
                                        finalPrice: cartViewModel.cartTotal
                                    )
                                    
                                    Spacer().frame(height: FigmaDimens.fh(20))
                                }
                            } else if case .loading = cartViewModel.cartState {
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .padding(.top, 100)
                            } else if case .error(let message, _) = cartViewModel.cartState {
                                Text("Ошибка загрузки корзины")
                                    .font(.system(size: 18))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .padding(.top, 100)
                            }
                        }
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, FigmaDimens.fw(10))
                        
                        // Секция истории просмотров (можно добавить позже)
                        Spacer().frame(height: FigmaDimens.fh(20))
                    }
                }
            }
        }
        .task {
            cartViewModel.loadCart()
        }
    }
}
