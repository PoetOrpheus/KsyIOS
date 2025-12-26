//
//  FigmaDimens.swift
//  KsyIOS
//
//  Created by Auto on 25.12.2025.
//

import SwiftUI

// Базовый размер листа в Figma: 450 x 900
private let FIGMA_WIDTH: CGFloat = 450
private let FIGMA_HEIGHT: CGFloat = 900

/**
 * Преобразует ширину из макета Figma (450px) в точки текущего экрана.
 *
 * Пример:
 *  - в Figma блок шириной 450px → fw(450, geometry) даст ширину = ширине экрана
 *  - если блок 220px → fw(220, geometry) вернёт пропорциональную ширину под устройство
 */
struct FigmaDimens {
    static func fw(_ px: CGFloat, geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let k = screenWidth / FIGMA_WIDTH
        return px * k
    }
    
    static func fh(_ px: CGFloat, geometry: GeometryProxy) -> CGFloat {
        let screenHeight = geometry.size.height
        let k = screenHeight / FIGMA_HEIGHT
        return px * k
    }
    
    static func fw(_ px: Int, geometry: GeometryProxy) -> CGFloat {
        return fw(CGFloat(px), geometry: geometry)
    }
    
    static func fh(_ px: Int, geometry: GeometryProxy) -> CGFloat {
        return fh(CGFloat(px), geometry: geometry)
    }
}

