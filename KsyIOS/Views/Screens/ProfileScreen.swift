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
        ScrollView {
            VStack(spacing: 20) {
                if isLoggedIn {
                    // Профиль пользователя
                    VStack(spacing: 16) {
                        // Аватар
                        Circle()
                            .fill(AppTheme.brandPurple.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(userProfileViewModel.getCurrentProfile().getShortName())
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(AppTheme.brandPurple)
                            )
                        
                        // Имя
                        Text(userProfileViewModel.getCurrentProfile().getFullName())
                            .font(.system(size: 24, weight: .bold))
                        
                        // Email
                        if !userProfileViewModel.getCurrentProfile().email.isEmpty {
                            Text(userProfileViewModel.getCurrentProfile().email)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        // Телефон
                        if !userProfileViewModel.getCurrentProfile().phone.isEmpty {
                            Text(userProfileViewModel.getCurrentProfile().phone)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                    
                    // Меню
                    VStack(spacing: 12) {
                        ProfileMenuItem(
                            icon: "person.circle",
                            title: "Редактировать профиль",
                            action: {
                                // Переход на экран редактирования
                            }
                        )
                        
                        ProfileMenuItem(
                            icon: "clock",
                            title: "История заказов",
                            action: {
                                // Переход на историю
                            }
                        )
                        
                        ProfileMenuItem(
                            icon: "star",
                            title: "Мои отзывы",
                            action: {
                                // Переход на отзывы
                            }
                        )
                        
                        ProfileMenuItem(
                            icon: "gear",
                            title: "Настройки",
                            action: {
                                // Переход на настройки
                            }
                        )
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        ProfileMenuItem(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: "Выйти",
                            action: onLogout
                        )
                    }
                    .padding(.horizontal, 16)
                } else {
                    // Экран входа
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
                            // Простая авторизация для демонстрации
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
                }
            }
            .padding(.bottom, 32)
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.brandPurple)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

