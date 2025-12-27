//
//  StartCardRow.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

struct StartCardRow: View {
    let rating: Double
    let reviewsCount: Int
    
    var body: some View {
        HStack(spacing: FigmaDimens.fw(10)) {
            // Рейтинг
            RatingCard(
                rating: rating,
                reviewsCount: reviewsCount
            )
            
            // Вопросы (заглушка)
            QuestionsCard()
            
            // Фотографии (заглушка)
            PicturesBlock()
        }
        .frame(height: FigmaDimens.fh(80))
        .frame(maxWidth: .infinity) // Как в Kotlin: fillMaxWidth()
        .background(Color.white)
        .cornerRadius(10)
    }
}

private struct RatingCard: View {
    let rating: Double
    let reviewsCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Group {
                    if let uiImage = UIImage(named: "star_profile_menu") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(
                                width: FigmaDimens.fw(22),
                                height: FigmaDimens.fh(22)
                            )
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                    }
                }
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Как в Kotlin: Box с width = fw(70), height = fh(35), contentAlignment = CenterStart
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 16, weight: .black))
                    .frame(width: FigmaDimens.fw(70), height: FigmaDimens.fh(35), alignment: .leading)
                    .foregroundColor(.black)
            }
            .frame(height: FigmaDimens.fh(35))
            
            Text(formatReviewsCount(reviewsCount))
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
        }
        .frame(width: FigmaDimens.fw(161), height: FigmaDimens.fh(60))
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
    }
    
    private func formatReviewsCount(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formattedCount = formatter.string(from: NSNumber(value: count)) ?? "\(count)"
        
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "\(formattedCount) отзыв"
        } else if lastDigit >= 2 && lastDigit <= 4 && (lastTwoDigits < 12 || lastTwoDigits > 14) {
            return "\(formattedCount) отзыва"
        } else {
            return "\(formattedCount) отзывов"
        }
    }
}

private struct QuestionsCard: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Group {
                    if let uiImage = UIImage(named: "question") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(
                                width: FigmaDimens.fw(14),
                                height: FigmaDimens.fh(22)
                            )
                    } else {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 14))
                    }
                }
                
                Spacer()
                    .frame(width: FigmaDimens.fw(10))
                
                // Количество вопросов (как в Kotlin: Box с width = fw(40), height = fh(35), alignment = CenterStart)
                Text("19")
                    .font(.system(size: 16, weight: .black))
                    .frame(width: FigmaDimens.fw(40), height: FigmaDimens.fh(35), alignment: .leading)
            }
            .frame(height: FigmaDimens.fh(35))
            
            Text("вопросов")
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
        }
        .frame(width: FigmaDimens.fw(90), height: FigmaDimens.fh(60))
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
    }
}

private struct PicturesBlock: View {
    let count: Int = 6
    
    var body: some View {
        ZStack {
            // Показываем 3 изображения с наложением и "+N"
            if count <= 1 {
                if let uiImage = UIImage(named: "watch_1") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: FigmaDimens.fw(60),
                            height: FigmaDimens.fh(60)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                }
            } else if count <= 4 {
                HStack(spacing: -FigmaDimens.fw(26)) {
                    ForEach(0..<min(count, 4), id: \.self) { index in
                        Group {
                            if let uiImage = UIImage(named: "watch_1") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(
                            width: FigmaDimens.fw(60),
                            height: FigmaDimens.fh(60)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: CGFloat(index) * FigmaDimens.fw(26))
                    }
                }
                .frame(width: FigmaDimens.fw(138), height: FigmaDimens.fh(60))
            } else {
                // Больше 4 изображений - показываем 3 и "+N"
                ZStack {
                    HStack(spacing: -FigmaDimens.fw(26)) {
                        ForEach(0..<3, id: \.self) { index in
                            Group {
                                if let uiImage = UIImage(named: "watch_1") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(
                                width: FigmaDimens.fw(60),
                                height: FigmaDimens.fh(60)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .offset(x: CGFloat(index) * FigmaDimens.fw(26))
                        }
                    }
                    
                    // Последнее изображение с затемнением и текстом "+N"
                    ZStack {
                        Group {
                            if let uiImage = UIImage(named: "watch_1") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .colorMultiply(Color.gray.opacity(0.7))
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        .frame(
                            width: FigmaDimens.fw(60),
                            height: FigmaDimens.fh(60)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: CGFloat(3) * FigmaDimens.fw(26))
                        
                        Text("+\(count - 3)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: CGFloat(3) * FigmaDimens.fw(26))
                    }
                }
                .frame(width: FigmaDimens.fw(138), height: FigmaDimens.fh(60))
            }
        }
        .frame(height: FigmaDimens.fh(60))
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
    }
}

