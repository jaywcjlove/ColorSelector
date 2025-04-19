//
//  ColorSampler.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public struct ColorSampler: View {
    @Binding var color: Color
    var cornerRadius: CGFloat = 6
    var pointSize: CGSize = .init(width: 8, height: 8)
    var onColorSampler: ((NSColor) -> Void)?
    public init(
        color: Binding<Color>,
        cornerRadius: CGFloat = 6,
        pointSize: CGSize = .init(width: 8, height: 8),
        onColorSampler: ((NSColor) -> Void)? = nil
    ) {
        self._color = color
        self.cornerRadius = cornerRadius
        self.pointSize = pointSize
        self.onColorSampler = onColorSampler
    }
    public var body: some View {
        Button(action: {
            NSColorSampler().show(selectionHandler: { color in
                if let color {
                    onColorSampler?(color)
                }
            })
        }, label: {
            ZStack {
                let size: CGFloat = pointSize.height * 2 + 6
                color
                    .frame(width: size, height: size)
                    .clipShape(
                        RoundedRectangle(cornerRadius: cornerRadius * 0.6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius * 0.6)
                            .stroke(Color.secondary.opacity(0.46), lineWidth: 1)
                    )
                    .background(
                        CheckerboardBackground(squareSize: pointSize.height / 2)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius * 0.6))
                            .opacity(0.25)
                    )
                
                Image(systemName: "eyedropper.full").font(.system(size: 10))
                    .foregroundStyle(color.contrastingColor() ?? Color.secondary)
            }
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var color: Color = Color.red
    @Previewable @State var cornerRadius: CGFloat = 6
    @Previewable @State var pointSize: CGSize = .init(width: 8, height: 8)
    ColorSampler(
        color: $color,
        cornerRadius: cornerRadius,
        pointSize: pointSize
    )
    .padding()
}
