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
            .clipShape(
                .rect(
                    topLeadingRadius: 30,
                    topTrailingRadius: 30
                )
            )
        }
        .frame(height: 60) // Базовое значение
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

