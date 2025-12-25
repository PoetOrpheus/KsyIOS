//
//  FavoritesScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var productViewModel: ProductViewModel
    let onProductClick: (Product) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            HStack {
                Text("Избранное")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Содержимое
            ScrollView {
                VStack(spacing: 20) {
                    if case .success(let products) = productViewModel.favoriteProductsState {
                        if products.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "heart")
                                    .font(.system(size: 64))
                                    .foregroundColor(.gray)
                                Text("Нет избранных товаров")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                        } else {
                            ProductGrid(
                                products: products,
                                onProductClick: onProductClick,
                                onToggleFavorite: { productId in
                                    Task {
                                        await productViewModel.toggleFavorite(productId)
                                    }
                                }
                            )
                        }
                    } else if case .loading = productViewModel.favoriteProductsState {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, 100)
                    } else if case .error(let message, _) = productViewModel.favoriteProductsState {
                        Text("Ошибка: \(message ?? "Неизвестная ошибка")")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Idle - загружаем данные
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, 100)
                            .task {
                                productViewModel.loadFavoriteProducts()
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

