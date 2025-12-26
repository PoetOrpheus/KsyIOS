//
//  BottomNavigationBar.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct BottomNavigationBar: View {
    let selectedItem: BottomNavItem
    let onItemSelected: (BottomNavItem) -> Void
    
    var body: some View {
        ZStack {
            // Белый фон под навигацией (как в Kotlin)
            Color.white
                .frame(maxWidth: .infinity)
            
            // Навигационная панель с закругленными верхними углами
            HStack(spacing: 0) {
                ForEach(BottomNavItem.allCases, id: \.self) { item in
                    Button(action: {
                        onItemSelected(item)
                    }) {
                        // Используем оригинальные иконки из Assets (если есть) или fallback на системные
                        Group {
                            if let uiImage = UIImage(named: item.icon) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(selectedItem == item ? AppTheme.brandPurple : .black)
                                    .frame(width: FigmaDimens.fh(30), height: FigmaDimens.fh(30))
                            } else {
                                Image(systemName: item.fallbackIcon)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedItem == item ? AppTheme.brandPurple : .black)
                            }
                        }
                        .frame(
                            width: FigmaDimens.fh(40),
                            height: FigmaDimens.fh(40)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: FigmaDimens.fh(60))
            .background(AppTheme.bgGray)
            .cornerRadius(30, corners: [.topLeft, .topRight])
        }
        .frame(height: FigmaDimens.fh(60))
    }
}

