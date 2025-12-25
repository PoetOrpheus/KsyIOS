//
//  UiState.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation

/// Базовый enum для состояний UI
enum UiState<T> {
    /// Начальное состояние (загрузка еще не началась)
    case idle
    
    /// Состояние загрузки
    case loading
    
    /// Состояние успеха с данными
    case success(T)
    
    /// Состояние ошибки
    case error(message: String?, error: Error?)
}

