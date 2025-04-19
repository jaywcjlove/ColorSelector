//
//  Saturation.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public struct Saturation: View {
    @Environment(\.pointSize) private var pointSize
    @Environment(\.cornerSize) private var cornerSize
    @Binding var saturation: CGFloat // 饱和度 (0.0 到 1.0)
    @Binding var brightness: CGFloat // 亮度 (0.0 到 1.0)
    var hue: CGFloat // 固定的色相 (0.0 到 1.0)
    public init(
        saturation: Binding<CGFloat>,
        brightness: Binding<CGFloat>,
        hue: CGFloat = 0
    ) {
        self._saturation = saturation
        self._brightness = brightness
        self.hue = hue
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cornerSize, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hue: hue, saturation: 0, brightness: 1),
                                Color(hue: hue, saturation: 1, brightness: 1)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerSize, style: .continuous)
                            .stroke(Color.secondary.opacity(0.26), lineWidth: 2)
                    )
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.white, location: 0.0), // 顶部：白色
                                .init(color: Color(white: 0.6, opacity: 0.5), location: 0.4), // 中间：半透明灰色
                                .init(color: Color(white: 0.05), location: 1.0) // 底部：浅灰色
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .blendMode(.multiply)
                        //.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .mask(RoundedRectangle(cornerRadius: cornerSize, style: .continuous))
                    )
                // 显示当前选择的颜色指示器
                Circle()
                    .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
                    .frame(width: pointSize.width, height: pointSize.height)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.37), lineWidth: 4))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(
                        x: saturation * geometry.size.width,
                        y: (1 - brightness) * geometry.size.height
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 将触摸位置映射到饱和度和亮度
                        let x = value.location.x
                        let y = value.location.y
                        let width = geometry.size.width
                        let height = geometry.size.height

                        // 限制范围并计算饱和度和亮度
                        saturation = min(max(x / width, 0), 1)
                        brightness = 1 - min(max(y / height, 0), 1) // 亮度从上到下递减
                    }
            )
        }
        //.aspectRatio(1, contentMode: .fit) // 保持正方形
    }
}

#Preview {
    @Previewable @State var saturation: CGFloat = 1.0
    @Previewable @State var brightness: CGFloat = 1.0
    @Previewable @State var hue: CGFloat = 0.0
    Saturation(
        saturation: $saturation,
        brightness: $brightness,
        hue: hue
    )
    .frame(width: 200, height: 200)
    .padding(.top)
    Saturation(
        saturation: $saturation,
        brightness: $brightness,
        hue: hue
    )
    .frame(width: 200, height: 120)
    .padding()
}
