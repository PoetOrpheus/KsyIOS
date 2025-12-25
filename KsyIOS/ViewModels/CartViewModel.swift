//
//  CartViewModel.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation
import SwiftUI

/// ViewModel для работы с корзиной
@MainActor
class CartViewModel: ObservableObject {
    @Published var cartState: UiState<[CartItem]> = .idle
    @Published var cartTotal: Int = 0
    
    private let productRepository: ProductRepository
    private var hasLoadedCart = false
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    /// Загрузить корзину
    func loadCart() {
        Task {
            cartState = UiState<[CartItem]>.loading
            do {
                let cartItems = try await productRepository.getCartItems()
                cartState = UiState<[CartItem]>.success(cartItems)
                await updateCartTotal(cartItems)
                hasLoadedCart = true
            } catch {
                cartState = UiState<[CartItem]>.error(message: error.localizedDescription, error: error)
            }
        }
    }
    
    /// Добавить товар в корзину
    func addToCart(
        product: Product,
        selectedVariantId: String? = nil,
        selectedSizeId: String? = nil,
        quantity: Int = 1
    ) {
        Task {
            do {
                let success = try await productRepository.addToCart(
                    product: product,
                    selectedVariantId: selectedVariantId,
                    selectedSizeId: selectedSizeId,
                    quantity: quantity
                )
                if success {
                    // Оптимизированное обновление - получаем только новые данные
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Оптимизированное обновление состояния корзины без полной перезагрузки
    func refreshCartState() {
        Task {
            do {
                let cartItems = try await productRepository.getCartItems()
                cartState = UiState<[CartItem]>.success(cartItems)
                await updateCartTotal(cartItems)
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Обновить количество товара в корзине
    func updateCartItemQuantity(_ cartItemId: String, quantity: Int) {
        Task {
            do {
                let success = try await productRepository.updateCartItemQuantity(cartItemId, quantity: quantity)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Переключить выбранное состояние товара в корзине
    func toggleCartItemSelection(_ cartItemId: String) {
        Task {
            do {
                let success = try await productRepository.toggleCartItemSelection(cartItemId)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Oбработка ошибки
            }
        }
    }
    
    /// Удалить товар из корзины
    func removeFromCart(_ cartItemId: String) {
        Task {
            do {
                let success = try await productRepository.removeFromCart(cartItemId)
                if success {
                    // Оптимизированное обновление
                    await refreshCartState()
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Очистить корзину
    func clearCart() {
        Task {
            do {
                let success = try await productRepository.clearCart()
                if success {
                    cartState = UiState<[CartItem]>.success([])
                    cartTotal = 0
                    hasLoadedCart = false
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Обновить общую стоимость корзины
    private func updateCartTotal(_ cartItems: [CartItem]) async {
        do {
            let total = try await productRepository.getCartTotal()
            cartTotal = total
        } catch {
            // Обработка ошибки
        }
    }
    
    /// Получить количество товаров в корзине
    func getCartItemsCount() -> Int {
        if case .success(let items) = cartState {
            return items.reduce(0) { $0 + $1.quantity }
        }
        return 0
    }
}

