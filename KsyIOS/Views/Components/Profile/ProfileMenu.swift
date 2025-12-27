//
//  ProfileMenu.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI
import UIKit

struct ProfileMenu: View {
    let countSell: Int
    let countFavorite: Int
    let countReviews: Int
    let onPurchasesClick: () -> Void
    let onFavoritesClick: () -> Void
    let onReviewsClick: () -> Void
    
    var body: some View {
        HStack {
            // Покупки
            ProfileMenuItem(
                iconName: "profile_menu_sell",
                title: "Покупки",
                subtitle: "\(countSell) заказа",
                onClick: onPurchasesClick
            )
            
            Spacer()
                .frame(minWidth: FigmaDimens.fw(8))
            
            // Избранное
            ProfileMenuItem(
                iconName: "lover",
                title: "Избранное",
                subtitle: "\(countFavorite) товаров",
                onClick: onFavoritesClick
            )
            
            Spacer()
                .frame(minWidth: FigmaDimens.fw(8))
            
            // Ждут отзыва
            ProfileMenuItem(
                iconName: "star_profile_menu",
                title: "Ждут отзыва",
                subtitle: "\(countReviews) товаров",
                onClick: onReviewsClick
            )
        }
        .frame(height: FigmaDimens.fh(90))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, FigmaDimens.fw(15))
    }
}

struct ProfileMenuItem: View {
    let iconName: String
    let title: String
    let subtitle: String
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: FigmaDimens.fh(2)) {
                // Иконка
                Group {
                    if let uiImage = UIImage(named: iconName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 20, height: 20)
                
                // Заголовок
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .lineSpacing(12 - 11)
                
                // Подзаголовок
                Text(subtitle)
                    .font(.system(size: 8, weight: .light))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .lineSpacing(10 - 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .frame(width: FigmaDimens.fw(120), height: FigmaDimens.fh(70))
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
    }
}

