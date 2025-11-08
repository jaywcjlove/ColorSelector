//
//  ColorSampler.swift
//  ColorSelector
//
//  Created by wong on 4/18/25.
//

import SwiftUI

class ColorSamplerViewModel: ObservableObject {
    @Published var size: CGFloat = 23
}

public struct ColorSampler: View {
    @ObservedObject var viewModel = ColorSamplerViewModel()
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
                    DispatchQueue.main.async {
                        onColorSampler?(color)
                    }
                }
            })
        }, label: {
            ZStack {
                color
                    .frame(width: viewModel.size, height: viewModel.size)
                    .clipShape(
                        RoundedRectangle(cornerRadius: cornerSize * 0.6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerSize * 0.6)
                            .stroke(Color.secondary.opacity(0.46), lineWidth: 1)
                    )
                    .background(
                        CheckerboardBackground(squareSize: 5)
                            .clipShape(RoundedRectangle(cornerRadius: cornerSize * 0.6))
                            .opacity(0.25)
                    )
                
                Image(systemName: "eyedropper.full")
                    .font(.system(size: viewModel.size * 0.6))
                    .foregroundStyle(color.contrastingColor() ?? Color.secondary)
            }
        })
        .buttonStyle(.plain)
    }
    
    public func rectSize(_ value: CGFloat) -> ColorSampler {
        viewModel.size = value
        return self as ColorSampler
    }
    public func rectSize(_ value: Binding<CGFloat>) -> ColorSampler {
        viewModel.size = value.wrappedValue
        return self as ColorSampler
    }
}

#Preview {
    @Previewable @State var color: Color = Color.red
    @Previewable @State var value: CGFloat = 23
    VStack {
        Text("changeSizeValue: \(value)")
        ColorSampler(color: $color)
            .rectSize($value)
            .padding()
        Button("Change Size") {
            value += 1
        }
    }
    .padding()
}
