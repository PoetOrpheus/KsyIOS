//
//  SettingsFavoriteRow.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct SettingsFavoriteRow: View {
    @State private var isInStockEnabled = false
    @State private var isSaleEnabled = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Левая часть: кнопки фильтр и категории
            Group {
                // Кнопка "Фильтр"
                Button(action: {
                    // TODO: Открыть фильтр
                }) {
                    ZStack {
                        Color.white
                            .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                            .cornerRadius(10)
                        
                        Group {
                            if let uiImage = UIImage(named: "filtr_setting") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: FigmaDimens.fw(18), height: FigmaDimens.fh(18))
                            } else {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                }
                
                Spacer().frame(width: FigmaDimens.fw(20))
                
                // Кнопка "Категории"
                Button(action: {
                    // TODO: Открыть категории
                }) {
                    ZStack {
                        Color.white
                            .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                            .cornerRadius(10)
                        
                        Group {
                            if let uiImage = UIImage(named: "category_favorite_setting") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: FigmaDimens.fw(18), height: FigmaDimens.fh(18))
                            } else {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                }
                
                Spacer().frame(width: FigmaDimens.fw(40))
            }
            
            // Правая часть: переключатели "В наличии" и "По скидке"
            Group {
                Text("В наличии")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "353535") ?? .black)
                
                Spacer().frame(width: FigmaDimens.fw(10))
                
                FavoriteSwitch(isOn: $isInStockEnabled)
                
                Spacer().frame(width: FigmaDimens.fw(20))
                
                Text("По скидке")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "353535") ?? .black)
                
                Spacer().frame(width: FigmaDimens.fw(10))
                
                FavoriteSwitch(isOn: $isSaleEnabled)
                
                Spacer() // Финальный Spacer для выравнивания
            }
        }
        .frame(height: FigmaDimens.fh(32))
        .padding(.horizontal, FigmaDimens.fw(15))
    }
}