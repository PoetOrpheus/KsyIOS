//
//  TopHeaderWithReturn.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct TopHeaderWithReturn: View {
    let onBackClick: () -> Void
    
    var body: some View {
        let headerHeight = FigmaDimens.fh(60)
        let _ = print("🟡 TopHeaderWithReturn: body rendered, height will be: \(headerHeight)")
        
        return GeometryReader { geometry in
            let statusBarHeight = geometry.safeAreaInsets.top
            let _ = print("🟡 TopHeaderWithReturn: statusBarHeight from GeometryReader: \(statusBarHeight)")
            
            VStack(spacing: 0) {
                // Отступ для status bar
                Spacer()
                    .frame(height: statusBarHeight)
                
                // Контент header
                HStack(alignment: .center, spacing: 0) {
                    // Кнопка назад (как в Kotlin: Box с width/height и clickable)
                    Button(action: {
                        print("🔴 TopHeaderWithReturn: Back button tapped")
                        onBackClick()
                    }) {
                        Group {
                            if let uiImage = UIImage(named: "return_icon") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(
                                        width: FigmaDimens.fw(30),
                                        height: FigmaDimens.fh(30)
                                    )
                            } else {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(
                                        width: FigmaDimens.fw(30),
                                        height: FigmaDimens.fh(30)
                                    )
                            }
                        }
                    }
                    .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                    
                    Spacer()
                    
                    // Иконки справа (как в Kotlin: Row с padding horizontal = fw(15), vertical = fh(10))
                    HStack(spacing: FigmaDimens.fw(15)) {
                        IconHeader(iconName: "question_header_section")
                        IconHeader(iconName: "share")
                        IconHeader(iconName: "lover_for_header_section")
                    }
                    .padding(.horizontal, FigmaDimens.fw(15))
                    .padding(.vertical, FigmaDimens.fh(10))
                }
                .frame(maxWidth: .infinity)
                .frame(height: headerHeight) // Высота только контента header (без status bar)
                .padding(.horizontal, FigmaDimens.fw(10)) // Padding как в Kotlin: horizontal = fw(10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "5D76CB") ?? .blue,
                            Color(hex: "FCB4D5") ?? .pink
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .clipped() // Обрезаем содержимое по углам
            }
            .frame(maxWidth: .infinity)
            .frame(height: headerHeight + statusBarHeight) // Общая высота: header + status bar
            .background(
                // Фон для области status bar (верхняя часть)
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "5D76CB") ?? .blue,
                        Color(hex: "FCB4D5") ?? .pink
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .onAppear {
                print("✅ TopHeaderWithReturn: appeared on screen, frame should be visible")
            }
            .onDisappear {
                print("❌ TopHeaderWithReturn: disappeared from screen")
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .top) // Расширяем градиент на status bar
    }
}

private struct IconHeader: View {
    let iconName: String
    
    var body: some View {
        Group {
            if let uiImage = UIImage(named: iconName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .frame(
                        width: FigmaDimens.fw(35),
                        height: FigmaDimens.fh(35)
                    )
            } else {
                Image(systemName: "circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(
                        width: FigmaDimens.fw(35),
                        height: FigmaDimens.fh(35)
                    )
            }
        }
        .frame(
            width: FigmaDimens.fw(35),
            height: FigmaDimens.fh(35)
        )
        .background(Color.white)
        .cornerRadius(10)
    }
}

