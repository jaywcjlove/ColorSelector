//
//  HueSlider.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

// Hue Slider 视图
public struct HueSlider: View {
    @Binding var hue: CGFloat // 色相 (0.0 到 1.0)
    var cornerRadius: CGFloat = 6
    var pointSize: CGSize = .init(width: 8, height: 8)
    public init(
        hue: Binding<CGFloat>,
        cornerRadius: CGFloat = 6,
        pointSize: CGSize = .init(width: 8, height: 8)
    ) {
        self._hue = hue
        self.cornerRadius = cornerRadius
        self.pointSize = pointSize
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 色相渐变条
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hue: 0.0, saturation: 1, brightness: 1), // 红
                                Color(hue: 0.167, saturation: 1, brightness: 1), // 橙
                                Color(hue: 0.333, saturation: 1, brightness: 1), // 黄
                                Color(hue: 0.5, saturation: 1, brightness: 1), // 绿
                                Color(hue: 0.667, saturation: 1, brightness: 1), // 青
                                Color(hue: 0.833, saturation: 1, brightness: 1), // 蓝
                                Color(hue: 1.0, saturation: 1, brightness: 1) // 紫/红
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.secondary.opacity(0.37), lineWidth: 2))
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                // 指示器
                Circle()
                    .fill(Color(hue: hue, saturation: 1, brightness: 1))
                    .frame(width: pointSize.width, height: pointSize.height)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.37), lineWidth: 4))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(
                        x: min(max(hue * geometry.size.width, pointSize.width / 2), geometry.size.width - pointSize.width / 2),
                        y: geometry.size.height / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 将触摸位置映射到色相
                        let x = value.location.x
                        let width = geometry.size.width
                        hue = min(max(x / width, 0), 1) // 限制在 0.0 到 1.0
                    }
            )
        }
        .frame(height: pointSize.height) // 固定高度，宽度自适应
    }
}


#Preview {
    @Previewable @State var hue: CGFloat = 1
    HueSlider(hue: $hue)
        .frame(width: 200)
        .padding()
}
