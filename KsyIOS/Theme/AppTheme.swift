//
//  AppTheme.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

/// Тема приложения
struct AppTheme {
    // Основные цвета
    static let brandPurple = Color(hex: "7B61FF") ?? .purple
    static let discountRed = Color(hex: "E94242") ?? .red
    static let backgroundLight = Color(hex: "F2F2F2") ?? Color(white: 0.95)
    static let purpleGradientStart = Color(hex: "6A85B6") ?? .blue
    static let purpleGradientEnd = Color(hex: "BAC8E0") ?? .blue
    
    // Цвет статус-бара
    static let statusBarColor = Color(hex: "5D76CB") ?? .blue
}

/// Навигационные элементы нижней панели
enum BottomNavItem: String, CaseIterable {
    case home = "Главная"
    case shopCart = "Корзина"
    case favorites = "Избранное"
    case profile = "Профиль"
    
    var icon: String {
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

