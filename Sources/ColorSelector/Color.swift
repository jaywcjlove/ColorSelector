//
//  Color.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import AppKit
import SwiftUICore

extension Color {
    var toNSColor: NSColor? {
        let cgColor = NSColor(self).cgColor
        return NSColor(cgColor: cgColor)
    }
    var alpha: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 1
        nsColor?.getHue(nil, saturation: nil, brightness: nil, alpha: &value)
        return value
    }
    var hue: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(&value, saturation: nil, brightness: nil, alpha: nil)
        return value
    }
    var saturation: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(nil, saturation: &value, brightness: nil, alpha: nil)
        return value
    }
    var brightness: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(nil, saturation: nil, brightness: &value, alpha: nil)
        return value
    }
    func contrastingColor(lightColor: NSColor = .white, darkColor: NSColor = .black, threshold: CGFloat = 0.5) -> Color? {
        let nsColor = self.toNSColor
        guard let nsColor = nsColor?.contrastingColor(lightColor: lightColor, darkColor: darkColor, threshold: threshold) else { return nil }
        return Color(nsColor: nsColor)
    }
}

extension NSColor {
    var alpha: CGFloat {
        var value: CGFloat = 1
        self.getHue(nil, saturation: nil, brightness: nil, alpha: &value)
        return value
    }
    func isEqual(to other: NSColor?) -> Bool {
        guard let color1InSRGB = self.usingColorSpace(.sRGB),
              let color2InSRGB = other?.usingColorSpace(.sRGB) else {
            return false
        }
        
        return color1InSRGB.redComponent == color2InSRGB.redComponent &&
               color1InSRGB.greenComponent == color2InSRGB.greenComponent &&
               color1InSRGB.blueComponent == color2InSRGB.blueComponent &&
               color1InSRGB.alphaComponent == color2InSRGB.alphaComponent
    }
    // 计算感知亮度
    var luminance: CGFloat? {
        // 确保颜色在 sRGB 颜色空间
        guard let sRGBColor = self.usingColorSpace(.sRGB),
              let components = sRGBColor.cgColor.components else {
            return nil
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        // 感知亮度公式 (ITU-R BT.709)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    // 根据亮度返回亮色或暗色
    func contrastingColor(lightColor: NSColor = .white, darkColor: NSColor = .black, threshold: CGFloat = 0.5) -> NSColor? {
        guard let luminance = self.luminance else { return nil }
        // 如果亮度高于阈值，返回暗色；否则返回亮色
        return luminance > threshold ? darkColor : lightColor
    }
}
