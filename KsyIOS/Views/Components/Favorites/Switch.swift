//
//  Switch.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct FavoriteSwitch: View {
    @Binding var isOn: Bool
    
    var body: some View {
        // Внешний контейнер - как в Kotlin: Box с padding(3.dp)
        ZStack(alignment: .leading) {
            // Трек (фон переключателя) - border и background как в Kotlin
            RoundedRectangle(cornerRadius: FigmaDimens.fh(30))
                .fill(Color.white)
                .frame(width: FigmaDimens.fw(46), height: FigmaDimens.fh(24))
                .overlay(
                    RoundedRectangle(cornerRadius: FigmaDimens.fh(30))
                        .stroke(isOn ? AppTheme.blueButton : Color(hex: "353535") ?? .gray, lineWidth: 2)
                )
            
            // Внутренний контейнер с padding - как в Kotlin
            ZStack(alignment: .leading) {
                // Кружок (индикатор) - как в Kotlin: offset(x = if (checked) fw(20) else 0.dp)
                Circle()
                    .fill(isOn ? AppTheme.blueButton : Color(hex: "353535") ?? .gray)
                    .frame(width: FigmaDimens.fw(20), height: FigmaDimens.fh(20))
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: isOn ? FigmaDimens.fw(20) : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
            }
            .padding(3) // padding как в Kotlin: .padding(3.dp)
        }
        .frame(width: FigmaDimens.fw(46), height: FigmaDimens.fh(24))
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}

