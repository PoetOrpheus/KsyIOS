//
//  ProductRepositoryImpl.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation

/// Реализация репозитория продуктов
/// 
/// ====================================================================
/// ВНИМАНИЕ: Используются тестовые данные из TestData.swift
/// После интеграции с реальным API замените логику на работу с API/БД
/// ====================================================================
class ProductRepositoryImpl: ProductRepository {
    private let localDataStore = LocalDataStore.shared
    private var favoriteProductIds: Set<String> = []
    private var isFavoritesInitialized = false
    
    // Хранение корзины в памяти
    private static var cartItems: [String: CartItem] = [:]
    
    // MARK: - Инициализация избранных
    
    private func initializeFavoritesFromLocalStorage() {
        if !isFavoritesInitialized {
            let savedFavorites = localDataStore.getFavoriteProductIds()
            favoriteProductIds = savedFavorites
            
            // Если сохраненных избранных нет, инициализируем из тестовых данных
            if favoriteProductIds.isEmpty {
                TestProducts.allProducts.forEach { product in
                    if product.isFavorite {
                        favoriteProductIds.insert(product.id)
                    }
                }
                // Сохраняем начальные избранные
                localDataStore.saveFavoriteProductIds(favoriteProductIds)
            }
            
            isFavoritesInitialized = true
        }
    }
    
    /// Обновить продукты с учетом избранных
    private func updateProductsWithFavorites(_ products: [Product]) -> [Product] {
        return products.map { product in
            var updatedProduct = product
            updatedProduct.isFavorite = favoriteProductIds.contains(product.id)
            return updatedProduct
        }
    }
    
    // MARK: - ProductRepository Implementation
    
    func getAllProducts() async throws -> [Product] {
        // Сначала инициализируем избранные из локального хранилища
        initializeFavoritesFromLocalStorage()
        
        // Затем пытаемся загрузить из кэша
        if let cachedProducts = localDataStore.getCachedProducts(),
           !localDataStore.shouldRefreshCache() {
            // Используем кэшированные данные, обновляя их с учетом избранных
            return updateProductsWithFavorites(cachedProducts)
        }
        
        // Имитация задержки сети (загрузка с сервера) - только если кэш отсутствует или устарел
        try await Task.sleep(nanoseconds: 500_000_000) // 500ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        let products = TestProducts.allProducts
        
        let productsWithFavorites = updateProductsWithFavorites(products)
        
        // Сохраняем в кэш
        localDataStore.cacheProducts(productsWithFavorites)
        
        return productsWithFavorites
    }
    
    func getProductById(_ id: String) async throws -> Product? {
        // Инициализируем избранные, если еще не инициализированы
        initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        var product = TestProducts.allProducts.first { $0.id == id }
        if var product = product {
            product.isFavorite = favoriteProductIds.contains(id)
            return product
        }
        return nil
    }
    
    func getProductsByCategory(_ categoryId: String) async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 400_000_000) // 400ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        // В реальном приложении здесь будет фильтрация по категории
        // Пока возвращаем все продукты
        let products = TestProducts.allProducts
        return updateProductsWithFavorites(products)
    }
    
    func searchProducts(_ query: String) async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 400_000_000) // 400ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        let lowerQuery = query.lowercased()
        let filteredProducts = TestProducts.allProducts.filter { product in
            product.name.lowercased().contains(lowerQuery) ||
            product.brand?.name.lowercased().contains(lowerQuery) == true ||
            product.description?.lowercased().contains(lowerQuery) == true
        }
        return updateProductsWithFavorites(filteredProducts)
    }
    
    func getFavoriteProducts() async throws -> [Product] {
        // Инициализируем избранные, если еще не инициализированы
        initializeFavoritesFromLocalStorage()
        
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 300_000_000) // 300ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API/БД
        // ====================================================================
        return TestProducts.allProducts
            .filter { favoriteProductIds.contains($0.id) }
            .map { product in
                var updatedProduct = product
                updatedProduct.isFavorite = true
                return updatedProduct
            }
    }
    
    func addToFavorites(_ productId: String) async throws -> Bool {
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        favoriteProductIds.insert(productId)
        
        // Сохраняем в локальное хранилище
        localDataStore.saveFavoriteProductIds(favoriteProductIds)
        
        return true
    }
    
    func removeFromFavorites(_ productId: String) async throws -> Bool {
        // Имитация задержки сети
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // ====================================================================
        // ТЕСТОВЫЕ ДАННЫЕ - УДАЛИТЬ ПОСЛЕ ИНТЕГРАЦИИ С API
        // ====================================================================
        favoriteProductIds.remove(productId)
        
        // Сохраняем в локальное хранилище
        localDataStore.saveFavoriteProductIds(favoriteProductIds)
        
        return true
    }
    
    func getCartItems() async throws -> [CartItem] {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Загружаем корзину из локального хранилища при первом запросе
        if Self.cartItems.isEmpty {
            try await loadCartFromLocalStorage()
        } else {
            // ВСЕГДА обновляем состояние избранного перед возвратом корзины
            try await updateCartItemsFavoriteState()
        }
        
        return Array(Self.cartItems.values)
    }
    
    func addToCart(
        product: Product,
        selectedVariantId: String?,
        selectedSizeId: String?,
        quantity: Int
    ) async throws -> Bool {
        try await Task.sleep(nanoseconds: 200_000_000) // 200ms
        
        // Создаем уникальный ID для элемента корзины
        let cartItemId = generateCartItemId(
            productId: product.id,
            variantId: selectedVariantId,
            sizeId: selectedSizeId
        )
        
        // Проверяем, есть ли уже такой товар в корзине
        if let existingItem = Self.cartItems[cartItemId] {
            // Если товар уже есть, увеличиваем количество
            Self.cartItems[cartItemId] = CartItem(
                id: existingItem.id,
                product: existingItem.product,
                selectedVariantId: existingItem.selectedVariantId,
                selectedSizeId: existingItem.selectedSizeId,
                quantity: existingItem.quantity + quantity,
                isSelected: existingItem.isSelected
            )
        } else {
            // Добавляем новый товар в корзину (по умолчанию выбран)
            Self.cartItems[cartItemId] = CartItem(
                id: cartItemId,
                product: product,
                selectedVariantId: selectedVariantId,
                selectedSizeId: selectedSizeId,
                quantity: quantity,
                isSelected: true
            )
        }
        
        // Сохраняем в DataStore
        try await saveCartToLocalStorage()
        
        return true
    }
    
    func updateCartItemQuantity(_ cartItemId: String, quantity: Int) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        guard let item = Self.cartItems[cartItemId] else {
            return false
        }
        
        if quantity <= 0 {
            // Удаляем товар, если количество <= 0
            Self.cartItems.removeValue(forKey: cartItemId)
        } else {
            Self.cartItems[cartItemId] = CartItem(
                id: item.id,
                product: item.product,
                selectedVariantId: item.selectedVariantId,
                selectedSizeId: item.selectedSizeId,
                quantity: quantity,
                isSelected: item.isSelected
            )
        }
        
        try await saveCartToLocalStorage()
        return true
    }
    
    func toggleCartItemSelection(_ cartItemId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        guard let item = Self.cartItems[cartItemId] else {
            return false
        }
        
        Self.cartItems[cartItemId] = CartItem(
            id: item.id,
            product: item.product,
            selectedVariantId: item.selectedVariantId,
            selectedSizeId: item.selectedSizeId,
            quantity: item.quantity,
            isSelected: !item.isSelected
        )
        
        try await saveCartToLocalStorage()
        return true
    }
    
    func removeFromCart(_ cartItemId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        let removed = Self.cartItems.removeValue(forKey: cartItemId) != nil
        
        if removed {
            try await saveCartToLocalStorage()
        }
        
        return removed
    }
    
    func clearCart() async throws -> Bool {
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        Self.cartItems.removeAll()
        try await saveCartToLocalStorage()
        
        return true
    }
    
    func getCartTotal() async throws -> Int {
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        // Считаем только выбранные товары
        return Self.cartItems.values
            .filter { $0.isSelected }
            .reduce(0) { $0 + $1.getTotalPrice() }
    }
    
    // MARK: - Private Helpers
    
    /// Сохранить корзину в локальное хранилище
    private func saveCartToLocalStorage() async throws {
        localDataStore.saveCartItems(Array(Self.cartItems.values))
    }
    
    /// Загрузить корзину из локального хранилища при инициализации
    private func loadCartFromLocalStorage() async throws {
        let savedCartData = localDataStore.getCartItemsData()
        if savedCartData.isEmpty {
            return
        }
        
        // Загружаем все продукты, чтобы восстановить корзину
        let allProducts = try await getAllProducts()
        let productsMap = Dictionary(uniqueKeysWithValues: allProducts.map { ($0.id, $0) })
        
        // Восстанавливаем корзину из сохраненных данных
        for cartItemData in savedCartData {
            if let product = productsMap[cartItemData.productId] {
                Self.cartItems[cartItemData.id] = CartItem(
                    id: cartItemData.id,
                    product: product,
                    selectedVariantId: cartItemData.selectedVariantId,
                    selectedSizeId: cartItemData.selectedSizeId,
                    quantity: cartItemData.quantity,
                    isSelected: cartItemData.isSelected
                )
            }
        }
    }
    
    /// Обновить состояние избранного для продуктов в корзине
    private func updateCartItemsFavoriteState() async throws {
        // ВСЕГДА перезагружаем избранные из LocalDataStore для получения актуального состояния
        let currentFavorites = localDataStore.getFavoriteProductIds()
        favoriteProductIds = currentFavorites
        
        // Обновляем все товары в корзине с актуальным состоянием избранного
        for (id, cartItem) in Self.cartItems {
            let shouldBeFavorite = favoriteProductIds.contains(cartItem.product.id)
            if cartItem.product.isFavorite != shouldBeFavorite {
                var updatedProduct = cartItem.product
                updatedProduct.isFavorite = shouldBeFavorite
                Self.cartItems[id] = CartItem(
                    id: cartItem.id,
                    product: updatedProduct,
                    selectedVariantId: cartItem.selectedVariantId,
                    selectedSizeId: cartItem.selectedSizeId,
                    quantity: cartItem.quantity,
                    isSelected: cartItem.isSelected
                )
            }
        }
    }
    
    /// Генерирует уникальный ID для элемента корзины
    private func generateCartItemId(productId: String, variantId: String?, sizeId: String?) -> String {
        return "\(productId)_\(variantId ?? "no_variant")_\(sizeId ?? "no_size")"
    }
}

