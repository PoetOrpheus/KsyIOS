//
//  LocalDataStore.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation

/// Класс для работы с локальным хранилищем данных
class LocalDataStore {
    static let shared = LocalDataStore()
    
    private let userDefaults = UserDefaults.standard
    
    // Ключи для хранения данных
    private let favoriteProductIdsKey = "favorite_product_ids"
    private let cachedProductsKey = "cached_products_json"
    private let productsCacheTimestampKey = "products_cache_timestamp"
    private let userProfileKey = "user_profile_json"
    private let cartItemsKey = "cart_items_json"
    private let isLoggedInKey = "is_logged_in"
    
    private init() {}
    
    // MARK: - Избранные продукты
    
    /// Получить список ID избранных продуктов
    func getFavoriteProductIds() -> Set<String> {
        if let array = userDefaults.array(forKey: favoriteProductIdsKey) as? [String] {
            return Set(array)
        }
        return []
    }
    
    /// Сохранить список ID избранных продуктов
    func saveFavoriteProductIds(_ productIds: Set<String>) {
        userDefaults.set(Array(productIds), forKey: favoriteProductIdsKey)
    }
    
    /// Добавить продукт в избранное
    func addToFavorites(productId: String) {
        var currentFavorites = getFavoriteProductIds()
        currentFavorites.insert(productId)
        saveFavoriteProductIds(currentFavorites)
    }
    
    /// Удалить продукт из избранного
    func removeFromFavorites(productId: String) {
        var currentFavorites = getFavoriteProductIds()
        currentFavorites.remove(productId)
        saveFavoriteProductIds(currentFavorites)
    }
    
    /// Проверить, находится ли продукт в избранном
    func isFavorite(productId: String) -> Bool {
        return getFavoriteProductIds().contains(productId)
    }
    
    // MARK: - Кэш продуктов
    
    /// Сохранить кэш продуктов
    func cacheProducts(_ products: [Product]) {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: cachedProductsKey)
            userDefaults.set(Date().timeIntervalSince1970, forKey: productsCacheTimestampKey)
        }
    }
    
    /// Получить кэш продуктов
    func getCachedProducts() -> [Product]? {
        guard let data = userDefaults.data(forKey: cachedProductsKey) else {
            return nil
        }
        return try? JSONDecoder().decode([Product].self, from: data)
    }
    
    /// Получить время последнего обновления кэша
    func getCacheTimestamp() -> TimeInterval? {
        let timestamp = userDefaults.double(forKey: productsCacheTimestampKey)
        return timestamp > 0 ? timestamp : nil
    }
    
    /// Очистить кэш продуктов
    func clearProductsCache() {
        userDefaults.removeObject(forKey: cachedProductsKey)
        userDefaults.removeObject(forKey: productsCacheTimestampKey)
    }
    
    /// Проверить, нужно ли обновлять кэш (например, если прошло более 1 часа)
    func shouldRefreshCache(maxCacheAgeMs: TimeInterval = 3600000) -> Bool {
        guard let timestamp = getCacheTimestamp() else {
            return true
        }
        let now = Date().timeIntervalSince1970
        return (now - timestamp) > (maxCacheAgeMs / 1000.0)
    }
    
    // MARK: - Профиль пользователя
    
    /// Сохранить профиль пользователя
    func saveUserProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            userDefaults.set(encoded, forKey: userProfileKey)
        }
    }
    
    /// Получить профиль пользователя
    func getUserProfile() -> UserProfile? {
        guard let data = userDefaults.data(forKey: userProfileKey) else {
            return nil
        }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    /// Получить профиль пользователя или профиль по умолчанию
    func getUserProfileOrDefault() -> UserProfile {
        return getUserProfile() ?? UserProfile.default()
    }
    
    // MARK: - Корзина
    
    /// Сохранить корзину
    func saveCartItems(_ cartItems: [CartItem]) {
        // Конвертируем CartItem в упрощенную структуру для сохранения
        let cartItemsData = cartItems.map { item in
            CartItemData(
                id: item.id,
                productId: item.product.id,
                selectedVariantId: item.selectedVariantId,
                selectedSizeId: item.selectedSizeId,
                quantity: item.quantity,
                isSelected: item.isSelected
            )
        }
        if let encoded = try? JSONEncoder().encode(cartItemsData) {
            userDefaults.set(encoded, forKey: cartItemsKey)
        }
    }
    
    /// Получить сохраненные данные корзины
    func getCartItemsData() -> [CartItemData] {
        guard let data = userDefaults.data(forKey: cartItemsKey) else {
            return []
        }
        return (try? JSONDecoder().decode([CartItemData].self, from: data)) ?? []
    }
    
    /// Очистить корзину
    func clearCartItems() {
        userDefaults.removeObject(forKey: cartItemsKey)
    }
    
    // MARK: - Авторизация
    
    /// Проверить, авторизован ли пользователь
    func isLoggedIn() -> Bool {
        return userDefaults.bool(forKey: isLoggedInKey)
    }
    
    /// Сохранить состояние авторизации
    func setLoggedIn(_ isLoggedIn: Bool) {
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
    }
    
    /// Выйти из аккаунта
    func logout() {
        setLoggedIn(false)
    }
}

/// DTO для сохранения данных корзины
struct CartItemData: Codable {
    let id: String
    let productId: String
    let selectedVariantId: String?
    let selectedSizeId: String?
    let quantity: Int
    let isSelected: Bool
}

