//
//  VariantItemRow.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct VariantItemRow: View {
    let variants: [ProductVariant]
    let selectedVariantId: String?
    let onVariantSelected: (String) -> Void
    
    var body: some View {
        if !variants.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FigmaDimens.fw(15)) { // Ближе spacing как в кедах
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
                .padding(.horizontal, FigmaDimens.fw(20))
            }
            .frame(height: FigmaDimens.fh(120)) // Меньше общая высота
        }
    }
}

private struct VariantItem: View {
    let variant: ProductVariant
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(variant.isAvailable ? Color.clear : Color.gray.opacity(0.3))
                
                if let firstImageName = variant.getFirstImageRes(),
                   let uiImage = UIImage(named: firstImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text(variant.value)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            .frame(width: FigmaDimens.fw(80), height: FigmaDimens.fw(80)) // Квадрат как в Kotlin
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? AppTheme.blueButton : Color.gray.opacity(0.5), lineWidth: 2))
            
            Text(variant.value)
                .font(.system(size: 12)) // Больше шрифт
                .foregroundColor(variant.isAvailable ? .black : .gray)
        }
        .onTapGesture(perform: onClick)
    }
}