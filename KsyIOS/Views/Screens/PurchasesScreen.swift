//
//  PurchasesScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct PurchasesScreen: View {
    let onBackClick: () -> Void
    let onProductClick: (Product) -> Void
    
    @State private var selectedFilter: OrderStatus? = nil
    
    enum OrderStatus: String, CaseIterable {
        case all = "Все"
        case processing = "Обработка"
        case inDelivery = "В пути"
        case ready = "Можно забирать"
        case completed = "Получено"
        
        var color: Color {
            switch self {
            case .all:
                return .gray
            case .processing:
                return .orange
            case .inDelivery:
                return .blue
            case .ready:
                return .green
            case .completed:
                return .gray
            }
        }
    }
    
    // Пример данных заказов
    private let orders: [Order] = [
        Order(
            id: "1",
            orderNumber: "#12345",
            date: "27 декабря 2024",
            status: .ready,
            totalAmount: 89990,
            items: [
                OrderItem(
                    product: Product(
                        id: "1",
                        name: "iPhone 15 Pro",
                        price: 89990,
                        oldPrice: nil,
                        discount: nil,
                        rating: 4.8,
                        reviewsCount: 234,
                        images: [],
                        imagesRes: ["iphone_1", "iphone_2"],
                        isTimeLimited: false,
                        accentColorHex: "000000",
                        isFavorite: false,
                        seller: nil,
                        brand: nil,
                        description: nil,
                        variants: [],
                        sizes: [],
                        specifications: [],
                        quantity: 1
                    ),
                    quantity: 1,
                    variantName: "Черный",
                    sizeName: nil
                )
            ],
            deliveryAddress: "ПВЗ: ул. Королева, 5",
            deliveryDate: "28 декабря"
        ),
        Order(
            id: "2",
            orderNumber: "#12344",
            date: "26 декабря 2024",
            status: .inDelivery,
            totalAmount: 12990,
            items: [
                OrderItem(
                    product: Product(
                        id: "2",
                        name: "Nike Air Max",
                        price: 12990,
                        oldPrice: 15990,
                        discount: 19,
                        rating: 4.6,
                        reviewsCount: 156,
                        images: [],
                        imagesRes: ["adidas_1"],
                        isTimeLimited: false,
                        accentColorHex: "FF0000",
                        isFavorite: false,
                        seller: nil,
                        brand: nil,
                        description: nil,
                        variants: [],
                        sizes: [ProductSize(id: "1", value: "42", isAvailable: true)],
                        specifications: [],
                        quantity: 1
                    ),
                    quantity: 1,
                    variantName: "Белый",
                    sizeName: "42"
                )
            ],
            deliveryAddress: "ПВЗ: ул. Королева, 5",
            deliveryDate: "29 декабря"
        ),
        Order(
            id: "3",
            orderNumber: "#12343",
            date: "25 декабря 2024",
            status: .completed,
            totalAmount: 15990,
            items: [
                OrderItem(
                    product: Product(
                        id: "3",
                        name: "Часы Calvin Klein",
                        price: 15990,
                        oldPrice: nil,
                        discount: nil,
                        rating: 4.7,
                        reviewsCount: 89,
                        images: [],
                        imagesRes: ["watch_calvin"],
                        isTimeLimited: false,
                        accentColorHex: "000000",
                        isFavorite: false,
                        seller: nil,
                        brand: nil,
                        description: nil,
                        variants: [],
                        sizes: [],
                        specifications: [],
                        quantity: 1
                    ),
                    quantity: 1,
                    variantName: nil,
                    sizeName: nil
                )
            ],
            deliveryAddress: "ПВЗ: ул. Королева, 5",
            deliveryDate: "27 декабря"
        ),
        Order(
            id: "4",
            orderNumber: "#12342",
            date: "24 декабря 2024",
            status: .completed,
            totalAmount: 17980,
            items: [
                OrderItem(
                    product: Product(
                        id: "4",
                        name: "Adidas кроссовки",
                        price: 8990,
                        oldPrice: nil,
                        discount: nil,
                        rating: 4.5,
                        reviewsCount: 312,
                        images: [],
                        imagesRes: ["adidas_2"],
                        isTimeLimited: false,
                        accentColorHex: "000000",
                        isFavorite: false,
                        seller: nil,
                        brand: nil,
                        description: nil,
                        variants: [],
                        sizes: [ProductSize(id: "1", value: "43", isAvailable: true)],
                        specifications: [],
                        quantity: 1
                    ),
                    quantity: 2,
                    variantName: "Черный",
                    sizeName: "43"
                )
            ],
            deliveryAddress: "ПВЗ: ул. Королева, 5",
            deliveryDate: "26 декабря"
        ),
        Order(
            id: "5",
            orderNumber: "#12341",
            date: "23 декабря 2024",
            status: .processing,
            totalAmount: 2490,
            items: [
                OrderItem(
                    product: Product(
                        id: "5",
                        name: "Футболка",
                        price: 2490,
                        oldPrice: 2990,
                        discount: 17,
                        rating: 4.3,
                        reviewsCount: 67,
                        images: [],
                        imagesRes: ["category_1"],
                        isTimeLimited: false,
                        accentColorHex: "000000",
                        isFavorite: false,
                        seller: nil,
                        brand: nil,
                        description: nil,
                        variants: [],
                        sizes: [ProductSize(id: "1", value: "M", isAvailable: true)],
                        specifications: [],
                        quantity: 1
                    ),
                    quantity: 1,
                    variantName: "Белый",
                    sizeName: "M"
                )
            ],
            deliveryAddress: "ПВЗ: ул. Королева, 5",
            deliveryDate: nil
        )
    ]
    
    private var filteredOrders: [Order] {
        if let filter = selectedFilter, filter != .all {
            return orders.filter { $0.status == filter }
        }
        return orders
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                headerView
                
                ScrollView {
                    VStack(spacing: FigmaDimens.fh(20)) {
                        // Фильтры
                        filtersView
                        
                        // Список заказов
                        if filteredOrders.isEmpty {
                            emptyStateView
                        } else {
                            ordersList
                        }
                    }
                    .padding(.horizontal, FigmaDimens.fw(15))
                    .padding(.top, FigmaDimens.fh(20))
                    .padding(.bottom, FigmaDimens.fh(100))
                }
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [
                    AppTheme.categoryGradient1Start,
                    AppTheme.categoryGradient3End
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: FigmaDimens.fh(50))
                
                HStack {
                    Button(action: onBackClick) {
                        Group {
                            if let uiImage = UIImage(named: "return_icon") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                            } else {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(15))
                    
                    Text("Мои покупки")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, FigmaDimens.fw(20))
                
                Spacer()
                    .frame(height: FigmaDimens.fh(20))
            }
        }
        .frame(height: FigmaDimens.fh(120))
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    }
    
    // MARK: - Filters
    
    private var filtersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FigmaDimens.fw(10)) {
                ForEach([OrderStatus.all] + OrderStatus.allCases.filter { $0 != .all }, id: \.self) { status in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFilter = status == .all ? nil : status
                        }
                    }) {
                        Text(status.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedFilter == status || (selectedFilter == nil && status == .all) ? .white : .gray)
                            .padding(.horizontal, FigmaDimens.fw(16))
                            .padding(.vertical, FigmaDimens.fh(8))
                            .background(
                                (selectedFilter == status || (selectedFilter == nil && status == .all)) ?
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppTheme.categoryGradient1Start,
                                        AppTheme.categoryGradient3End
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) : nil
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke((selectedFilter == status || (selectedFilter == nil && status == .all)) ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, FigmaDimens.fw(5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Orders List
    
    private var ordersList: some View {
        VStack(spacing: FigmaDimens.fh(15)) {
            ForEach(filteredOrders) { order in
                orderCard(order: order)
            }
        }
    }
    
    private func orderCard(order: Order) -> some View {
        VStack(spacing: 0) {
            // Заголовок заказа
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Заказ \(order.orderNumber)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(order.date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Статус
                HStack(spacing: 6) {
                    Circle()
                        .fill(order.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(order.status.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(order.status.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(order.status.color.opacity(0.1))
                .cornerRadius(15)
            }
            .padding(FigmaDimens.fw(20))
            
            Divider()
            
            // Товары в заказе
            VStack(spacing: 0) {
                ForEach(Array(order.items.enumerated()), id: \.element.id) { index, item in
                    orderItemRow(item: item, order: order)
                    
                    if index < order.items.count - 1 {
                        Divider()
                            .padding(.leading, FigmaDimens.fw(20))
                    }
                }
            }
            
            Divider()
            
            // Итого и адрес доставки
            VStack(spacing: FigmaDimens.fh(12)) {
                HStack {
                    Text("Итого")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("\(Int(order.totalAmount)) ₽")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                
                if let deliveryDate = order.deliveryDate {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.categoryGradient1Start)
                        
                        Text(order.deliveryAddress)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(deliveryDate)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(FigmaDimens.fw(20))
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func orderItemRow(item: OrderItem, order: Order) -> some View {
        Button(action: {
            onProductClick(item.product)
        }) {
            HStack(spacing: FigmaDimens.fw(15)) {
                // Изображение товара
                Group {
                    if !item.product.imagesRes.isEmpty, let imageName = item.product.imagesRes.first,
                       let uiImage = UIImage(named: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .frame(width: FigmaDimens.fw(80), height: FigmaDimens.fh(80))
                .cornerRadius(12)
                
                // Информация о товаре
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.product.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    if let variantName = item.variantName {
                        Text("Цвет: \(variantName)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    if let sizeName = item.sizeName {
                        Text("Размер: \(sizeName)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    if item.quantity > 1 {
                        Text("Количество: \(item.quantity)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(Int(item.product.price * item.quantity)) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.categoryGradient1Start)
                }
                
                Spacer()
            }
            .padding(FigmaDimens.fw(20))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: FigmaDimens.fh(20)) {
            Image(systemName: "bag.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Нет заказов")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text("У вас пока нет заказов с таким статусом")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FigmaDimens.fh(60))
    }
}

// MARK: - Order Models

struct Order: Identifiable {
    let id: String
    let orderNumber: String
    let date: String
    let status: PurchasesScreen.OrderStatus
    let totalAmount: Double
    let items: [OrderItem]
    let deliveryAddress: String
    let deliveryDate: String?
}

struct OrderItem: Identifiable {
    let id: String
    let product: Product
    let quantity: Int
    let variantName: String?
    let sizeName: String?
    
    init(product: Product, quantity: Int, variantName: String?, sizeName: String?) {
        self.id = "\(product.id)_\(variantName ?? "")_\(sizeName ?? "")"
        self.product = product
        self.quantity = quantity
        self.variantName = variantName
        self.sizeName = sizeName
    }
}

