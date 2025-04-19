//
//  ColorSampler.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

public struct ColorSampler: View {
    @Environment(\.pointSize) private var pointSize
    @Environment(\.cornerSize) private var cornerSize
    @Binding var color: Color
    var onColorSampler: ((NSColor) -> Void)?
    public init(color: Binding<Color>, onColorSampler: ((NSColor) -> Void)? = nil) {
        self._color = color
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
                        RoundedRectangle(cornerRadius: cornerSize * 0.6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerSize * 0.6)
                            .stroke(Color.secondary.opacity(0.46), lineWidth: 1)
                    )
                    .background(
                        CheckerboardBackground(squareSize: pointSize.height / 2)
                            .clipShape(RoundedRectangle(cornerRadius: cornerSize * 0.6))
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
    VStack {
        ColorSampler(color: $color)
//            .cornerSize(6)
//            .pointSize(CGSize(width: 8, height: 8))
    }
    .padding()
}
