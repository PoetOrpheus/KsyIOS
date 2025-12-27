//
//  SizeVariants.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct SizeVariants: View {
    let sizes: [ProductSize]
    let selectedSizeId: String?
    let onSizeSelected: (String) -> Void
    
    var body: some View {
        if !sizes.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) { // Добавили scroll если много
                HStack(spacing: FigmaDimens.fw(8)) { // Меньше spacing
                    ForEach(sizes) { size in
                        SizeButton(
                            text: size.value,
                            isSelected: size.id == selectedSizeId,
                            isAvailable: size.isAvailable,
                            onClick: {
                                if size.isAvailable {
                                    onSizeSelected(size.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, FigmaDimens.fw(15))
            }
            .frame(height: FigmaDimens.fh(30))
        }
    }
}

private struct SizeButton: View {
    let text: String
    let isSelected: Bool
    let isAvailable: Bool
    let onClick: () -> Void
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(isAvailable ? .black : .gray)
            .frame(width: FigmaDimens.fw(50), height: FigmaDimens.fh(30)) // Уже для компактности как в Kotlin
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 2) // Тоньше border
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isAvailable ? Color.white : Color.gray.opacity(0.2))
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if isAvailable {
                    onClick()
                }
            }
    }
    
    private var borderColor: Color {
        if isSelected {
            return AppTheme.blueButton
        } else if isAvailable {
            return Color.gray.opacity(0.5)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}