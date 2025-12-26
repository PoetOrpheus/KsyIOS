//
//  SellerBlock.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct SellerBlock: View {
    let seller: Seller
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: FigmaDimens.fh(5))
            
            // Заголовок "Продавец"
            HStack {
                Text("Продавец")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, FigmaDimens.fw(25))
            .frame(height: FigmaDimens.fh(30))
            
            Spacer()
                .frame(height: FigmaDimens.fh(5))
            
            // Информация о продавце
            HStack(spacing: FigmaDimens.fw(10)) {
                // Аватар
                Group {
                    if let avatarUrl = seller.avatarUrl, let uiImage = UIImage(named: avatarUrl) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else if let uiImage = UIImage(named: "ava_seller") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
                .frame(
                    width: FigmaDimens.fw(40),
                    height: FigmaDimens.fh(40)
                )
                .clipShape(Circle())
                
                // Имя и ссылка
                VStack(alignment: .leading, spacing: 0) {
                    Text(seller.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(height: FigmaDimens.fh(35), alignment: .leading)
                    
                    Text("Перейти")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                }
                .frame(width: FigmaDimens.fw(230), alignment: .leading)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Рейтинг
                VStack(spacing: 0) {
                    Group {
                        if let uiImage = UIImage(named: "star_profile_menu") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.yellow)
                                .frame(
                                    width: FigmaDimens.fw(16),
                                    height: FigmaDimens.fh(16)
                                )
                        } else {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Text(String(format: "%.1f", seller.rating))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(
                    width: FigmaDimens.fw(40),
                    height: FigmaDimens.fh(40)
                )
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(15))
                
                // Чат
                VStack(spacing: 0) {
                    Group {
                        if let uiImage = UIImage(named: "chat_blue") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(
                                    width: FigmaDimens.fw(20),
                                    height: FigmaDimens.fh(16)
                                )
                        } else {
                            Image(systemName: "message.fill")
                                .font(.system(size: 14))
                        }
                    }
                    
                    Text("Чат")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(
                    width: FigmaDimens.fw(40),
                    height: FigmaDimens.fh(40)
                )
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
            }
            .padding(.horizontal, FigmaDimens.fw(15))
            .frame(height: FigmaDimens.fh(60))
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Нижняя панель со статистикой
            HStack {
                Spacer()
                
                Group {
                    if let uiImage = UIImage(named: "delivery") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(
                                width: FigmaDimens.fw(16),
                                height: FigmaDimens.fh(16)
                            )
                    } else {
                        Image(systemName: "box")
                            .font(.system(size: 12))
                    }
                }
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                Text("Заказов")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "727272") ?? .gray)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                Text(formatOrdersCount(seller.ordersCount))
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "727272") ?? .gray)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(30))
                
                Group {
                    if let uiImage = UIImage(named: "like_and_dislike") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(
                                width: FigmaDimens.fw(16),
                                height: FigmaDimens.fh(16)
                            )
                    } else {
                        Image(systemName: "hand.thumbsup")
                            .font(.system(size: 12))
                    }
                }
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                Text("Отзывов")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "727272") ?? .gray)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                Text("\(seller.reviewsCount)")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "727272") ?? .gray)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(25))
            }
        }
        .frame(height: FigmaDimens.fh(134))
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func formatOrdersCount(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fk", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
}

