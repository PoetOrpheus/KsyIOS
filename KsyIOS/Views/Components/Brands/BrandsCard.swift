//
//  BrandsCard.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct BrandsCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(width: FigmaDimens.fw(10))
            
            // Логотип бренда
            Group {
                if let uiImage = UIImage(named: "calvin_clein") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: FigmaDimens.fw(40),
                            height: FigmaDimens.fh(40)
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(
                            width: FigmaDimens.fw(40),
                            height: FigmaDimens.fh(40)
                        )
                }
            }
            
            Spacer()
                .frame(width: FigmaDimens.fw(10))
            
            // Информация о бренде
            VStack(alignment: .leading, spacing: 0) {
                // Название бренда
                Text("Calvin Klein")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(height: FigmaDimens.fh(35), alignment: .topLeading)
                    .lineLimit(1)
                
                Text("Перейти")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(height: FigmaDimens.fh(25), alignment: .bottomLeading)
            }
            .frame(width: FigmaDimens.fw(230), alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, FigmaDimens.fw(15))
        .frame(height: FigmaDimens.fh(60))
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(
            color: Color.black.opacity(0.3),
            radius: 5,
            x: 0,
            y: 2
        )
    }
}

