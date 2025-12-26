//
//  ProductImageCarousel.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct ProductImageCarousel: View {
    let images: [String] // Имена изображений из Assets
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            // Фон
            Color(hex: "E5E5E5") ?? Color.gray.opacity(0.2)
            
            // Карусель изображений
            if images.isEmpty || (images.count == 1 && images.first == "placeholder") {
                // Если нет изображений, показываем placeholder
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TabView(selection: $currentPage) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, imageName in
                        Group {
                            if imageName == "placeholder" {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray.opacity(0.5))
                            } else {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: currentPage) { _ in
                    // Синхронизация индикаторов при свайпе
                }
                
                // Индикатор страниц (кастомный, как в Kotlin)
                if images.count > 1 && !images.allSatisfy({ $0 == "placeholder" }) {
                    VStack {
                        Spacer()
                        
                        // Белый Box с индикаторами (как в Kotlin)
                        HStack(spacing: 6) {
                            ForEach(0..<images.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? AppTheme.blueButton : Color.gray.opacity(0.5))
                                    .frame(
                                        width: FigmaDimens.fw(6),
                                        height: FigmaDimens.fh(6)
                                    )
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.vertical, 4)
                        .frame(height: FigmaDimens.fh(8))
                        .background(
                            Color.white
                                .cornerRadius(6, corners: [.topLeft, .topRight])
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        )
                        .padding(.bottom, 0)
                    }
                }
            }
        }
    }
}

