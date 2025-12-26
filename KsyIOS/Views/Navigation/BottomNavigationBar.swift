//
//  BottomNavigationBar.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct BottomNavigationBar: View {
    let selectedItem: BottomNavItem
    let onItemSelected: (BottomNavItem) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(BottomNavItem.allCases, id: \.self) { item in
                    Button(action: {
                        onItemSelected(item)
                    }) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedItem == item ? AppTheme.brandPurple : .black)
                            .frame(
                                width: FigmaDimens.fh(40, geometry: geometry),
                                height: FigmaDimens.fh(40, geometry: geometry)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: FigmaDimens.fh(60, geometry: geometry))
            .background(AppTheme.bgGray)
            .cornerRadius(30, corners: [.topLeft, .topRight])
        }
        .frame(height: 60) // Базовое значение
    }
}

