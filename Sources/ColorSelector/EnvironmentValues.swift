//
//  EnvironmentValues.swift
//  ColorSelector
//
//  Created by wong on 4/19/25.
//


#if canImport(SwiftUI)
import SwiftUI

private struct SwatchColorsKey: EnvironmentKey {
    static let defaultValue: [NSColor] = defaultSwatchColors
}
extension EnvironmentValues {
    var swatchColors: [NSColor] {
        get { self[SwatchColorsKey.self] }
        set { self[SwatchColorsKey.self] = newValue }
    }
}


private struct PointSizesKey: EnvironmentKey {
    static let defaultValue: CGSize = .init(width: 10, height: 10)
}
extension EnvironmentValues {
    var pointSize: CGSize {
        get { self[PointSizesKey.self] }
        set { self[PointSizesKey.self] = newValue }
    }
}


private struct CornerSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 5
}
extension EnvironmentValues {
    var cornerSize: CGFloat {
        get { self[CornerSizeKey.self] }
        set { self[CornerSizeKey.self] = newValue }
    }
}
#endif

