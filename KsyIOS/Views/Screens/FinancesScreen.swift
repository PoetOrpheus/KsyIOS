//
//  FinancesScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct FinancesScreen: View {
    @State private var selectedPeriod: Period = .month
    @State private var balance: Double = 125000.0
    @State private var income: Double = 45000.0
    @State private var expenses: Double = 32000.0
    
    enum Period: String, CaseIterable {
        case week = "Неделя"
        case month = "Месяц"
        case year = "Год"
    }
    
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
                        // Карточка баланса
                        balanceCard
                        
                        // Статистика
                        statisticsCard
                        
                        // Быстрые действия
                        quickActionsCard
                        
                        // Последние транзакции
                        transactionsCard
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
    
    // MARK: - Balance Card
    
    private var balanceCard: some View {
        VStack(spacing: FigmaDimens.fh(15)) {
            HStack {
                Text("Общий баланс")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(Int(balance))")
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
        VStack(spacing: FigmaDimens.fh(20)) {
            HStack {
                Text("Статистика")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack(spacing: FigmaDimens.fw(15)) {
                // Доходы
                VStack(alignment: .leading, spacing: FigmaDimens.fh(10)) {
                    HStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 12, height: 12)
                        
                        Text("Доходы")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(Int(income)) ₽")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(FigmaDimens.fw(15))
                .background(Color.green.opacity(0.1))
                .cornerRadius(15)
                
                // Расходы
                VStack(alignment: .leading, spacing: FigmaDimens.fh(10)) {
                    HStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 12, height: 12)
                        
                        Text("Расходы")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(Int(expenses)) ₽")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(FigmaDimens.fw(15))
                .background(Color.red.opacity(0.1))
                .cornerRadius(15)
            }
            
            // Прогресс-бар
            VStack(alignment: .leading, spacing: FigmaDimens.fh(8)) {
                HStack {
                    Text("Прибыль")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Int(income - expenses)) ₽")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.green,
                                        Color.green.opacity(0.7)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * min(1.0, (income - expenses) / income),
                                height: 8
                            )
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsCard: some View {
        VStack(alignment: .leading, spacing: FigmaDimens.fh(15)) {
            HStack {
                Text("Быстрые действия")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack(spacing: FigmaDimens.fw(15)) {
                quickActionButton(
                    icon: "arrow.down.circle.fill",
                    title: "Пополнить",
                    color: Color.green
                ) {
                    // Действие пополнения
                }
                
                quickActionButton(
                    icon: "arrow.up.circle.fill",
                    title: "Вывести",
                    color: Color.blue
                ) {
                    // Действие вывода
                }
                
                quickActionButton(
                    icon: "chart.bar.fill",
                    title: "Отчет",
                    color: AppTheme.categoryGradient3End
                ) {
                    // Действие отчета
                }
                
                quickActionButton(
                    icon: "creditcard.fill",
                    title: "Карты",
                    color: Color.purple
                ) {
                    // Действие карт
                }
            }
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: FigmaDimens.fh(10)) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(60))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Transactions
    
    private var transactionsCard: some View {
        VStack(alignment: .leading, spacing: FigmaDimens.fh(15)) {
            HStack {
                Text("Последние транзакции")
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
                transactionRow(
                    icon: "arrow.down.circle.fill",
                    title: "Пополнение баланса",
                    subtitle: "Банковская карта",
                    amount: "+15 000 ₽",
                    color: .green,
                    date: "Сегодня, 14:30"
                )
                
                Divider()
                
                transactionRow(
                    icon: "arrow.up.circle.fill",
                    title: "Вывод средств",
                    subtitle: "На карту ****1234",
                    amount: "-5 000 ₽",
                    color: .red,
                    date: "Вчера, 18:45"
                )
                
                Divider()
                
                transactionRow(
                    icon: "cart.fill",
                    title: "Покупка товара",
                    subtitle: "Заказ #12345",
                    amount: "-2 500 ₽",
                    color: .orange,
                    date: "25 дек, 12:20"
                )
                
                Divider()
                
                transactionRow(
                    icon: "gift.fill",
                    title: "Бонус за покупку",
                    subtitle: "Программа лояльности",
                    amount: "+500 ₽",
                    color: .blue,
                    date: "24 дек, 10:15"
                )
            }
        }
        .padding(FigmaDimens.fw(20))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func transactionRow(icon: String, title: String, subtitle: String, amount: String, color: Color, date: String) -> some View {
        HStack(spacing: FigmaDimens.fw(15)) {
            // Иконка
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: FigmaDimens.fw(45), height: FigmaDimens.fh(45))
                .background(color.opacity(0.2))
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 2)
                )
                .clipShape(Circle())
            
            // Информация
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(date)
                    .font(.system(size: 11))
                    .foregroundColor(.gray.opacity(0.7))
            }
            
            Spacer()
            
            // Сумма
            Text(amount)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}

