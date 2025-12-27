//
//  CatalogSubScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct CatalogSubScreen: View {
    let onBackClick: () -> Void
    let onSubcategoryClick: (String) -> Void
    
    // Список подкатегорий (такой же как в Kotlin)
    private let subcategories = [
        "Блузы и рубашки",
        "Брюки, бриджи и капри",
        "Верхняя одежда",
        "Джемперы, свитеры и кардиганы",
        "Джинсы и джеггинсы",
        "Домашняя одежда",
        "Комбинезоны",
        "Костюмы и комплекты",
        "Купальники и пляжная одежда",
        "Лонгсливы",
        "Носки, колготки и чулки",
        "Пиджаки, жакеты и жилеты",
        "Платья и сарафаны",
        "Термобелье",
        "Толстовки, свитшоты и худи",
        "Туники",
        "Футболки и топы",
        "Шорты",
        "Юбки",
        "Одежда больших размеров",
        "Одежда для беременных",
        "Свадебные платья"
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.bgGray
                .ignoresSafeArea()
            
            TopHeaderWithReturn(onBackClick: onBackClick)
                .zIndex(1)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    VStack(spacing: 0) {
                        ForEach(Array(subcategories.enumerated()), id: \.offset) { index, subcategory in
                            CategoryRow(
                                text: subcategory,
                                isFirst: index == 0,
                                isLast: index == subcategories.count - 1,
                                onClick: {
                                    onSubcategoryClick(subcategory)
                                }
                            )
                            
                            if index < subcategories.count - 1 {
                                Divider()
                                    .background(AppTheme.bgGray)
                                    .frame(height: FigmaDimens.fh(2))
                            }
                        }
                    }
                    .padding(.horizontal, FigmaDimens.fw(5))
                    
                    Spacer()
                        .frame(height: FigmaDimens.fh(20))
                }
            }
            .padding(.top, FigmaDimens.fh(60))
        }
    }
}

private struct CategoryRow: View {
    let text: String
    let isFirst: Bool
    let isLast: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                    .frame(width: FigmaDimens.fw(20))
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: FigmaDimens.fh(40))
                
                // Иконка стрелки вправо
                Group {
                    if let uiImage = UIImage(named: "circle_right") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: FigmaDimens.fw(20),
                                height: FigmaDimens.fh(20)
                            )
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(
                                width: FigmaDimens.fw(20),
                                height: FigmaDimens.fh(20)
                            )
                    }
                }
                
                Spacer()
                    .frame(width: FigmaDimens.fw(15))
            }
            .frame(maxWidth: .infinity)
            .frame(height: FigmaDimens.fh(40))
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(
            isFirst || isLast ? 20 : 0,
            corners: isFirst ? [.topLeft, .topRight] : (isLast ? [.bottomLeft, .bottomRight] : [])
        )
    }
}

