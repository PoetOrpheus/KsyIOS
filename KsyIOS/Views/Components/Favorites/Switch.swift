//
//  Switch.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct CustomSwitch: View {
    @Binding var isOn: Bool
    
    init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            // Трек (фон переключателя)
            RoundedRectangle(cornerRadius: FigmaDimens.fh(30))
                .fill(Color.white)
                .frame(width: FigmaDimens.fw(46), height: FigmaDimens.fh(24))
                .overlay(
                    RoundedRectangle(cornerRadius: FigmaDimens.fh(30))
                        .stroke(isOn ? AppTheme.blueButton : Color(hex: "353535") ?? .gray, lineWidth: 2)
                )
            
            // Кружок (индикатор)
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
        .frame(width: FigmaDimens.fw(46), height: FigmaDimens.fh(24))
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}

