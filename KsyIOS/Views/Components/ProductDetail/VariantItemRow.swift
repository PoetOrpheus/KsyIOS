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
                // Фон (как в Kotlin: Color.Transparent для доступных, Color.Gray для недоступных)
                RoundedRectangle(cornerRadius: 6)
                    .fill(variant.isAvailable ? Color.clear : Color.gray.opacity(0.3))
                
                if let firstImageName = variant.getFirstImageRes(),
                   let uiImage = UIImage(named: firstImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit() // Как в Kotlin: ContentScale.Fit - сохраняет пропорции, вписывает в контейнер
                } else {
                    // Если изображений нет, показываем текстовое значение
                    Text(variant.value)
                        .font(.system(size: 10))
                        .foregroundColor(variant.isAvailable ? .black : .gray)
                }
            }
            .frame(
                width: FigmaDimens.fw(70),
                height: FigmaDimens.fh(93)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6)) // Как в Kotlin: clip(RoundedCornerShape(6.dp))
            .overlay(
                RoundedRectangle(cornerRadius: 8) // Как в Kotlin: border с shape = RoundedCornerShape(8.dp)
                    .stroke(
                        borderColor,
                        lineWidth: 3
                    )
            )
            
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
        // Как в Kotlin: if (isSelected) BlueButton else if (variant.isAvailable) Color.LightGray else Color.Gray.copy(alpha = 0.5f)
        if isSelected {
            return AppTheme.blueButton
        } else if variant.isAvailable {
            return Color(white: 0.85) // Color.LightGray в Kotlin
        } else {
            return Color.gray.opacity(0.5)
        }
    }
}

