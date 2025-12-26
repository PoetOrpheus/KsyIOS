//
//  AppTheme.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

/// Тема приложения
struct AppTheme {
    // Основные цвета из макета
    static let brandPurple = Color(hex: "7B61FF") ?? .purple
    static let discountRed = Color(hex: "E94242") ?? .red
    static let backgroundLight = Color(hex: "F2F2F2") ?? Color(white: 0.95)
    static let bgGray = Color(hex: "F2F2F2") ?? Color(white: 0.95) // То же что и backgroundLight
    static let purpleGradientStart = Color(hex: "6A85B6") ?? .blue
    static let purpleGradientEnd = Color(hex: "BAC8E0") ?? .blue
    
    // Цвета для градиента хедера
    static let headerGradientStart = Color(hex: "5D76CB") ?? .blue
    static let headerGradientEnd = Color(hex: "FCB4D5") ?? .pink
    
    // Цвет статус-бара (совпадает с началом градиента хедера)
    static let statusBarColor = Color(hex: "5D76CB") ?? .blue
    static let blueButton = Color(hex: "5D76CB") ?? .blue
    
    // Дополнительные цвета
    static let textGray = Color(hex: "999999") ?? .gray
    static let purpleHeader = Color(hex: "9C89F6") ?? .purple
    static let mainRed = Color(hex: "D32F2F") ?? .red
    
    // Цвета для категорий (градиенты)
    static let categoryGradient1Start = Color(hex: "5D76CB") ?? .blue
    static let categoryGradient1End = Color(hex: "D23E41") ?? .red // Стать продавцом
    static let categoryGradient2End = Color(hex: "CC5086") ?? .pink // Магазины и бренды
    static let categoryGradient3End = Color(hex: "DAA636") ?? .orange // Финансы
    static let categoryGradient4End = Color(hex: "21936F") ?? .green // История просмотров
    static let categoryGradient5End = Color(hex: "1D36D7") ?? .blue // Каталог
    
    // Цвета для баннера 11.11
    static let bannerGradientStart = Color(hex: "A8C0FF") ?? .blue
    static let bannerGradientEnd = Color(hex: "3F2B96") ?? .purple
}

/// Навигационные элементы нижней панели
enum BottomNavItem: String, CaseIterable {
    case home = "Главная"
    case shopCart = "Корзина"
    case favorites = "Избранное"
    case profile = "Профиль"
    
    var icon: String {
        // Используем оригинальные иконки из Assets (fallback на системные)
        switch self {
        case .home:
            return "home_menu_icon"
        case .shopCart:
            return "shop_menu_icon"
        case .favorites:
            return "lover_menu_icon"
        case .profile:
            return "profile_menu_icon"
        }
    }
    
    var fallbackIcon: String {
        // Системные иконки как fallback
        switch self {
        case .home:
            return "house.fill"
        case .shopCart:
            return "cart.fill"
        case .favorites:
            return "heart.fill"
        case .profile:
            return "person.fill"
        }
    }
}

