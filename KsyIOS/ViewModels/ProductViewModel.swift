//
//  ProductViewModel.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation
import SwiftUI

/// ViewModel для работы с продуктами
@MainActor
class ProductViewModel: ObservableObject {
    @Published var productsState: UiState<[Product]> = .idle
    @Published var productState: UiState<Product> = .idle
    @Published var favoriteProductsState: UiState<[Product]> = .idle
    @Published var searchResultsState: UiState<[Product]> = .idle
    
    private let productRepository: ProductRepository
    private var hasLoadedProducts = false
    private var isLoadingProducts = false
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    /// Загрузить все продукты (только один раз)
    func loadProducts(forceReload: Bool = false) {
        // Если данные уже загружены или идет загрузка, и не требуется принудительная перезагрузка - выходим
        if (hasLoadedProducts || isLoadingProducts) && !forceReload {
            return
        }
        
        Task {
            isLoadingProducts = true
            
            // При принудительной перезагрузке всегда показываем Loading
            // При первой загрузке тоже показываем (но кэш загрузится быстро)
            if forceReload || !hasLoadedProducts {
                productsState = .loading
            }
            
            do {
                let products = try await productRepository.getAllProducts()
                productsState = .success(products)
                hasLoadedProducts = true
            } catch {
                productsState = .error(message: error.localizedDescription, error: error)
            }
            
            isLoadingProducts = false
        }
    }
    
    /// Загрузить продукт по ID
    func loadProductById(_ id: String) {
        Task {
            productState = .loading
            do {
                if let product = try await productRepository.getProductById(id) {
                    productState = .success(product)
                } else {
                    productState = .error(message: "Продукт не найден", error: nil)
                }
            } catch {
                productState = .error(message: error.localizedDescription, error: error)
            }
        }
    }
    
    /// Загрузить избранные продукты
    func loadFavoriteProducts() {
        Task {
            favoriteProductsState = .loading
            do {
                let products = try await productRepository.getFavoriteProducts()
                favoriteProductsState = .success(products)
            } catch {
                favoriteProductsState = .error(message: error.localizedDescription, error: error)
            }
        }
    }
    
    /// Удалить продукт из избранного
    func removeFromFavorites(_ productId: String) {
        Task {
            do {
                let success = try await productRepository.removeFromFavorites(productId)
                if success {
                    // Оптимизированное обновление - обновляем только состояние избранных без полной перезагрузки
                    await refreshFavoriteProductsState(productId: productId, shouldAdd: false)
                    // Обновляем список продуктов, чтобы отразить изменение избранного
                    updateProductFavoriteState(productId: productId, isFavorite: false)
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Добавить продукт в избранное
    func addToFavorites(_ productId: String) {
        Task {
            do {
                let success = try await productRepository.addToFavorites(productId)
                if success {
                    // Оптимизированное обновление
                    await refreshFavoriteProductsState(productId: productId, shouldAdd: true)
                    // Обновляем список продуктов, чтобы отразить изменение избранного
                    updateProductFavoriteState(productId: productId, isFavorite: true)
                }
            } catch {
                // Обработка ошибки
            }
        }
    }
    
    /// Оптимизированное обновление состояния избранных продуктов без полной перезагрузки
    private func refreshFavoriteProductsState(productId: String, shouldAdd: Bool) async {
        if case .success(let currentProducts) = favoriteProductsState {
            if shouldAdd {
                // Добавляем товар в избранное (нужно получить продукт из репозитория)
                if let product = try? await productRepository.getProductById(productId),
                   !currentProducts.contains(where: { $0.id == productId }) {
                    var updatedProduct = product
                    updatedProduct.isFavorite = true
                    favoriteProductsState = .success(currentProducts + [updatedProduct])
                } else {
                    // Обновляем существующий товар
                    let updatedProducts = currentProducts.map {
                        if $0.id == productId {
                            var updated = $0
                            updated.isFavorite = true
                            return updated
                        }
                        return $0
                    }
                    favoriteProductsState = .success(updatedProducts)
                }
            } else {
                // Удаляем товар из избранного
                let updatedProducts = currentProducts.filter { $0.id != productId }
                favoriteProductsState = .success(updatedProducts)
            }
        }
    }
    
    /// Переключить состояние избранного для продукта
    func toggleFavorite(_ productId: String) async -> Bool {
        do {
            // Получаем текущее состояние избранного из репозитория
            let product = try await productRepository.getProductById(productId)
            let isCurrentlyFavorite = product?.isFavorite ?? false
            
            let success: Bool
            if isCurrentlyFavorite {
                success = try await productRepository.removeFromFavorites(productId)
            } else {
                success = try await productRepository.addToFavorites(productId)
            }
            
            if success {
                // Обновляем состояние в основном списке, если он загружен
                updateProductFavoriteState(productId: productId, isFavorite: !isCurrentlyFavorite)
                
                // Обновляем состояние избранных продуктов
                await refreshFavoriteProductsState(productId: productId, shouldAdd: !isCurrentlyFavorite)
            }
            
            return success
        } catch {
            return false
        }
    }
    
    /// Поиск продуктов по запросу
    func searchProducts(_ query: String) {
        if query.isEmpty {
            searchResultsState = .success([])
            return
        }
        
        Task {
            searchResultsState = .loading
            do {
                let results = try await productRepository.searchProducts(query)
                searchResultsState = .success(results)
            } catch {
                searchResultsState = .error(message: error.localizedDescription, error: error)
            }
        }
    }
    
    /// Очистить результаты поиска
    func clearSearchResults() {
        searchResultsState = .idle
    }
    
    /// Обновить состояние избранного для продукта в списке
    private func updateProductFavoriteState(productId: String, isFavorite: Bool) {
        if case .success(let products) = productsState {
            let updatedProducts = products.map { product in
                if product.id == productId {
                    var updated = product
                    updated.isFavorite = isFavorite
                    return updated
                }
                return product
            }
            productsState = .success(updatedProducts)
        }
    }
}

