//
//  InfoCardsSection.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct InfoCardsSection: View {
    let description: String?
    let specifications: [ProductSpecification]
    
    @State private var selectedTab: Bool = true // true = Описание, false = Характеристики
    @State private var showFullText: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Табы — равные по ширине (по maxWidth: .infinity)
            HStack(spacing: FigmaDimens.fw(10)) {
                TabButton(
                    title: "Описание",
                    isSelected: selectedTab
                ) {
                    selectedTab = true
                }
                
                TabButton(
                    title: "Характеристики",
                    isSelected: !selectedTab
                ) {
                    selectedTab = false
                }
            }
            .padding(.horizontal, FigmaDimens.fw(10))
            
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
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
    }
}

// Отдельный View для табов, чтобы избежать ошибки с frame внутри Button
private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: FigmaDimens.fh(30))
                .background(isSelected ? AppTheme.blueButton : Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

private struct DescriptionView: View {
    let description: String?
    @Binding var showFullText: Bool
    
    var body: some View {
        let text = description ?? "Описание товара отсутствует"
        
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black)
                .lineLimit(showFullText ? nil : 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FigmaDimens.fw(15))
                .padding(.bottom, showFullText ? FigmaDimens.fh(10) : 0)
            
            if !showFullText && (description?.count ?? 0) > 150 { // показываем кнопку только если текст длинный
                Button(action: {
                    withAnimation {
                        showFullText = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Развернуть")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        if let uiImage = UIImage(named: "down") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: FigmaDimens.fw(20), height: FigmaDimens.fh(20))
                        } else {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, FigmaDimens.fw(15))
                    .frame(height: FigmaDimens.fh(40))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.0), AppTheme.blueButton]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
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
                    HStack(spacing: FigmaDimens.fw(15)) {
                        Text(spec.name)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(width: FigmaDimens.fw(140), alignment: .leading)
                        
                        Text(spec.value)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: FigmaDimens.fh(30))
                    .padding(.horizontal, FigmaDimens.fw(15))
                    
                    if index < specifications.count - 1 {
                        Rectangle()
                            .fill(Color(hex: "D9D9D9") ?? .gray)
                            .frame(height: 1)
                            .padding(.horizontal, FigmaDimens.fw(15))
                    }
                }
            }
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
        }
    }
}