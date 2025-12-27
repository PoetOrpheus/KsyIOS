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
    @State private var showCatalog = false
    @State private var showCatalogSubScreen = false
    @State private var showCategoryProducts = false
    @State private var selectedCategoryName: String? = nil
    @State private var selectedSubcategoryName: String? = nil
    @State private var showCanBeSeller = false
    @State private var showBrands = false
    @State private var showHistory = false
    
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
                                showHistory = true
                            },
                            onCanBeSeller: {
                                showCanBeSeller = true
                            },
                            onCategoryClick: {
                                showCatalog = true
                            },
                            onBrandsClick: {
                                showBrands = true
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
            // Скрываем навигацию на экранах деталей, истории, каталога и других подэкранах
            if !showProductDetail && !showCanBeSeller && !showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showBrands && !showHistory && !showSearch {
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
            }
            
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
                .zIndex(10)
            }
            
            // Экран истории просмотров
            if showHistory && !showProductDetail && !showSearch {
                HistoryScreen(
                    onBackClick: {
                        showHistory = false
                    },
                    onProductClick: { product in
                        selectedProduct = product
                        showHistory = false
                        showProductDetail = true
                    },
                    productViewModel: productViewModel
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
            
            // Экран "Стать продавцом"
            if showCanBeSeller && !showProductDetail && !showHistory && !showSearch {
                CanBeSellerScreen(
                    onBackClick: {
                        showCanBeSeller = false
                    }
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
            
            // Экран каталога
            if showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showCanBeSeller && !showBrands && !showHistory && !showSearch {
                CatalogScreen(
                    onBackClick: {
                        showCatalog = false
                    },
                    onCategoryClick: { categoryName in
                        selectedCategoryName = categoryName
                        showCatalog = false
                        showCatalogSubScreen = true
                    }
                )
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
            
            // Экран подкатегорий каталога
            if showCatalogSubScreen && !showCatalog && !showCategoryProducts && !showCanBeSeller && !showBrands && !showHistory && !showSearch {
                CatalogSubScreen(
                    onBackClick: {
                        showCatalogSubScreen = false
                        selectedCategoryName = nil
                        showCatalog = true
                    },
                    onSubcategoryClick: { subcategoryName in
                        selectedSubcategoryName = subcategoryName
                        showCatalogSubScreen = false
                        showCategoryProducts = true
                    }
                )
                .transition(.move(edge: .trailing))
                .zIndex(2)
            }
            
            // Экран продуктов категории
            if showCategoryProducts && !showCatalog && !showCatalogSubScreen && !showCanBeSeller && !showBrands && !showHistory && !showSearch {
                CategoryProductsScreen(
                    categoryName: selectedCategoryName ?? "",
                    subcategoryName: selectedSubcategoryName ?? "",
                    onBackClick: {
                        showCategoryProducts = false
                        selectedSubcategoryName = nil
                        if selectedCategoryName != nil {
                            showCatalogSubScreen = true
                        }
                    },
                    onProductClick: { product in
                        selectedProduct = product
                        showProductDetail = true
                    },
                    productViewModel: productViewModel
                )
                .transition(.move(edge: .trailing))
                .zIndex(3)
            }
            
            // Экран "Магазины и бренды"
            if showBrands && !showProductDetail && !showCanBeSeller && !showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showHistory && !showSearch {
                BrandsScreen(
                    onBackClick: {
                        showBrands = false
                    }
                )
                .transition(.move(edge: .trailing))
                .zIndex(4)
            }
            
            // Экран поиска
            if showSearch && !showProductDetail && !showHistory && !showCanBeSeller && !showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showBrands {
                SearchScreen(
                    searchQuery: $searchQuery,
                    onBackClick: {
                        showSearch = false
                        searchQuery = ""
                        productViewModel.clearSearchResults()
                    },
                    onProductClick: { product in
                        selectedProduct = product
                        showSearch = false
                        showProductDetail = true
                    },
                    productViewModel: productViewModel
                )
                .transition(.move(edge: .trailing))
                .zIndex(5)
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

