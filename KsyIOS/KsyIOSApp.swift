//
//  KsyIOSApp.swift
//  KsyIOS
//
//  Created by MAGNUM on 25.12.2025.
//

import SwiftUI

@main
struct KsyIOSApp: App {
    @State private var isLoading = true
    
    init() {
        // Устанавливаем цвет статус-бара (фиолетовый #5D76CB)
        setupStatusBar()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    SplashScreen(onLoadingComplete: {
                        isLoading = false
                    })
                } else {
                    MainScreen()
                }
            }
            .statusBarStyle(.lightContent)
            .statusBarBackground(UIColor(hex: 0x5D76CB))
        }
    }
    
    private func setupStatusBar() {
        // Устанавливаем цвет статус-бара при старте приложения
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            DispatchQueue.main.async {
                let statusBarFrame = windowScene.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.backgroundColor = UIColor(hex: 0x5D76CB)
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

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

