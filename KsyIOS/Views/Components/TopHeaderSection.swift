//
//  TopHeaderSection.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct TopHeaderSection: View {
    let onSearchClick: () -> Void
    
    var body: some View {
        ZStack {
            // Градиентный фон (как в Kotlin: linearGradient от topLeading к bottomTrailing)
            // Фон также покрывает статус-бар
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
                    
                    // Иконка сообщений (используем оригинальную или fallback)
                    Group {
                        if let uiImage = UIImage(named: "message_without_notification") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(
                                    width: FigmaDimens.fw(40),
                                    height: FigmaDimens.fh(30)
                                )
                        } else {
                            Image(systemName: "message.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(
                                    width: FigmaDimens.fw(40),
                                    height: FigmaDimens.fh(30)
                                )
                        }
                    }
                }
                .padding(.horizontal, FigmaDimens.fw(15))
                .padding(.top, FigmaDimens.fh(10))
                
                // Отступ
                Spacer()
                    .frame(height: FigmaDimens.fh(10))
                
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
                    .frame(height: FigmaDimens.fh(40))
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, FigmaDimens.fw(15))
                
                // Отступ
                Spacer()
                    .frame(height: FigmaDimens.fh(10))
                
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
                .frame(height: FigmaDimens.fh(110))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, FigmaDimens.fw(15))
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.bannerGradientStart, AppTheme.bannerGradientEnd]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .padding(.horizontal, 10)
            }
        }
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .frame(height: FigmaDimens.fh(220))
        .ignoresSafeArea(edges: .top)
    }
}

