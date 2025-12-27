//
//  FinancesScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct FinancesScreen: View {
    @State private var selectedPeriod: Period = .month
    @State private var totalSpent: Double = 125000.0
    
    enum Period: String, CaseIterable {
        case week = "Неделя"
        case month = "Месяц"
        case year = "Год"
    }
    
    // Пример данных о покупках
    private let purchases: [Purchase] = [
        Purchase(
            id: "1",
            title: "iPhone 15 Pro",
            orderNumber: "#12345",
            amount: 89990,
            date: "Сегодня, 14:30",
            status: .completed,
            icon: "iphone"
        ),
        Purchase(
            id: "2",
            title: "Nike Air Max",
            orderNumber: "#12344",
            amount: 12990,
            date: "Вчера, 18:45",
            status: .completed,
            icon: "shoe.fill"
        ),
        Purchase(
            id: "3",
            title: "Часы Calvin Klein",
            orderNumber: "#12343",
            amount: 15990,
            date: "25 дек, 12:20",
            status: .completed,
            icon: "clock.fill"
        ),
        Purchase(
            id: "4",
            title: "Adidas кроссовки",
            orderNumber: "#12342",
            amount: 8990,
            date: "24 дек, 10:15",
            status: .completed,
            icon: "shoe.fill"
        ),
        Purchase(
            id: "5",
            title: "Футболка",
            orderNumber: "#12341",
            amount: 2490,
            date: "23 дек, 16:30",
            status: .completed,
            icon: "tshirt.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppTheme.backgroundLight
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Заголовок с градиентом
                    headerView
                    
                    // Основной контент
                    VStack(spacing: FigmaDimens.fh(20)) {
                        // Карточка общей суммы
                        totalSpentCard
                        
                        // Статистика по периодам
                        statisticsCard
                        
                        // История покупок
                        purchasesCard
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
                    Text("Финансы")
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
    
    // MARK: - Total Spent Card
    
    private var totalSpentCard: some View {
        VStack(spacing: FigmaDimens.fh(15)) {
            HStack {
                Text("Всего потрачено")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(Int(totalSpent))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)
                
                Text("₽")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Период выбора
            HStack(spacing: FigmaDimens.fw(10)) {
                ForEach(Period.allCases, id: \.self) { period in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedPeriod = period
                        }
                    }) {
                        Text(period.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedPeriod == period ? .white : .gray)
                            .padding(.horizontal, FigmaDimens.fw(16))
                            .padding(.vertical, FigmaDimens.fh(8))
                            .background(
                                selectedPeriod == period ?
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
                                    .stroke(selectedPeriod == period ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Statistics Card
    
    private var statisticsCard: some View {
        VStack(alignment: .leading, spacing: FigmaDimens.fh(20)) {
            HStack {
                Text("Статистика")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // Информационные карточки
            HStack(spacing: FigmaDimens.fw(15)) {
                // Количество покупок
                VStack(alignment: .leading, spacing: FigmaDimens.fh(10)) {
                    HStack {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.categoryGradient3End)
                        
                        Text("Покупок")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(purchases.count)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(FigmaDimens.fw(15))
                .background(AppTheme.categoryGradient3End.opacity(0.1))
                .cornerRadius(15)
                
                // Средний чек
                VStack(alignment: .leading, spacing: FigmaDimens.fh(10)) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.categoryGradient1Start)
                        
                        Text("Средний чек")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(Int(totalSpent / Double(purchases.count))) ₽")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(FigmaDimens.fw(15))
                .background(AppTheme.categoryGradient1Start.opacity(0.1))
                .cornerRadius(15)
            }
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Purchases Card
    
    private var purchasesCard: some View {
        VStack(alignment: .leading, spacing: FigmaDimens.fh(15)) {
            HStack {
                Text("История покупок")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Все")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.categoryGradient1Start)
                }
            }
            
            VStack(spacing: FigmaDimens.fh(12)) {
                ForEach(Array(purchases.enumerated()), id: \.element.id) { index, purchase in
                    purchaseRow(purchase: purchase)
                    
                    if index < purchases.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func purchaseRow(purchase: Purchase) -> some View {
        HStack(spacing: FigmaDimens.fw(15)) {
            // Иконка покупки
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppTheme.categoryGradient1Start.opacity(0.2),
                                AppTheme.categoryGradient3End.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: FigmaDimens.fw(50), height: FigmaDimens.fh(50))
                
                Image(systemName: purchase.icon)
                    .font(.system(size: 22))
                    .foregroundColor(AppTheme.categoryGradient3End)
            }
            
            // Информация о покупке
            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Заказ \(purchase.orderNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(purchase.date)
                    .font(.system(size: 11))
                    .foregroundColor(.gray.opacity(0.7))
            }
            
            Spacer()
            
            // Сумма и статус
            VStack(alignment: .trailing, spacing: 4) {
                Text("-\(Int(purchase.amount)) ₽")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                // Статус
                HStack(spacing: 4) {
                    Circle()
                        .fill(purchase.status.color)
                        .frame(width: 6, height: 6)
                    
                    Text(purchase.status.text)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(purchase.status.color)
                }
            }
        }
    }
}

// MARK: - Purchase Model

struct Purchase: Identifiable {
    let id: String
    let title: String
    let orderNumber: String
    let amount: Double
    let date: String
    let status: PurchaseStatus
    let icon: String
}

enum PurchaseStatus {
    case completed
    case processing
    case cancelled
    
    var text: String {
        switch self {
        case .completed:
            return "Оплачено"
        case .processing:
            return "Обработка"
        case .cancelled:
            return "Отменено"
        }
    }
    
    var color: Color {
        switch self {
        case .completed:
            return .green
        case .processing:
            return .orange
        case .cancelled:
            return .red
        }
    }
}
