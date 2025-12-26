//
//  StatusBarModifier.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI
import UIKit

// UIViewController для управления стилем статус-бара
class StatusBarStyleViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

struct StatusBarStyleView: UIViewControllerRepresentable {
    var style: UIStatusBarStyle
    
    func makeUIViewController(context: Context) -> StatusBarStyleViewController {
        let controller = StatusBarStyleViewController()
        controller.statusBarStyle = style
        return controller
    }
    
    func updateUIViewController(_ uiViewController: StatusBarStyleViewController, context: Context) {
        uiViewController.statusBarStyle = style
        uiViewController.setNeedsStatusBarAppearanceUpdate()
    }
}

extension View {
    func statusBarStyle(_ style: UIStatusBarStyle = .lightContent) -> some View {
        self.background(StatusBarStyleView(style: style))
    }
}
