//
//  InfoCardsSection.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct InfoCardsSection: View {
    let description: String?
    let specifications: [ProductSpecification]
    
    @State private var selectedTab: Bool = true // true = Описание, false = Характеристики
    @State private var showFullText: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Табы
            HStack(spacing: FigmaDimens.fw(10)) {
                // Таб "Описание"
                Button(action: {
                    selectedTab = true
                }) {
                    Text("Описание")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(selectedTab ? .white : .black)
                        .frame(width: FigmaDimens.fw(120), height: FigmaDimens.fh(30))
                        .background(selectedTab ? AppTheme.blueButton : Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                }
                
                // Таб "Характеристики"
                Button(action: {
                    selectedTab = false
                }) {
                    Text("Характеристики")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(!selectedTab ? .white : .black)
                        .frame(width: FigmaDimens.fw(175), height: FigmaDimens.fh(30))
                        .background(!selectedTab ? AppTheme.blueButton : Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                }
            }
            .padding(.horizontal, FigmaDimens.fw(10))
            .frame(height: FigmaDimens.fh(30))
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Контент
            if selectedTab {
                DescriptionView(
                    description: description,
                    showFullText: $showFullText
                )
            } else {
                CharacteristicsView(specifications: specifications)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

private struct DescriptionView: View {
    let description: String?
    @Binding var showFullText: Bool
    
    var body: some View {
        let text = description ?? "Описание товара отсутствует"
        let maxHeight: CGFloat = FigmaDimens.fh(160)
        
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black)
                .lineLimit(showFullText ? nil : nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FigmaDimens.fw(10))
                .padding(.bottom, showFullText ? FigmaDimens.fh(10) : 0)
            
            if !showFullText {
                // Кнопка "Развернуть" (если текст большой)
                Button(action: {
                    showFullText = true
                }) {
                    HStack {
                        Spacer()
                        
                        Text("Развернуть")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Spacer()
                            .frame(width: FigmaDimens.fw(10))
                        
                        Group {
                            if let uiImage = UIImage(named: "down") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(
                                        width: FigmaDimens.fw(20),
                                        height: FigmaDimens.fh(20)
                                    )
                            } else {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14))
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .frame(height: FigmaDimens.fh(30))
                    .padding(.horizontal, FigmaDimens.fw(10))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                AppTheme.blueButton
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: FigmaDimens.fh(50))
            }
        }
    }
}

private struct CharacteristicsView: View {
    let specifications: [ProductSpecification]
    
    var body: some View {
        VStack(spacing: 0) {
            if specifications.isEmpty {
                Text("Характеристики не указаны")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, FigmaDimens.fh(20))
            } else {
                ForEach(Array(specifications.enumerated()), id: \.element.name) { index, spec in
                    HStack(spacing: FigmaDimens.fw(10)) {
                        Text(spec.name)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(width: FigmaDimens.fw(120), alignment: .leading)
                        
                        Text(spec.value)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: FigmaDimens.fh(30))
                    .padding(.horizontal, FigmaDimens.fw(10))
                    .background(Color.white)
                    
                    if index < specifications.count - 1 {
                        Rectangle()
                            .fill(Color(hex: "D9D9D9") ?? .gray)
                            .frame(height: FigmaDimens.fh(2))
                            .padding(.horizontal, FigmaDimens.fw(10))
                    }
                }
            }
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
        }
    }
}

