//
//  TopHeaderWithoutSearch.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct TopHeaderWithoutSearch: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "5D76CB") ?? .blue,
                    Color(hex: "FCB4D5") ?? .pink
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                HStack {
                    Text("ПВЗ: ул. Королева, 5")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Group {
                        if let uiImage = UIImage(named: "message_without_notification") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "message")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(30))
                }
                .padding(.horizontal, FigmaDimens.fw(15))
                .padding(.top, FigmaDimens.fh(10))
                
                Spacer()
            }
        }
        .frame(height: FigmaDimens.fh(50))
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    }
}

