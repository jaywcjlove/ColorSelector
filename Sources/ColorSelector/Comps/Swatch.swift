//
//  Swatch.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public let defaultSwatchColors: [NSColor] = [
    NSColor(hue: 0.999, saturation: 0.857, brightness: 0.878, alpha: 1.0),
    NSColor(hue: 0.066, saturation: 1.000, brightness: 0.980, alpha: 1.0),
    NSColor(hue: 0.121, saturation: 0.976, brightness: 0.969, alpha: 1.0),
    NSColor(hue: 0.247, saturation: 0.981, brightness: 0.827, alpha: 1.0),
    NSColor(hue: 0.462, saturation: 0.679, brightness: 0.843, alpha: 1.0),
    NSColor(hue: 0.547, saturation: 0.800, brightness: 1.000, alpha: 1.0),
    NSColor(hue: 0.573, saturation: 0.984, brightness: 1.000, alpha: 1.0),
    NSColor(hue: 0.703, saturation: 0.788, brightness: 1.000, alpha: 1.0),
    NSColor(hue: 0.797, saturation: 0.862, brightness: 0.878, alpha: 1.0),
    NSColor(hue: 0.597, saturation: 0.099, brightness: 0.475, alpha: 1.0),
    NSColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.1),
    NSColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.25),
    NSColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5),
    NSColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.75),
    NSColor(hue: 0, saturation: 0, brightness: 0, alpha: 1.0),
    NSColor(hue: 0, saturation: 0, brightness: 1, alpha: 1.0),
]

public struct Swatch: View {
    @Environment(\.swatchColors) private var swatchColors
    @State private var width: CGFloat = 0
    var nsColor: NSColor? = NSColor.clear
    var size: CGSize = .init(width: 14, height: 14)
    var spacing: CGFloat = 4 // 间距，从原始代码提取
    var onColorSelected: ((NSColor) -> Void)?
    public init(
        nsColor: NSColor? = NSColor.clear,
        size: CGSize = .init(width: 14, height: 14),
        spacing: CGFloat = 4,
        onColorSelected: ((NSColor) -> Void)? = nil
    ) {
        self.width = width
        self.nsColor = nsColor
        self.size = size
        self.spacing = spacing
        self.onColorSelected = onColorSelected
    }
    public var body: some View {
        ZStack {
            Color.clear
                .frame(height: 0)
                .frame(maxWidth: .infinity)
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                    }
                )
            LazyVGrid(
                columns: makeGridItems(for: width),
                spacing: spacing
            ) {
                ForEach(swatchColors, id: \.self) { item in
                    Button(action: {
                        onColorSelected?(item)
                    }, label: {
                        let active = item.isEqual(to: self.nsColor)
                        let border = borderColor(nsColor: item)
                        RoundedRectangle(cornerRadius: size.width * 0.3)
                            .fill(Color(nsColor: item))
                            .stroke(active ? Color.accentColor : Color.clear, lineWidth: 2)
                            .stroke(border.opacity(0.13), lineWidth: 1)
                            .frame(width: size.width, height: size.height)
                            .background(
                                Group {
                                    if item.alpha < 1 {
                                        CheckerboardBackground(squareSize: size.height / 2)
                                            .clipShape(RoundedRectangle(cornerRadius: size.width * 0.3))
                                            .opacity(0.25)
                                    }
                                }
                            )
                    })
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(minHeight: size.height)
        .onPreferenceChange(WidthPreferenceKey.self) { newWidth in
            width = newWidth
        }
    }
    
    private func borderColor(nsColor: NSColor) -> Color {
        guard let color = nsColor.contrastingColor() else {
            return Color.secondary
        }
        return Color(nsColor: color)
    }

    private func makeGridItems(for width: CGFloat) -> [GridItem] {
        let totalItemWidth = size.width + spacing
        let maxColumns = max(1, Int(width / totalItemWidth))
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: maxColumns)
    }
}

struct WidthPreferenceKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    @Previewable @State var color: NSColor = NSColor.white
    VStack(spacing: 20) {
        Swatch()
        Swatch(nsColor: color) { value in
            color = value
        }
        .environment(\.swatchColors, [
            NSColor(hue: 0.999, saturation: 0.857, brightness: 0.878, alpha: 1.0),
            NSColor(hue: 0.066, saturation: 1.000, brightness: 0.980, alpha: 1.0),
            NSColor(hue: 0.121, saturation: 0.976, brightness: 0.969, alpha: 1.0),
        ])
    }
    .frame(width: 160)
    .padding()
}
