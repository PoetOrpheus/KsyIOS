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
        }
    }
}
