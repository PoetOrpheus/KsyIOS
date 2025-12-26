//
//  StatusBarBackground.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

// Модификатор для установки фона статус-бара
struct StatusBarBackgroundModifier: ViewModifier {
    var color: UIColor
    
    func body(content: Content) -> some View {
        content.onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.statusBarManager?.isStatusBarHidden = false
                // Устанавливаем цвет фона статус-бара
                let statusBarFrame = windowScene.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.backgroundColor = color
                statusBarView.tag = 9999
                
                // Удаляем старую view если есть
                windowScene.windows.first?.viewWithTag(9999)?.removeFromSuperview()
                
                // Добавляем новую view
                if let window = windowScene.windows.first {
                    window.addSubview(statusBarView)
                }
            }
        }
    }
}

extension View {
    func statusBarBackground(_ color: UIColor) -> some View {
        self.modifier(StatusBarBackgroundModifier(color: color))
    }
}

