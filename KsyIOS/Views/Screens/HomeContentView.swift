//
//  HomeContentView.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct HomeContentView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @ObservedObject var cartViewModel: CartViewModel
    let onProductClick: (Product) -> Void
    let onSearchClick: () -> Void
    let onHistoryClick: () -> Void
    let onCanBeSeller: () -> Void
    let onCategoryClick: () -> Void
    let onBrandsClick: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    TopHeaderSection(onSearchClick: onSearchClick)
                        .frame(height: FigmaDimens.fh(220, geometry: geometry))
                    
                    CategoriesRow(
                        onHistoryClick: onHistoryClick,
                        onCanBeSeller: onCanBeSeller,
                        onCategoryClick: onCategoryClick,
                        onBrandsClick: onBrandsClick
                    )
                    .frame(height: FigmaDimens.fh(115, geometry: geometry))
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(10, geometry: geometry))
                    
                    // Сетка продуктов
                    if case .success(let products) = productViewModel.productsState {
                        ProductGrid(
                            products: products,
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
                    } else if case .error(let message, _) = productViewModel.productsState {
                        Text("Ошибка: \(message ?? "Неизвестная ошибка")")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Idle - загружаем данные
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .task {
                                productViewModel.loadProducts()
                            }
                    }
                }
            }
        }
    }
}

