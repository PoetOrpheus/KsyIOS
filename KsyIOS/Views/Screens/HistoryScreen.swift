//
//  HistoryScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct HistoryScreen: View {
    let onBackClick: () -> Void
    let onProductClick: (Product) -> Void
    
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.bgGray
                .ignoresSafeArea()
            
            TopHeaderWithReturn(onBackClick: onBackClick)
                .zIndex(1)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Заголовок "История просмотров"
                    HStack {
                        Text("История просмотров")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.black)
                            .lineSpacing(2)
                        
                        Spacer()
                    }
                    .frame(height: FigmaDimens.fh(50))
                    .padding(.horizontal, FigmaDimens.fw(25))
                    
                    // Сетка продуктов
                    if case .success(let products) = productViewModel.productsState {
                        // Берем первые 4 продукта как в Kotlin
                        let historyProducts = Array(products.prefix(4))
                        ProductGrid(
                            products: historyProducts,
                            onProductClick: onProductClick,
                            onToggleFavorite: { productId in
                                Task {
                                    await productViewModel.toggleFavorite(productId)
                                }
                            }
                        )
                    } else if case .loading = productViewModel.productsState {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .padding(.top, FigmaDimens.fh(40))
                    } else {
                        // Если продукты не загружены, показываем тестовые данные
                        let testProducts = Array(TestProducts.allProducts.prefix(4))
                        ProductGrid(
                            products: testProducts,
                            onProductClick: onProductClick,
                            onToggleFavorite: { productId in
                                Task {
                                    await productViewModel.toggleFavorite(productId)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.top, FigmaDimens.fh(60))
            .padding(.horizontal, FigmaDimens.fw(5))
        }
        .task {
            // Загружаем продукты при первом показе экрана, если они еще не загружены
            if case .idle = productViewModel.productsState {
                productViewModel.loadProducts()
            }
        }
    }
}

