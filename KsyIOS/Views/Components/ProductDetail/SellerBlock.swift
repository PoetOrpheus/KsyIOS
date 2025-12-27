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
            
            // Заголовок
            HStack {
                Text("Продавец")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, FigmaDimens.fw(20)) // 20 для совпадения
            .frame(height: FigmaDimens.fh(30))
            
            Spacer()
                .frame(height: FigmaDimens.fh(5))
            
            // Информация
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Аватар — добавили clip
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
                .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(40))
                .clipShape(Circle())
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Имя
                VStack(alignment: .leading, spacing: 0) {
                    Text(seller.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: FigmaDimens.fh(35))
                    
                    Text("Перейти")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                }
                .frame(width: FigmaDimens.fw(200)) // Уменьшили для компактности
                
                Spacer()
                
                // Рейтинг
                VStack(spacing: 0) {
                    Group {
                        if let uiImage = UIImage(named: "star_profile_menu") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: FigmaDimens.fw(16), height: FigmaDimens.fh(16))
                        } else {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Text(String(format: "%.1f", seller.rating))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: FigmaDimens.fh(18))
                }
                .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(40))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Чат
                VStack(spacing: 0) {
                    Group {
                        if let uiImage = UIImage(named: "chat_blue") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: FigmaDimens.fw(20), height: FigmaDimens.fh(16))
                        } else {
                            Image(systemName: "message.fill")
                                .font(.system(size: 14))
                        }
                    }
                    
                    Text("Чат")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: FigmaDimens.fh(18))
                }
                .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(40))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, FigmaDimens.fw(10)) // Меньше padding
            .frame(height: FigmaDimens.fh(60))
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            // Статистика — выровняли слева, форматирование как в Kotlin (k для тысяч)
            HStack(spacing: FigmaDimens.fw(20)) { // Больше spacing
                OrdersStatGroup(ordersCount: seller.ordersCount)
                
                ReviewsStatGroup(reviewsCount: seller.reviewsCount)
                
                Spacer()
            }
            .padding(.horizontal, FigmaDimens.fw(20))
        }
        .frame(maxWidth: .infinity)
        .frame(height: FigmaDimens.fh(134))
        .background(Color.white)
        .cornerRadius(10)
    }
    
    static func formatOrdersCount(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fk", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
}

private struct OrdersStatGroup: View {
    let ordersCount: Int
    
    var body: some View {
        HStack(spacing: FigmaDimens.fw(8)) {
            Group {
                if let uiImage = UIImage(named: "delivery") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: FigmaDimens.fw(16), height: FigmaDimens.fh(16))
                } else {
                    Image(systemName: "box")
                        .font(.system(size: 12))
                }
            }
            
            Text("Заказов")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "727272") ?? .gray)
            
            Text(SellerBlock.formatOrdersCount(ordersCount))
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "727272") ?? .gray)
        }
    }
}

private struct ReviewsStatGroup: View {
    let reviewsCount: Int
    
    var body: some View {
        HStack(spacing: FigmaDimens.fw(8)) {
            Group {
                if let uiImage = UIImage(named: "like_and_dislike") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: FigmaDimens.fw(16), height: FigmaDimens.fh(16))
                } else {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 12))
                }
            }
            
            Text("Отзывов")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "727272") ?? .gray)
            
            Text("\(reviewsCount)")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "727272") ?? .gray)
        }
    }
}