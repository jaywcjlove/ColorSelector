//
//  AlphaSlider.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public struct AlphaSlider: View {
    @Environment(\.pointSize) private var pointSize
    @Environment(\.cornerSize) private var cornerSize
    @Binding var alpha: CGFloat // 透明度 (0.0 到 1.0)
    var hue: CGFloat // 色相，用于显示渐变颜色
    var saturation: CGFloat // 饱和度，用于显示渐变颜色
    var brightness: CGFloat // 亮度，用于显示渐变颜色
    public init(
        alpha: Binding<CGFloat>,
        hue: CGFloat = 0,
        saturation: CGFloat = 1,
        brightness: CGFloat = 1,
    ) {
        self._alpha = alpha
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 透明度渐变条
                RoundedRectangle(cornerRadius: cornerSize)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 0.0), // 透明
                                Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 1.0) // 不透明
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(RoundedRectangle(cornerRadius: cornerSize).stroke(Color.secondary.opacity(0.37), lineWidth: 2))
                    .background(
                        // 添加棋盘格背景，增强透明效果
                        CheckerboardBackground(squareSize: 5)
                            .clipShape(RoundedRectangle(cornerRadius: cornerSize))
                            .opacity(0.45)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerSize))

                // 指示器
                Circle()
                    .fill(Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha))
                    .background(
                        CheckerboardBackground(squareSize: 5)
                            .clipShape(RoundedRectangle(cornerRadius: cornerSize))
                    )
                    .frame(width: pointSize.width, height: pointSize.height)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.37), lineWidth: 4))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(
                        x: min(max(alpha * geometry.size.width, pointSize.width / 2), geometry.size.width - pointSize.width / 2),
                        y: geometry.size.height / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 将触摸位置映射到透明度
                        let x = value.location.x
                        let width = geometry.size.width
                        alpha = min(max(x / width, 0), 1) // 限制在 0.0 到 1.0
                    }
            )
        }
        .frame(height: pointSize.height) // 固定高度，宽度自适应
    }
}


// 棋盘格背景（增强透明效果）
struct CheckerboardBackground: View {
    var squareSize: CGFloat = 3
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / squareSize) + 1
            let cols = Int(size.width / squareSize) + 1
            for row in 0..<rows {
                for col in 0..<cols {
                    let x = CGFloat(col) * squareSize
                    let y = CGFloat(row) * squareSize
                    let isEven = (row + col) % 2 == 0
                    let color = isEven ? Color(white: 0.9) : Color(white: 0.7)
                    context.fill(
                        Path(CGRect(x: x, y: y, width: squareSize, height: squareSize)),
                        with: .color(color)
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var saturation: CGFloat = 1.0
    @Previewable @State var brightness: CGFloat = 1.0
    @Previewable @State var hue: CGFloat = 0.0
    @Previewable @State var alpha: CGFloat = 1.0
    Text("\(alpha)")
    AlphaSlider(
        alpha: $alpha,
        hue: hue,
        saturation: saturation,
        brightness: brightness
    )
    .padding()
}
