//
//  CounterCart.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct CounterCart: View {
    let count: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Кнопка декремента (минус)
            Button(action: onDecrement) {
                Text("—")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.black)
                    .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
            }
            
            // Количество
            Text("\(count)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(30))
            
            // Кнопка инкремента (плюс)
            Button(action: onIncrement) {
                Text("+")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.black)
                    .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
            }
        }
        .frame(width: FigmaDimens.fw(100), height: FigmaDimens.fh(30))
        .background(Color.white)
        .cornerRadius(50)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color(hex: "DCDCDC") ?? .gray, lineWidth: 1)
        )
    }
}

