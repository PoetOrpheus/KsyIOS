//
//  VariantItemRow.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct VariantItemRow: View {
    let variants: [ProductVariant]
    let selectedVariantId: String?
    let onVariantSelected: (String) -> Void
    
    var body: some View {
        if !variants.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FigmaDimens.fw(10)) {
                    ForEach(variants) { variant in
                        VariantItem(
                            variant: variant,
                            isSelected: variant.id == selectedVariantId,
                            onClick: {
                                if variant.isAvailable {
                                    onVariantSelected(variant.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 10) // Как в Kotlin: padding(horizontal = 10.dp)
            }
        }
    }
}

private struct VariantItem: View {
    let variant: ProductVariant
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Изображение варианта
            ZStack {
                if let firstImageName = variant.getFirstImageRes(),
                   let uiImage = UIImage(named: firstImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Если изображения нет, показываем текстовое значение
                    Text(variant.value)
                        .font(.system(size: 10))
                        .foregroundColor(variant.isAvailable ? .black : .gray)
                }
            }
            .frame(
                width: FigmaDimens.fw(70),
                height: FigmaDimens.fh(93)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        borderColor,
                        lineWidth: 3
                    )
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(variant.isAvailable ? Color.clear : Color.gray.opacity(0.3))
            )
            .cornerRadius(6)
            
            // Текст под изображением
            Text(variant.value)
                .font(.system(size: 8))
                .foregroundColor(variant.isAvailable ? .black : .gray)
                .frame(
                    width: FigmaDimens.fw(70),
                    height: FigmaDimens.fh(20)
                )
        }
        .frame(
            width: FigmaDimens.fw(70),
            height: FigmaDimens.fh(113)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if variant.isAvailable {
                onClick()
            }
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return AppTheme.blueButton
        } else if variant.isAvailable {
            return Color(white: 0.85)
        } else {
            return Color.gray.opacity(0.5)
        }
    }
}

