//
//  Sketch.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public struct Sketch: View {
    @Binding var hue: CGFloat // 固定的色相 (0.0 到 1.0)
    @Binding var saturation: CGFloat // 饱和度 (0.0 到 1.0)
    @Binding var brightness: CGFloat // 亮度 (0.0 到 1.0)
    @Binding var alpha: CGFloat
    var cornerRadius: CGFloat = 6
    var pointSize: CGSize = .init(width: 8, height: 8)
    public init(
        hue: Binding<CGFloat>,
        saturation: Binding<CGFloat>,
        brightness: Binding<CGFloat>,
        alpha: Binding<CGFloat>,
        cornerRadius: CGFloat = 6,
        pointSize: CGSize = .init(width: 8, height: 8)
    ) {
        self._hue = hue
        self._saturation = saturation
        self._brightness = brightness
        self._alpha = alpha
        self.cornerRadius = cornerRadius
        self.pointSize = pointSize
    }
    public var body: some View {
        VStack(spacing: 10) {
            Saturation(
                saturation: $saturation,
                brightness: $brightness,
                hue: hue,
                cornerRadius: cornerRadius,
                pointSize: pointSize
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                VStack {
                    HueSlider(
                        hue: $hue,
                        cornerRadius: cornerRadius,
                        pointSize: pointSize
                    )
                    AlphaSlider(
                        alpha: $alpha,
                        hue: hue,
                        saturation: saturation,
                        brightness: brightness,
                        cornerRadius: cornerRadius,
                        pointSize: pointSize
                    )
                }
                let color = Color(
                    hue: hue,
                    saturation: saturation,
                    brightness: brightness,
                    opacity: alpha
                )
                let bind = Binding(get: { color }, set: { value in
                    hue = value.hue
                    saturation = value.saturation
                    brightness = value.brightness
                    alpha = value.alpha
                })
                ColorSampler(
                    color: bind,
                    cornerRadius: cornerRadius,
                    pointSize: pointSize
                ) { value in
                    hue = value.hueComponent
                    saturation = value.saturationComponent
                    brightness = value.brightnessComponent
                    alpha = value.alphaComponent
                }
            }
            let nsColor = NSColor(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            )
            Swatch(nsColor: nsColor) { value in
                hue = value.hueComponent
                saturation = value.saturationComponent
                brightness = value.brightnessComponent
                alpha = value.alphaComponent
            }
        }
        .padding(12)
    }
}


#Preview {
    @Previewable @State var saturation: CGFloat = 1.0
    @Previewable @State var brightness: CGFloat = 1.0
    @Previewable @State var hue: CGFloat = 0.0
    @Previewable @State var alpha: CGFloat = 1.0
    
    @Previewable @State var cornerRadius: CGFloat = 6
    @Previewable @State var pointSize: CGSize = .init(width: 8, height: 8)
    Sketch(
        hue: $hue,
        saturation: $saturation,
        brightness: $brightness,
        alpha: $alpha,
        cornerRadius: cornerRadius,
        pointSize: pointSize
    )
    .frame(width: 180, height: 230)
}
