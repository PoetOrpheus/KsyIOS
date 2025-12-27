//
//  SearchScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct SearchScreen: View {
    @Binding var searchQuery: String
    let onBackClick: () -> Void
    let onProductClick: (Product) -> Void
    
    @ObservedObject var productViewModel: ProductViewModel
    
    @State private var searchTask: Task<Void, Never>?
    
    init(
        searchQuery: Binding<String>,
        onBackClick: @escaping () -> Void,
        onProductClick: @escaping (Product) -> Void,
        productViewModel: ProductViewModel
    ) {
        self._searchQuery = searchQuery
        self.onBackClick = onBackClick
        self.onProductClick = onProductClick
        self.productViewModel = productViewModel
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopHeaderWithSearchAndReturn(
                    searchQuery: $searchQuery,
                    onBackClick: onBackClick
                )
                
                // Результаты поиска
                switch productViewModel.searchResultsState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    
                case .success(let products):
                    if searchQuery.isEmpty || searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                        // Пустой запрос
                        VStack {
                            Spacer()
                            Text("Введите поисковый запрос")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if products.isEmpty {
                        // Нет результатов
                        VStack {
                            Spacer()
                            Text("Ничего не найдено")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Результаты поиска
                        ScrollView {
                            ProductGrid(
                                products: products,
                                onProductClick: onProductClick,
                                onToggleFavorite: { productId in
                                    Task {
                                        await productViewModel.toggleFavorite(productId)
                                    }
                                }
                            )
                            .padding(.horizontal, FigmaDimens.fw(5))
                        }
                    }
                    
                case .error(let message, _):
                    VStack {
                        Spacer()
                        Text("Ошибка поиска: \(message ?? "Неизвестная ошибка")")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .idle:
                    VStack {
                        Spacer()
                        Text("Введите поисковый запрос")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onChange(of: searchQuery) { newQuery in
            // Отменяем предыдущую задачу поиска
            searchTask?.cancel()
            
            // Создаем новую задачу с задержкой (debounce)
            searchTask = Task {
                // Задержка 300ms как в Kotlin
                try? await Task.sleep(nanoseconds: 300_000_000)
                
                // Проверяем, не была ли задача отменена
                guard !Task.isCancelled else { return }
                
                // Выполняем поиск
                let trimmedQuery = newQuery.trimmingCharacters(in: .whitespaces)
                if !trimmedQuery.isEmpty {
                    productViewModel.searchProducts(trimmedQuery)
                } else {
                    productViewModel.clearSearchResults()
                }
            }
        }
        .onAppear {
            // Если при открытии экрана уже есть запрос, выполняем поиск
            let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespaces)
            if !trimmedQuery.isEmpty {
                productViewModel.searchProducts(trimmedQuery)
            }
        }
        .onDisappear {
            // Отменяем задачу при закрытии экрана
            searchTask?.cancel()
        }
    }
}

