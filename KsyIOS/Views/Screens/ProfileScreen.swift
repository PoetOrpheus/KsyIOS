//
//  ProfileScreen.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    let isLoggedIn: Bool
    let onLogin: () -> Void
    let onLogout: () -> Void
    
    @State private var showLogin = false
    
    var body: some View {
        VStack(spacing: 0) {
            TopHeaderWithoutSearch()
            
            Spacer()
                .frame(height: FigmaDimens.fh(10))
            
            if isLoggedIn {
                ScrollView {
                    VStack(spacing: FigmaDimens.fh(10)) {
                        // Профиль пользователя
                        Profile(
                            userProfileViewModel: userProfileViewModel,
                            onEditingClick: {
                                // Переход на экран редактирования
                            },
                            onLogout: onLogout
                        )
                        
                        // Меню профиля
                        ProfileMenu(
                            countSell: 23,
                            countFavorite: 4,
                            countReviews: 5,
                            onReviewClick: {
                                // Переход на отзывы
                            }
                        )
                        
                        // --- СЕКЦИЯ "МОЖНО ЗАБИРАТЬ" ---
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Можно забирать")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, FigmaDimens.fw(30))
                            
                            Spacer()
                                .frame(height: FigmaDimens.fh(10))
                            
                            CardPickUp()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, FigmaDimens.fw(30))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // --- СЕКЦИЯ "В ПУТИ" ---
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer()
                                .frame(height: FigmaDimens.fh(10))
                            
                            Text("В пути")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, FigmaDimens.fw(30))
                            
                            Spacer()
                                .frame(height: FigmaDimens.fh(10))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: FigmaDimens.fw(10)) {
                                    CardPickUp(
                                        productName: "Xiaomi Смартфон 15T + часы Xiaomi Watch",
                                        imageName: "image_for_product_2",
                                        stateDelivery: "9 декабря",
                                        stateColor: .black
                                    )
                                    
                                    CardPickUp(
                                        productName: "Часы наручные Кварцевые",
                                        imageName: "image_for_product_3",
                                        stateDelivery: "10 декабря",
                                        stateColor: .black
                                    )
                                    
                                    CardPickUp(
                                        productName: "Тестовый товар",
                                        imageName: "image_for_product_1",
                                        stateDelivery: "8 декабря",
                                        stateColor: .gray
                                    )
                                }
                                .padding(.horizontal, FigmaDimens.fw(30))
                            }
                        }
                        
                        // --- СЕКЦИЯ "История просмотров" ---
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        HistorySectionProduct()
                        
                        // --- НИЖНЕЕ МЕНЮ ---
                        Spacer()
                            .frame(height: FigmaDimens.fh(10))
                        
                        BottomProfileMenuNavigation()
                        
                        Spacer()
                            .frame(height: FigmaDimens.fw(30))
                    }
                }
            } else {
                // Экран входа
                ScrollView {
                    VStack(spacing: 24) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("Войдите в аккаунт")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text("Чтобы использовать все возможности приложения")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            onLogin()
                        }) {
                            Text("Войти")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppTheme.brandPurple)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color(hex: "F2F2F2") ?? AppTheme.backgroundLight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

