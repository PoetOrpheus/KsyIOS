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
    
    // Вычисляемое свойство для основного контента
    @ViewBuilder
    private var mainContent: some View {
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
                },
                onFinancesClick: {
                    selectedTab = .finances
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
        case .finances:
            FinancesScreen()
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
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Контент экрана
                mainContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Overlay views
            Group {
                bottomNavigationBar
                productDetailOverlay
                historyOverlay
                canBeSellerOverlay
                catalogOverlay
                catalogSubScreenOverlay
                categoryProductsOverlay
                brandsOverlay
                searchOverlay
            }
        }
        .task {
            // Проверяем состояние авторизации при первом запуске
            isLoggedIn = localDataStore.isLoggedIn()
            productViewModel.loadProducts()
            cartViewModel.loadCart()
        }
    }
    
    // MARK: - Overlay Views
    
    @ViewBuilder
    private var bottomNavigationBar: some View {
        if !showProductDetail && !showCanBeSeller && !showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showBrands && !showHistory && !showSearch {
            VStack(spacing: 0) {
                Spacer()
                BottomNavigationBar(
                    selectedItem: selectedTab,
                    onItemSelected: { newTab in
                        selectedTab = newTab
                        if newTab == .profile {
                            isLoggedIn = localDataStore.isLoggedIn()
                        }
                    }
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @ViewBuilder
    private var productDetailOverlay: some View {
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
    }
    
    @ViewBuilder
    private var historyOverlay: some View {
        if showHistory && !showProductDetail && !showSearch {
            HistoryScreen(
                onBackClick: { showHistory = false },
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
    }
    
    @ViewBuilder
    private var canBeSellerOverlay: some View {
        if showCanBeSeller && !showProductDetail && !showHistory && !showSearch {
            CanBeSellerScreen(onBackClick: { showCanBeSeller = false })
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }
    
    @ViewBuilder
    private var catalogOverlay: some View {
        if showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showCanBeSeller && !showBrands && !showHistory && !showSearch {
            CatalogScreen(
                onBackClick: { showCatalog = false },
                onCategoryClick: { categoryName in
                    selectedCategoryName = categoryName
                    showCatalog = false
                    showCatalogSubScreen = true
                }
            )
            .transition(.move(edge: .trailing))
            .zIndex(1)
        }
    }
    
    @ViewBuilder
    private var catalogSubScreenOverlay: some View {
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
    }
    
    @ViewBuilder
    private var categoryProductsOverlay: some View {
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
    }
    
    @ViewBuilder
    private var brandsOverlay: some View {
        if showBrands && !showProductDetail && !showCanBeSeller && !showCatalog && !showCatalogSubScreen && !showCategoryProducts && !showHistory && !showSearch {
            BrandsScreen(onBackClick: { showBrands = false })
                .transition(.move(edge: .trailing))
                .zIndex(4)
        }
    }
    
    @ViewBuilder
    private var searchOverlay: some View {
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
}

