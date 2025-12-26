//
//  CategoriesRow.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct CategoriesRow: View {
    let onHistoryClick: () -> Void
    let onCanBeSeller: () -> Void
    let onCategoryClick: () -> Void
    let onBrandsClick: () -> Void
    
    var body: some View {
        HStack {
            CategoryItem(
                text: "Стать\nпродавцом",
                gradientStart: AppTheme.categoryGradient1Start,
                gradientEnd: AppTheme.categoryGradient1End,
                icon: "storefront.fill",
                width: 30,
                height: 30,
                appearanceDelay: 0,
                onClick: onCanBeSeller
            )
            
            Spacer()
            
            CategoryItem(
                text: "Магазины\nи бренды",
                gradientStart: AppTheme.categoryGradient1Start,
                gradientEnd: AppTheme.categoryGradient2End,
                icon: "tag.fill",
                width: 30,
                height: 30,
                appearanceDelay: 50,
                onClick: onBrandsClick
            )
            
            Spacer()
            
            CategoryItem(
                text: "Финансы",
                gradientStart: AppTheme.categoryGradient1Start,
                gradientEnd: AppTheme.categoryGradient3End,
                icon: "creditcard.fill",
                width: 30,
                height: 30,
                appearanceDelay: 100,
                onClick: {}
            )
            
            Spacer()
            
            CategoryItem(
                text: "История\nпросмотров",
                gradientStart: AppTheme.categoryGradient1Start,
                gradientEnd: AppTheme.categoryGradient4End,
                icon: "clock.fill",
                width: 40,
                height: 40,
                appearanceDelay: 150,
                onClick: onHistoryClick
            )
            
            Spacer()
            
            CategoryItem(
                text: "Каталог",
                gradientStart: AppTheme.categoryGradient1Start,
                gradientEnd: AppTheme.categoryGradient5End,
                icon: "square.grid.2x2.fill",
                width: 30,
                height: 44,
                appearanceDelay: 200,
                onClick: onCategoryClick
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, FigmaDimens.fw(10))
        .padding(.top, FigmaDimens.fh(10))
        .frame(height: FigmaDimens.fh(115))
    }
}

struct CategoryItem: View {
    let text: String
    let gradientStart: Color
    let gradientEnd: Color
    let icon: String
    let width: Int
    let height: Int
    let appearanceDelay: Int
    let onClick: () -> Void
    
    @State private var isVisible: CGFloat = 0
    @State private var alpha: Double = 0
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: FigmaDimens.fh(4)) {
            // Круглая кнопка с градиентом
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isPressed = false
                    }
                    onClick()
                }
            }) {
                LinearGradient(
                    gradient: Gradient(colors: [gradientStart, gradientEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(
                    width: FigmaDimens.fw(70),
                    height: FigmaDimens.fh(70)
                )
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: CGFloat(width)))
                        .foregroundColor(.white)
                )
                .cornerRadius(18)
                .scaleEffect(isVisible * (isPressed ? 0.85 : 1.0))
                .opacity(alpha)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Текст
            Text(text)
                .font(.system(size: 9, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(
                    width: FigmaDimens.fw(70),
                    height: FigmaDimens.fh(40)
                )
        }
        .frame(width: FigmaDimens.fw(70))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(appearanceDelay) / 1000.0) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isVisible = 1.0
                }
                withAnimation(.easeIn(duration: 0.3)) {
                    alpha = 1.0
                }
            }
        }
    }
}

