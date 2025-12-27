//
//  TotalCountCart.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct TotalCountCart: View {
    let count: Int
    let countPrice: Int
    let salePrice: Int
    let finalPrice: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок "Заказ"
            HStack {
                Text("Заказ")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(height: FigmaDimens.fh(50))
            
            Spacer().frame(height: FigmaDimens.fh(10))
            
            // Товары
            ParameterTotal(
                text: "Товары (\(count))",
                price: countPrice,
                colorPrice: .black
            )
            
            Spacer().frame(height: FigmaDimens.fh(10))
            
            // Скидка
            ParameterTotal(
                text: "Скидка",
                price: salePrice,
                colorPrice: Color(hex: "CC3333") ?? .red
            )
            
            Spacer().frame(height: FigmaDimens.fh(10))
            
            // Разделительная линия
            Rectangle()
                .fill(Color(hex: "939393") ?? .gray)
                .frame(height: 2)
            
            Spacer().frame(height: FigmaDimens.fh(10))
            
            // Итого
            HStack {
                Text("Итого")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(finalPrice) ₽")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "50C878") ?? .green)
            }
            .frame(height: FigmaDimens.fh(40))
        }
        .padding(.horizontal, FigmaDimens.fw(40))
        .background(Color.white)
    }
}

private struct ParameterTotal: View {
    let text: String
    let price: Int
    let colorPrice: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("\(price) ₽")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(colorPrice)
        }
        .frame(height: FigmaDimens.fh(30))
    }
}

