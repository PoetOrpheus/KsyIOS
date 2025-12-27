//
//  FiltersRow.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct FiltersRow: View {
    let isSelect: Bool
    let onClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(width: FigmaDimens.fw(25))
            
            // Фильтр
            IconButton(iconName: "filtr_setting")
            
            Spacer()
                .frame(width: FigmaDimens.fw(25))
            
            // Категории
            IconButton(iconName: "category_favorite_setting")
            
            Spacer()
                .frame(width: FigmaDimens.fw(25))
            
            // Магазины
            SwitchButton(
                text: "Магазины",
                isSelected: isSelect,
                onClick: onClick
            )
            
            Spacer()
                .frame(width: FigmaDimens.fw(13))
            
            // Разделительная линия
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "A2A2A2") ?? .gray)
                .frame(width: FigmaDimens.fw(4), height: FigmaDimens.fh(40))
            
            Spacer()
                .frame(width: FigmaDimens.fw(13))
            
            // Бренды
            SwitchButton(
                text: "Бренды",
                isSelected: !isSelect,
                onClick: onClick
            )
            

        }
        .frame(height: FigmaDimens.fh(40))
        .frame(maxWidth: .infinity)
    }
}

private struct IconButton: View {
    let iconName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: 5,
                    x: 0,
                    y: 2
                )
            
            Group {
                if let uiImage = UIImage(named: iconName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: FigmaDimens.fw(18),
                            height: FigmaDimens.fh(18)
                        )
                } else {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(
            width: FigmaDimens.fw(30),
            height: FigmaDimens.fh(30)
        )
    }
}

private struct SwitchButton: View {
    let text: String
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .black)
                .frame(
                    width: FigmaDimens.fw(130),
                    height: isSelected ? FigmaDimens.fh(30) : FigmaDimens.fh(40)
                )
                .background(
                    isSelected ? AppTheme.blueButton : Color.clear
                )
                .cornerRadius(10)
                .shadow(
                    color: isSelected ? Color.black.opacity(0.3) : Color.clear,
                    radius: isSelected ? 5 : 0,
                    x: 0,
                    y: isSelected ? 2 : 0
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

