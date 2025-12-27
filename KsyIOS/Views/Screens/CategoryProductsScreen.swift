//
//  CategoryProductsScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct CategoryProductsScreen: View {
    let categoryName: String
    let subcategoryName: String
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
                    
                    // Заголовок с категорией и подкатегорией
                    if !categoryName.isEmpty || !subcategoryName.isEmpty {
                        let titleText: String = {
                            if !categoryName.isEmpty && !subcategoryName.isEmpty {
                                return "\(categoryName) - \(subcategoryName)"
                            } else if !categoryName.isEmpty {
                                return categoryName
                            } else if !subcategoryName.isEmpty {
                                return subcategoryName
                            } else {
                                return ""
                            }
                        }()
                        
                        if !titleText.isEmpty {
                            Text(titleText)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, FigmaDimens.fw(20))
                                .padding(.vertical, FigmaDimens.fh(10))
                            
                            Spacer()
                                .frame(height: FigmaDimens.fh(5))
                        }
                    }
                    
                    // Сетка продуктов
                    switch productViewModel.productsState {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, FigmaDimens.fh(40))
                    case .success(let products):
                        // Пока что показываем все товары, так как в модели Product нет поля категории
                        // В будущем здесь можно добавить фильтрацию по категории
                        ProductGrid(
                            products: products,
                            onProductClick: onProductClick,
                            onToggleFavorite: { productId in
                                Task {
                                    await productViewModel.toggleFavorite(productId)
                                }
                            }
                        )
                    case .error(let message, _):
                        Text("Ошибка: \(message ?? "Неизвестная ошибка")")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, FigmaDimens.fh(40))
                    case .idle:
                        EmptyView()
                    }
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(20))
                }
            }
            .padding(.top, FigmaDimens.fh(60))
        }
        .task {
            // Загружаем продукты при первом показе экрана
            if case .idle = productViewModel.productsState {
                productViewModel.loadProducts()
            }
        }
    }
}

