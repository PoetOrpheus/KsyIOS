//
//  FavoritesScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var productViewModel: ProductViewModel
    let onProductClick: (Product) -> Void
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                TopHeaderWithoutSearch()
                
                Spacer().frame(height: FigmaDimens.fh(10))
                
                // Строка настроек
                SettingsFavoriteRow()
                
                Spacer().frame(height: FigmaDimens.fh(10))
                
                // Контент
                ScrollView {
                    VStack(spacing: 0) {
                        if case .success(let products) = productViewModel.favoriteProductsState {
                            if products.isEmpty {
                                // Пустое состояние
                                VStack(spacing: FigmaDimens.fh(10)) {
                                    Text("Нет избранных товаров")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    Text("Добавьте товары в избранное")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 100)
                            } else {
                                // Отображаем избранные продукты
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
                            Text("Ошибка загрузки: \(message ?? "Неизвестная ошибка")")
                                .font(.system(size: 18))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .padding(.top, 100)
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
                }
            }
        }
        .task {
            if case .idle = productViewModel.favoriteProductsState {
                productViewModel.loadFavoriteProducts()
            }
        }
    }
}
