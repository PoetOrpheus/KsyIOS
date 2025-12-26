//
//  TopHeaderSection.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct TopHeaderSection: View {
    let onSearchClick: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [AppTheme.headerGradientStart, AppTheme.headerGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Контент
                VStack(spacing: 0) {
                    // Строка адреса
                    HStack {
                        Text("ПВЗ: ул. Королева, 5")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Иконка сообщений (заглушка, в реальном приложении будет изображение)
                        Image(systemName: "message.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(
                                width: FigmaDimens.fw(40, geometry: geometry),
                                height: FigmaDimens.fh(30, geometry: geometry)
                            )
                    }
                    .padding(.horizontal, FigmaDimens.fw(15, geometry: geometry))
                    .padding(.top, FigmaDimens.fh(10, geometry: geometry))
                    
                    // Отступ
                    Spacer()
                        .frame(height: FigmaDimens.fh(10, geometry: geometry))
                    
                    // Поисковая строка
                    Button(action: onSearchClick) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                            
                            Text("Ищите что то конкретное?...")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "6E6E6E") ?? .gray)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .frame(
                            width: FigmaDimens.fw(420, geometry: geometry),
                            height: FigmaDimens.fh(40, geometry: geometry)
                        )
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Отступ
                    Spacer()
                        .frame(height: FigmaDimens.fh(10, geometry: geometry))
                    
                    // Баннер 11.11
                    HStack {
                        Text("11.11")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(.black)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Text("распродажа")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .frame(
                        width: FigmaDimens.fw(420, geometry: geometry),
                        height: FigmaDimens.fh(110, geometry: geometry)
                    )
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.bannerGradientStart, AppTheme.bannerGradientEnd]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
            .clipShape(
                .rect(
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20
                )
            )
        }
        .frame(height: 220) // Базовое значение для предварительного расчета
    }
}

