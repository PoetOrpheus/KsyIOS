//
//  BrandBlock.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct BrandBlock: View {
    let brand: Brand
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: FigmaDimens.fh(5))
            
            // Заголовок "Бренд" — выровняли слева с большим padding для совпадения с Kotlin
            HStack {
                Text("Бренд")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, FigmaDimens.fw(20)) // Уменьшили до 20 для идентичности
            .frame(height: FigmaDimens.fh(30))
            
            Spacer()
                .frame(height: FigmaDimens.fh(5))
            
            // Информация о бренде — убрали лишние spacers, ширину адаптировали
            HStack(spacing: FigmaDimens.fw(8)) { // spacing 8 для ближе к Kotlin
                // Логотип
                Group {
                    if let logoUrl = brand.logoUrl, let uiImage = UIImage(named: logoUrl) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else if let uiImage = UIImage(named: "calvin_clein") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "tag.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
                .frame(
                    width: FigmaDimens.fw(40),
                    height: FigmaDimens.fh(40)
                )
                
                // Название и ссылка
                VStack(alignment: .leading, spacing: 0) {
                    Text(brand.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: FigmaDimens.fh(35))
                    
                    Text("Перейти")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, FigmaDimens.fw(15))
            .frame(height: FigmaDimens.fh(60))
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Мягче shadow для Kotlin-style
        }
        .frame(maxWidth: .infinity)
        .frame(height: FigmaDimens.fh(110))
        .background(Color.white)
        .cornerRadius(10)
    }
}