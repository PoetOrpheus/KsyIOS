//
//  TopHeaderWithSearchAndReturn.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct TopHeaderWithSearchAndReturn: View {
    @Binding var searchQuery: String
    let onBackClick: () -> Void
    
    init(searchQuery: Binding<String> = .constant(""), onBackClick: @escaping () -> Void) {
        self._searchQuery = searchQuery
        self.onBackClick = onBackClick
    }
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [AppTheme.headerGradientStart, AppTheme.headerGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                // Строка адреса
                HStack(alignment: .center) {
                    Text("ПВЗ: ул. Королева, 5")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Иконка сообщений
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
                
                // Строка с кнопкой назад и поиском
                HStack(alignment: .center, spacing: 0) {
                    // Кнопка назад
                    Button(action: onBackClick) {
                        Group {
                            if let uiImage = UIImage(named: "return_icon") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(
                                        width: FigmaDimens.fw(30),
                                        height: FigmaDimens.fh(30)
                                    )
                            } else {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(
                                        width: FigmaDimens.fw(30),
                                        height: FigmaDimens.fh(30)
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(15))
                    
                    // Поисковая строка
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                        
                        TextField("Ищите что то конкретное?...", text: $searchQuery)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .frame(width: FigmaDimens.fw(385), height: FigmaDimens.fh(40))
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, FigmaDimens.fw(15))
            }
        }
        .frame(height: FigmaDimens.fh(100))
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea(edges: .top)
    }
}

