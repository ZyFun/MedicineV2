//
//  UIImage+GraphicsImageRenderer.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 23.10.2022.
//

import UIKit

extension UIImage {
    
    /// Метод закрашивает изображение с помощью рендера
    /// - Используется для закраски изображений в Swipe Actions
    func colored(with color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
            color.set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
    
    /// Метод рисует круг для изображения
    /// - Используется для  Swipe Actions
    func addBackgroundCircle(color: UIColor?, diameter: Double) -> UIImage? {
//        let circleDiameter = max(size.width * 1.8, size.height * 1.8) // расчет в зависимости от размеров изображения
        let circleRadius = diameter * 0.5
        let circleSize = CGSize(width: diameter, height: diameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(
            x: circleRadius - (size.width * 0.5),
            y: circleRadius - (size.height * 0.5),
            width: size.width,
            height: size.height
        )

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .clear
        view.layer.cornerRadius = diameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { _ in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
    
}
