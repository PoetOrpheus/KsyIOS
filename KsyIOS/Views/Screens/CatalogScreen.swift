//
//  CatalogScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

// Названия категорий (соответствуют индексам category_1, category_2...)
private let categoryNames = [
    "Мужская одежда", "Женская одежда", "Детская одежда", "Обувь",
    "Аксессуары", "Сумки", "Часы", "Ювелирные изделия",
    "Косметика", "Парфюмерия", "Спорт", "Электроника",
    "Техника", "Мебель", "Дом и сад", "Автотовары",
    "Книги", "Игрушки", "Продукты", "Другое"
]

struct CatalogScreen: View {
    let onBackClick: () -> Void
    let onCategoryClick: (String) -> Void
    
    var body: some View {
        ZStack {
            AppTheme.bgGray
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopHeaderWithReturn(onBackClick: onBackClick)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: FigmaDimens.fw(25)),
                                GridItem(.flexible(), spacing: FigmaDimens.fw(25)),
                                GridItem(.flexible(), spacing: FigmaDimens.fw(25))
                            ],
                            spacing: FigmaDimens.fh(20),
                            content: {
                                ForEach(0..<20, id: \.self) { index in
                                    let imageIndex = index + 1
                                    let imageName = "category_\(imageIndex)"
                                    let categoryName = index < categoryNames.count ? categoryNames[index] : "Категория \(imageIndex)"
                                    
                                    CatalogBox(
                                        imageName: imageName,
                                        onClick: {
                                            onCategoryClick(categoryName)
                                        }
                                    )
                                }
                            }
                        )
                        .padding(.horizontal, FigmaDimens.fw(20))
                        .padding(.vertical, FigmaDimens.fh(20))
                    }
                }
                .padding(.top, FigmaDimens.fh(60))
                .padding(.horizontal, FigmaDimens.fw(5))
            }
        }
    }
}

private struct CatalogBox: View {
    let imageName: String
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Group {
                if let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Placeholder если изображение не найдено
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Text("\(imageName)")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: FigmaDimens.fw(120), height: FigmaDimens.fh(120))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

