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
        HStack(spacing: FigmaDimens.fw(8)) { // Меньше spacing
            RatingCard(
                rating: rating,
                reviewsCount: reviewsCount
            )
            
            QuestionsCard()
            
            PicturesBlock()
        }
        .frame(height: FigmaDimens.fh(60)) // Уменьшили высоту
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
    }
}

private struct RatingCard: View {
    let rating: Double
    let reviewsCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: FigmaDimens.fw(8)) {
                Group {
                    if let uiImage = UIImage(named: "star_profile_menu") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: FigmaDimens.fw(22), height: FigmaDimens.fh(22))
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                    }
                }
                
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: FigmaDimens.fh(35))
            
            Text(formatReviewsCount(reviewsCount))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 10)
        .frame(width: FigmaDimens.fw(140), height: FigmaDimens.fh(60)) // Уже
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
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
            HStack(spacing: FigmaDimens.fw(8)) {
                Group {
                    if let uiImage = UIImage(named: "question") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: FigmaDimens.fw(14), height: FigmaDimens.fh(22))
                    } else {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 14))
                    }
                }
                
                Text("19")
                    .font(.system(size: 16, weight: .black))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: FigmaDimens.fh(35))
            
            Text("вопросов")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 10)
        .frame(width: FigmaDimens.fw(100), height: FigmaDimens.fh(60)) // Шире
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

private struct PicturesBlock: View {
    let count: Int = 6
    
    var body: some View {
        ZStack {
            if count <= 1 {
                if let uiImage = UIImage(named: "watch_1") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(60))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
            } else {
                HStack(spacing: 0) {
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
                        .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(60))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -CGFloat(index) * FigmaDimens.fw(30)) // Увеличили overlap до 30 для компактности как в Kotlin
                    }
                }
                .frame(width: FigmaDimens.fw(120), height: FigmaDimens.fh(60)) // Уже общая ширина
                
                if count > 4 {
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
                        .frame(width: FigmaDimens.fw(60), height: FigmaDimens.fh(60))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -CGFloat(3) * FigmaDimens.fw(30))
                        
                        Text("+\(count - 3)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: -CGFloat(3) * FigmaDimens.fw(30))
                    }
                }
            }
        }
        .frame(height: FigmaDimens.fh(60))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}