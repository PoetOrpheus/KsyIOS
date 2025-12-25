//
//  SplashScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct SplashScreen: View {
    let onLoadingComplete: () -> Void
    @StateObject private var viewModel = ProductViewModel(productRepository: ProductRepositoryImpl())
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            ProgressView()
                .scaleEffect(1.5)
        }
        .task {
            // Загружаем продукты при первом запуске
            if case .idle = viewModel.productsState {
                viewModel.loadProducts()
            }
        }
        .onChange(of: viewModel.productsState) { newState in
            // Когда загрузка завершена (успешно или с ошибкой), переходим на главный экран
            if case .success = newState {
                onLoadingComplete()
            } else if case .error = newState {
                // Даже при ошибке переходим на главный экран
                onLoadingComplete()
            }
        }
    }
}

