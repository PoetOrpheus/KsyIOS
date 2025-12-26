//
//  ProductDetailScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct ProductDetailScreen: View {
    let product: Product
    @ObservedObject var productViewModel: ProductViewModel
    @ObservedObject var cartViewModel: CartViewModel
    
    let onBackClick: () -> Void
    
    @State private var selectedVariantId: String?
    @State private var selectedSizeId: String?
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            // Контент (ScrollView)
            ScrollView {
                VStack(spacing: 0) {
                    // Отступ сверху чтобы контент не перекрывал header
                    Spacer()
                        .frame(height: FigmaDimens.fh(60))
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Карточка товара (Фото + Цена)
                    ProductMainCard(
                        product: product,
                        selectedVariantId: selectedVariantId
                    )
                    .padding(.horizontal, FigmaDimens.fw(5))
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Варианты
                    VariantItemRow(
                        variants: product.variants,
                        selectedVariantId: selectedVariantId,
                        onVariantSelected: { variantId in
                            selectedVariantId = variantId
                        }
                    )
                    .padding(.horizontal, FigmaDimens.fw(5))
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Размеры
                    if !product.sizes.isEmpty {
                        SizeVariants(
                            sizes: product.sizes,
                            selectedSizeId: selectedSizeId,
                            onSizeSelected: { sizeId in
                                selectedSizeId = sizeId
                            }
                        )
                        .padding(.horizontal, FigmaDimens.fw(5))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                    }
                    
                    // Группа: Рейтинг, Описание, Продавец, Бренд
                    Group {
                        // Рейтинг и отзывы
                        StartCardRow(
                            rating: product.rating,
                            reviewsCount: product.reviewsCount
                        )
                        .padding(.horizontal, FigmaDimens.fw(5))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        // Описание и характеристики
                        InfoCardsSection(
                            description: product.description,
                            specifications: product.specifications
                        )
                        .padding(.horizontal, FigmaDimens.fw(5))
                        
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        // Продавец
                        if let seller = product.seller {
                            SellerBlock(seller: seller)
                                .padding(.horizontal, FigmaDimens.fw(5))
                            
                            Spacer()
                                .frame(height: FigmaDimens.fh(10))
                        }
                        
                        // Бренд
                        if let brand = product.brand {
                            BrandBlock(brand: brand)
                                .padding(.horizontal, FigmaDimens.fw(5))
                            
                            Spacer()
                                .frame(height: FigmaDimens.fh(80)) // Отступ для кнопки внизу
                        }
                    }
                }
            }
            
            // Заголовок с кнопкой назад (как overlay сверху, как в Kotlin)
            VStack {
                TopHeaderWithReturn(onBackClick: onBackClick)
                Spacer()
            }
            
            // Кнопка добавления в корзину (внизу экрана, как overlay)
            VStack {
                Spacer()
                
                Button(action: {
                    cartViewModel.addToCart(
                        product: product,
                        selectedVariantId: selectedVariantId,
                        selectedSizeId: selectedSizeId,
                        quantity: 1
                    )
                }) {
                    Text("Добавить в корзину")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: FigmaDimens.fh(50))
                        .background(AppTheme.blueButton)
                        .cornerRadius(15)
                }
                .padding(.horizontal, FigmaDimens.fw(20))
                .padding(.vertical, FigmaDimens.fh(10))
                .background(AppTheme.backgroundLight)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            // Инициализация выбранных значений
            if selectedVariantId == nil {
                selectedVariantId = product.variants.first { $0.isAvailable }?.id
            }
            if selectedSizeId == nil {
                selectedSizeId = product.sizes.first { $0.isAvailable }?.id
            }
        }
    }
}
