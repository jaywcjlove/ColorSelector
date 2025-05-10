// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public extension ColorSelector where Title == EmptyView {
    init(_ title: LocalizedStringKey? = nil, selection: Binding<Color?>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self._selection = selection
    }
    init(_ title: LocalizedStringKey? = nil, nsColor: Binding<NSColor?>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self._selection = Binding<Color?> {
            if let nsColor = nsColor.wrappedValue {
                return Color(nsColor: nsColor)
            } else {
                return nil
            }
        } set: { newValue in
            nsColor.wrappedValue = newValue?.toNSColor
        }
    }
}

public struct ColorSelector<Title>: View where Title : View {
    @ObservedObject var viewModel: SketchViewModel = .init()
    @Environment(\.pointSize) private var pointSize
    @Binding var selection: Color?
    @State private var popover: Bool = false
    var title: LocalizedStringKey?
    var arrowEdge: Edge? = nil
    var label: (() -> Title)?
    public init(selection: Binding<Color?>, arrowEdge: Edge? = nil, label: (() -> Title)? = nil) {
        self.label = label
        self.arrowEdge = arrowEdge
        self._selection = selection
    }
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var hue: CGFloat = 0.0
    @State private var alpha: CGFloat = 1.0
    
    public var body: some View {
        HStack {
            if let title {
                Text(title)
                Spacer()
            }
            if let label {
                label()
                Spacer()
            }
            Button(action: {
                popover = true
            }, label: {
                ZStack {
                    if let selection, selection != .clear {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(selection)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2.5, style: .continuous).stroke(lineWidth: 1).opacity(0.25)
                            )
                            .background(
                                    CheckerboardBackground(squareSize: 5)
                                        .opacity(0.25)
                            )
                            .mask(RoundedRectangle(cornerRadius: 2.5, style: .continuous))
                            .padding(.horizontal, viewModel.controlSize.horizontal)
                            .padding(.vertical, viewModel.controlSize.vertical)
                    } else {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(.white)
                            .overlay(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                                        .stroke(lineWidth: 1) .opacity(0.25)
                                    Rectangle()
                                        .fill(.red)
                                        .frame(height: 1)
                                        .rotationEffect(Angle(degrees: -22))
                                }
                            )
                            .mask(RoundedRectangle(cornerRadius: 2.5, style: .continuous))
                            .padding(.vertical, viewModel.controlSize.vertical)
                            .padding(.horizontal, viewModel.controlSize.horizontal)
                    }
                }
                .frame(maxHeight: .infinity)
            })
            .frame(width: viewModel.controlSize.colorButton.width, height: viewModel.controlSize.colorButton.height)
            .controlSize(viewModel.controlSize)
            .popover(isPresented: $popover, arrowEdge: arrowEdge) {
                ZStack {
                    Color(nsColor: NSColor.windowBackgroundColor).scaleEffect(1.5)
                    Sketch(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    )
                    .showsAlpha($viewModel.showsAlpha)
                    .onChange(of: hue, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: brightness, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: saturation, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: alpha, initial: false, { old, val in
                        changeColor()
                    })
                }
                .frame(width: 180, height: 250)
                .onAppear() {
                    let selection = selection ?? Color.clear
                    hue = selection.hue
                    saturation = selection.saturation
                    brightness = selection.brightness
                    alpha = selection.alpha
                }
            }
        }
    }
    private func changeColor() {
        selection = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    public func showsAlpha(_ value: Bool) -> ColorSelector {
        viewModel.showsAlpha = value
        return self as ColorSelector
    }
    public func showsAlpha(_ value: Binding<Bool>) -> ColorSelector {
        viewModel.showsAlpha = value.wrappedValue
        return self as ColorSelector
    }
    public func controlSize(_ value: ControlSize) -> ColorSelector {
        viewModel.controlSize = value
        return self as ColorSelector
    }
}

extension ControlSize {
    var colorButton: CGSize {
        switch self {
        case .extraLarge: .init(width: 44, height: 28)
        case .large: .init(width: 44, height: 28)
        case .small: .init(width: 30, height: 12)
        case .mini: .init(width: 24, height: 12)
        default: .init(width: 34, height: 28)
        }
    }
    var horizontal: CGFloat {
        switch self {
        case .extraLarge: -4
        case .large: -4
        case .regular: -5
        case .small: -4
        case .mini: -3
        default: -4
        }
    }
    var vertical: CGFloat {
        switch self {
        case .extraLarge: 2
        case .large: 2
        case .regular: 2
        case .small: 1
        case .mini: 1
        default: 1
        }
    }
}


#Preview {
    @Previewable @State var color: Color? = Color.blue
    @Previewable @State var colorClear: Color? = .clear
    @Previewable @State var nsColor: NSColor? = NSColor.red
    
    ColorSelector(selection: $color) {
        Text("Color Picker")
    }
    .frame(width: 210)
    .padding()
    ColorSelector("Color", selection: $color)
        .frame(width: 210)
        .padding()
    HStack {
        Button("Button Size", action: {}).controlSize(.extraLarge)
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.extraLarge)
    }
    HStack {
        Button("Button Size", action: {}).controlSize(.large)
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.large)
    }
    HStack {
        Button("Button Size", action: {}).controlSize(.regular)
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.regular)
    }
    HStack {
        Button("Button Size", action: {}).controlSize(.small)
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.small)
    }
    HStack {
        Button("Button Size", action: {}).controlSize(.mini)
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.mini)
    }
    ColorSelector(selection: $colorClear, arrowEdge: .top).padding()
    ColorSelector(nsColor: $nsColor, arrowEdge: .top).padding()
    HStack {
        if let nsColor {
            Color(nsColor: nsColor).frame(width: 60, height: 30)
        }
        color.frame(width: 60, height: 30)
    }
    .padding(.bottom)
}
