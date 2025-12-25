//
//  UiState.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import Foundation

/// Базовый enum для состояний UI
enum UiState<T>: Equatable where T: Equatable {
    /// Начальное состояние (загрузка еще не началась)
    case idle
    
    /// Состояние загрузки
    case loading
    
    /// Состояние успеха с данными
    case success(T)
    
    /// Состояние ошибки
    case error(message: String?, error: Error?)
    
    static func == (lhs: UiState<T>, rhs: UiState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.error(let lhsMessage, _), .error(let rhsMessage, _)):
            // Сравниваем только сообщения, так как Error не Equatable
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

