//
//  CanBeSellerScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct CanBeSellerScreen: View {
    let onBackClick: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.bgGray
                .ignoresSafeArea()
            
            TopHeaderWithReturn(onBackClick: onBackClick)
                .zIndex(1)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: FigmaDimens.fh(10))
                    
                    // Изображение can_be_seller
                    Group {
                        if let uiImage = UIImage(named: "can_be_seller") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            // Placeholder если изображение не найдено
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Text("can_be_seller")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                }
            }
            .padding(.top, FigmaDimens.fh(60))
            .padding(.horizontal, FigmaDimens.fw(5))
        }
    }
}

