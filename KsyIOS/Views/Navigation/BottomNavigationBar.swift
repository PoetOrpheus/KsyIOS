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
        HStack(spacing: 0) {
            ForEach(BottomNavItem.allCases, id: \.self) { item in
                Button(action: {
                    onItemSelected(item)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 24))
                            .foregroundColor(selectedItem == item ? AppTheme.brandPurple : .black)
                        
                        Text(item.rawValue)
                            .font(.system(size: 10))
                            .foregroundColor(selectedItem == item ? AppTheme.brandPurple : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                }
            }
        }
        .background(AppTheme.backgroundLight)
        .cornerRadius(30, corners: [.topLeft, .topRight])
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

