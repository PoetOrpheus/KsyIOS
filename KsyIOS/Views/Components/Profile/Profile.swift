//
//  Profile.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    let onEditingClick: () -> Void
    let onLogout: () -> Void
    
    var body: some View {
        let profile = userProfileViewModel.getCurrentProfile()
        
        HStack(spacing: FigmaDimens.fw(10)) {
            // Блок с информацией
            HStack(spacing: 0) {
                // Аватар
                Group {
                    if let avatarRes = profile.avatarRes, let uiImage = UIImage(named: avatarRes) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        // Дефолтный аватар или инициалы
                        ZStack {
                            Color(hex: "5D76CB")?.opacity(0.2) ?? AppTheme.blueButton.opacity(0.2)
                            Text(profile.getShortName())
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.blueButton)
                        }
                    }
                }
                .frame(width: FigmaDimens.fw(110), height: FigmaDimens.fh(100))
                .clipped()
                .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                
                // Информация о пользователе
                VStack(alignment: .leading, spacing: 0) {
                    // Имя и Фамилия
                    VStack(alignment: .leading, spacing: 0) {
                        ProfileInfo(
                            text: !profile.displayName.isEmpty ? profile.displayName : (profile.getFullName().isEmpty ? "Пользователь" : profile.getFullName()),
                            size: 20,
                            lineHeight: 22,
                            weight: .semibold
                        )
                    }
                    .frame(height: FigmaDimens.fh(35))
                    
                    // Номер телефона
                    ProfileInfo(
                        text: !profile.phone.isEmpty ? profile.phone : "Не указан",
                        size: 10,
                        lineHeight: 12
                    )
                    
                    // Почта
                    ProfileInfo(
                        text: !profile.email.isEmpty ? profile.email : "Не указана",
                        size: 10,
                        lineHeight: 12
                    )
                    
                    // Редактировать
                    ProfileInfo(
                        text: "Редактировать",
                        size: 10,
                        lineHeight: 12,
                        color: Color(hex: "5D76CB") ?? AppTheme.blueButton,
                        onClick: onEditingClick
                    )
                }
                .padding(.horizontal, FigmaDimens.fw(20))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: FigmaDimens.fw(340), height: FigmaDimens.fh(100))
            .background(Color.white)
            .cornerRadius(10)
            
            // Блок с выходом
            Button(action: onLogout) {
                VStack {
                    Spacer()
                    
                    // Иконка выхода
                    Group {
                        if let uiImage = UIImage(named: "exit_from_profile") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                        }
                    }
                    .frame(width: FigmaDimens.fw(30), height: FigmaDimens.fh(30))
                    
                    // Текст "Выйти из аккаунта"
                    Text("Выйти из аккаунта")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(height: FigmaDimens.fh(50))
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(hex: "5D76CB") ?? AppTheme.blueButton)
            .cornerRadius(10)
        }
        .frame(height: FigmaDimens.fh(100))
        .padding(.horizontal, FigmaDimens.fw(15))
    }
}

struct ProfileInfo: View {
    let text: String
    let size: CGFloat
    let lineHeight: CGFloat
    let weight: Font.Weight
    let color: Color
    let onClick: (() -> Void)?
    
    init(
        text: String,
        size: CGFloat = 10,
        lineHeight: CGFloat = 12,
        weight: Font.Weight = .light,
        color: Color = .black,
        onClick: (() -> Void)? = nil
    ) {
        self.text = text
        self.size = size
        self.lineHeight = lineHeight
        self.weight = weight
        self.color = color
        self.onClick = onClick
    }
    
    var body: some View {
        if let onClick = onClick {
            Button(action: onClick) {
                Text(text)
                    .font(.system(size: size, weight: weight))
                    .foregroundColor(color)
                    .lineSpacing(lineHeight - size)
            }
        } else {
            Text(text)
                .font(.system(size: size, weight: weight))
                .foregroundColor(color)
                .lineSpacing(lineHeight - size)
        }
    }
}

