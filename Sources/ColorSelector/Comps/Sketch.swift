//
//  Sketch.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

class SketchViewModel: ObservableObject {
    @Published var showsAlpha: Bool = true
    @Published var controlSize: ControlSize = .regular
}

public struct Sketch: View {
    @ObservedObject var viewModel: SketchViewModel = .init()
    @Environment(\.pointSize) private var pointSize
    @Binding var hue: CGFloat // 固定的色相 (0.0 到 1.0)
    @Binding var saturation: CGFloat // 饱和度 (0.0 到 1.0)
    @Binding var brightness: CGFloat // 亮度 (0.0 到 1.0)
    @Binding var alpha: CGFloat
    public init(
        hue: Binding<CGFloat>,
        saturation: Binding<CGFloat>,
        brightness: Binding<CGFloat>,
        alpha: Binding<CGFloat>,
    ) {
        self._hue = hue
        self._saturation = saturation
        self._brightness = brightness
        self._alpha = alpha
    }
    public var body: some View {
        VStack(spacing: 10) {
            Saturation(
                saturation: $saturation,
                brightness: $brightness,
                hue: hue
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                VStack {
                    HueSlider(hue: $hue)
                    if viewModel.showsAlpha == true {
                        AlphaSlider(
                            alpha: $alpha,
                            hue: hue,
                            saturation: saturation,
                            brightness: brightness
                        )
                    }
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
                let rectSize: CGFloat = pointSize.height * 2 + 6
                ColorSampler(color: bind) { value in
                    hue = value.hueComponent
                    saturation = value.saturationComponent
                    brightness = value.brightnessComponent
                    alpha = value.alphaComponent
                }
                .rectSize(viewModel.showsAlpha == true ? rectSize : pointSize.height)
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
    public func showsAlpha(_ value: Bool) -> some View {
        viewModel.showsAlpha = value
        return self
    }
    public func showsAlpha(_ value: Binding<Bool>) -> some View {
        viewModel.showsAlpha = value.wrappedValue
        return self
    }
}

#Preview {
    @Previewable @State var saturation: CGFloat = 1.0
    @Previewable @State var brightness: CGFloat = 1.0
    @Previewable @State var hue: CGFloat = 0.0
    @Previewable @State var alpha: CGFloat = 1.0
    
    @Previewable @State var cornerRadius: CGFloat = 6
    @Previewable @State var pointSize: CGSize = .init(width: 12, height: 12)
    HStack {
        Sketch(
            hue: $hue,
            saturation: $saturation,
            brightness: $brightness,
            alpha: $alpha
        )
        .frame(width: 180, height: 230)
        .environment(\.cornerSize, 3)
        Sketch(
            hue: $hue,
            saturation: $saturation,
            brightness: $brightness,
            alpha: $alpha
        )
        .showsAlpha(false)
        .environment(\.cornerSize, cornerRadius)
        .environment(\.pointSize, pointSize)
        .frame(width: 180, height: 230)
    }
    HStack {
        Sketch(
            hue: $hue,
            saturation: $saturation,
            brightness: $brightness,
            alpha: $alpha
        )
        .showsAlpha(false)
        .frame(width: 180, height: 230)
        .environment(\.cornerSize, 3)
        Sketch(
            hue: $hue,
            saturation: $saturation,
            brightness: $brightness,
            alpha: $alpha
        )
        .showsAlpha(false)
        .environment(\.cornerSize, cornerRadius)
        .environment(\.pointSize, pointSize)
        .frame(width: 180, height: 230)
    }
}
