//
//  MainScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: BottomNavItem = .home
    @State private var showProductDetail = false
    @State private var selectedProduct: Product?
    @State private var showSearch = false
    @State private var searchQuery = ""
    @State private var isLoggedIn: Bool?
    
    @StateObject private var productViewModel = ProductViewModel(productRepository: ProductRepositoryImpl())
    @StateObject private var cartViewModel = CartViewModel(productRepository: ProductRepositoryImpl())
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    
    private let localDataStore = LocalDataStore.shared
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Контент экрана
                ZStack {
                    switch selectedTab {
                    case .home:
                        HomeContentView(
                            productViewModel: productViewModel,
                            cartViewModel: cartViewModel,
                            onProductClick: { product in
                                selectedProduct = product
                                showProductDetail = true
                            },
                            onSearchClick: {
                                showSearch = true
                            },
                            onHistoryClick: {
                                // TODO: Navigate to history screen
                            },
                            onCanBeSeller: {
                                // TODO: Navigate to seller screen
                            },
                            onCategoryClick: {
                                // TODO: Navigate to catalog screen
                            },
                            onBrandsClick: {
                                // TODO: Navigate to brands screen
                            }
                        )
                    case .shopCart:
                        CartScreen(
                            cartViewModel: cartViewModel,
                            productViewModel: productViewModel,
                            onProductClick: { product in
                                selectedProduct = product
                                showProductDetail = true
                            }
                        )
                    case .favorites:
                        FavoritesScreen(
                            productViewModel: productViewModel,
                            onProductClick: { product in
                                selectedProduct = product
                                showProductDetail = true
                            }
                        )
                    case .profile:
                        ProfileScreen(
                            userProfileViewModel: userProfileViewModel,
                            isLoggedIn: isLoggedIn ?? false,
                            onLogin: {
                                isLoggedIn = true
                                localDataStore.setLoggedIn(true)
                            },
                            onLogout: {
                                isLoggedIn = false
                                localDataStore.logout()
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Нижняя навигация (как в Kotlin - внизу экрана с белым фоном под ней)
            VStack(spacing: 0) {
                Spacer()
                
                BottomNavigationBar(
                    selectedItem: selectedTab,
                    onItemSelected: { newTab in
                        selectedTab = newTab
                        // При переходе на Profile проверяем авторизацию
                        if newTab == .profile {
                            isLoggedIn = localDataStore.isLoggedIn()
                        }
                    }
                )
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Экран деталей продукта
            if showProductDetail, let product = selectedProduct {
                ProductDetailScreen(
                    product: product,
                    productViewModel: productViewModel,
                    cartViewModel: cartViewModel,
                    onBackClick: {
                        showProductDetail = false
                        selectedProduct = nil
                    }
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
        .task {
            // Проверяем состояние авторизации при первом запуске
            isLoggedIn = localDataStore.isLoggedIn()
            productViewModel.loadProducts()
            cartViewModel.loadCart()
        }
    }
}

