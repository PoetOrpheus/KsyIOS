//
//  SellerCard.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct SellerCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(width: FigmaDimens.fw(10))
            
            // Аватар продавца
            Group {
                if let uiImage = UIImage(named: "ava_seller") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: FigmaDimens.fw(40),
                            height: FigmaDimens.fh(40)
                        )
                        .clipped()
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(
                            width: FigmaDimens.fw(40),
                            height: FigmaDimens.fh(40)
                        )
                }
            }
            
            Spacer()
                .frame(width: FigmaDimens.fw(10))
            
            // Информация о продавце
            VStack(alignment: .leading, spacing: 0) {
                // Название продавца
                Text("Оператор замесов")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(height: FigmaDimens.fh(35), alignment: .topLeading)
                    .lineLimit(1)
                
                // Статистика
                HStack(alignment: .center, spacing: 0) {
                    // Иконка доставки
                    Group {
                        if let uiImage = UIImage(named: "delivery") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: FigmaDimens.fw(12),
                                    height: FigmaDimens.fh(12)
                                )
                        } else {
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(10))
                    
                    Text("Заказов")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "727272") ?? .gray)
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(10))
                    
                    Text("3.4k")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "727272") ?? .gray)
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(30))
                    
                    // Иконка отзывов
                    Group {
                        if let uiImage = UIImage(named: "like_and_dislike") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: FigmaDimens.fw(12),
                                    height: FigmaDimens.fh(12)
                                )
                        } else {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(10))
                    
                    Text("Отзывов")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "727272") ?? .gray)
                    
                    Spacer()
                        .frame(width: FigmaDimens.fw(10))
                    
                    Text("543")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "727272") ?? .gray)
                }
                .frame(height: FigmaDimens.fh(25))
            }
            .frame(width: FigmaDimens.fw(235), alignment: .leading)
            
            Spacer()
                .frame(width: FigmaDimens.fw(63))
            
            // Рейтинг
            VStack(spacing: 0) {
                if let uiImage = UIImage(named: "star_profile_menu") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: FigmaDimens.fw(12),
                            height: FigmaDimens.fh(12)
                        )
                } else {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                        .frame(
                            width: FigmaDimens.fw(12),
                            height: FigmaDimens.fh(12)
                        )
                }
                
                Text("4.9")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.black)
                    .frame(height: FigmaDimens.fh(18))
            }
            .frame(
                width: FigmaDimens.fw(40),
                height: FigmaDimens.fh(40)
            )
            .background(Color.white)
            .cornerRadius(5)
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 5,
                x: 0,
                y: 2
            )
            
            Spacer()
                .frame(width: FigmaDimens.fw(10))
        }
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

