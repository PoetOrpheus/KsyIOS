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
    
    @State private var statusBarHeight: CGFloat = 0
    
    var body: some View {
        let headerHeight = FigmaDimens.fh(60)
        let _ = print("🟡 TopHeaderWithReturn: body rendered, height will be: \(headerHeight), statusBarHeight: \(statusBarHeight)")
        
        return VStack(spacing: 0) {
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
                                    // Без renderingMode - используем оригинальную иконку как в Kotlin
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
            // Фон для всей области (status bar + header)
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
            // Получаем высоту status bar при появлении view
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let height = windowScene.statusBarManager?.statusBarFrame.height ?? 0
                statusBarHeight = height
                print("✅ TopHeaderWithReturn: appeared on screen, statusBarHeight set to: \(height), total height: \(headerHeight + height)")
            } else {
                // Fallback значение для iPhone с notch (обычно ~47 points)
                statusBarHeight = 47
                print("✅ TopHeaderWithReturn: appeared on screen, using fallback statusBarHeight: 47, total height: \(headerHeight + 47)")
            }
        }
        .onDisappear {
            print("❌ TopHeaderWithReturn: disappeared from screen")
        }
        .ignoresSafeArea(edges: .top) // Расширяем градиент на status bar
    }
}

private struct IconHeader: View {
    let iconName: String
    
    var body: some View {
        ZStack {
            Color.white
                .frame(width: FigmaDimens.fw(35), height: FigmaDimens.fh(35))
                .cornerRadius(10)
            
            Group {
                if let uiImage = UIImage(named: iconName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: FigmaDimens.fw(25), height: FigmaDimens.fh(25)) // Меньше размер для аккуратности
                } else {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
            }
        }
        .frame(width: FigmaDimens.fw(35), height: FigmaDimens.fh(35))
    }
}

