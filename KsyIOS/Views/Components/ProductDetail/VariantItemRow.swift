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
                HStack(spacing: FigmaDimens.fw(8)) { // Меньше spacing
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
                .padding(.horizontal, 15)
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
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(variant.isAvailable ? Color.clear : Color.gray.opacity(0.3))
                
                if let firstImageName = variant.getFirstImageRes(),
                   let uiImage = UIImage(named: firstImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text(variant.value)
                        .font(.system(size: 12)) // Больше шрифт
                        .foregroundColor(variant.isAvailable ? .black : .gray)
                }
            }
            .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(80)) // Меньше высота для компактности
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor, lineWidth: 2) // Тоньше
            )
            
            Text(variant.value)
                .font(.system(size: 10)) // Больше 10pt
                .foregroundColor(variant.isAvailable ? .black : .gray)
                .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(20))
        }
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