//
//  SizeVariants.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct SizeVariants: View {
    let sizes: [ProductSize]
    let selectedSizeId: String?
    let onSizeSelected: (String) -> Void
    
    var body: some View {
        if !sizes.isEmpty {
            HStack(spacing: FigmaDimens.fw(12)) {
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
                Spacer()
            }
            .padding(.horizontal, FigmaDimens.fw(20))
            .frame(height: FigmaDimens.fh(40))
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
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(isAvailable ? .black : .gray)
            .frame(width: FigmaDimens.fw(50), height: FigmaDimens.fh(40))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? AppTheme.blueButton : Color.gray.opacity(0.5), lineWidth: 2)) // Тоньше и больше radius
            .background(RoundedRectangle(cornerRadius: 12).fill(isAvailable ? Color.white : Color.gray.opacity(0.2)))
            .onTapGesture(perform: onClick)
    }
}