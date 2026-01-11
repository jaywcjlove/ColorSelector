// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// 简化版本：无自定义 label 和 footer
public extension ColorSelector where Title == EmptyView, Footer == EmptyView {
    init(_ title: LocalizedStringKey? = nil, selection: Binding<Color?>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self.label = nil
        self.footer = nil
        self._selection = selection
    }
    
    init(_ title: LocalizedStringKey? = nil, nsColor: Binding<NSColor?>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self.label = nil
        self.footer = nil
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

// 带有尾随闭包作为 label 的初始化器（Footer 为 EmptyView）
public extension ColorSelector where Footer == EmptyView {
    init(
        _ title: LocalizedStringKey? = nil,
        selection: Binding<Color?>,
        arrowEdge: Edge? = nil,
        @ViewBuilder content: @escaping () -> Title
    ) {
        self.title = title
        self.arrowEdge = arrowEdge
        self.label = content()
        self.footer = nil
        self._selection = selection
    }
    
    init(
        _ title: LocalizedStringKey? = nil,
        nsColor: Binding<NSColor?>,
        arrowEdge: Edge? = nil,
        @ViewBuilder content: @escaping () -> Title
    ) {
        self.title = title
        self.arrowEdge = arrowEdge
        self.label = content()
        self.footer = nil
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

// 带有尾随闭包作为 label 的初始化器（Title 为 EmptyView）
public extension ColorSelector where Title == EmptyView {
    init(
        _ title: LocalizedStringKey? = nil,
        selection: Binding<Color?>,
        arrowEdge: Edge? = nil,
        footer: (() -> Footer)? = nil
    ) {
        self.title = title
        self.label = nil
        self.footer = footer?()
        self.arrowEdge = arrowEdge
        self._selection = selection
    }
    init(
        _ title: LocalizedStringKey? = nil,
        nsColor: Binding<NSColor?>,
        arrowEdge: Edge? = nil,
        footer: (() -> Footer)? = nil
    ) {
        self.title = title
        self.label = nil
        self.footer = footer?()
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

public struct ColorSelector<Title: View, Footer: View>: View {
    @ObservedObject var vm: SketchViewModel = .init()
    @Environment(\.pointSize) private var pointSize
    @Binding var selection: Color?
    @State private var popover: Bool = false
    var title: LocalizedStringKey?
    var arrowEdge: Edge? = nil
    var label: Title?
    var footer: Footer?
    public init(
        _ title: LocalizedStringKey? = nil,
        selection: Binding<Color?>,
        arrowEdge: Edge? = nil,
        footer: (() -> Footer)? = nil,
        label: (() -> Title)? = nil,
    ) {
        self.title = title
        self.label = label?()
        self.footer = footer?()
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
                label
                Spacer()
            }
            ColorSelectorButton(
                popover: $popover,
                selection: $selection,
                controlSize: $vm.controlSize
            )
            .popover(isPresented: $popover, arrowEdge: arrowEdge) {
                ZStack {
                    Color(nsColor: NSColor.windowBackgroundColor).scaleEffect(1.5)
                    Sketch(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    ) {
                        footer
                    }
                    .showsAlpha($vm.showsAlpha)
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
                .frame(width: vm.size.width, height: vm.size.height)
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
        vm.showsAlpha = value
        return self as ColorSelector
    }
    public func showsAlpha(_ value: Binding<Bool>) -> ColorSelector {
        vm.showsAlpha = value.wrappedValue
        return self as ColorSelector
    }
    public func pickerSize(_ value: Binding<CGSize>) -> ColorSelector {
        vm.size = value.wrappedValue
        return self as ColorSelector
    }
    public func controlSize(_ value: ControlSize) -> ColorSelector {
        vm.controlSize = value
        return self as ColorSelector
    }
}

extension ControlSize {
    var colorButton: CGSize {
        switch self {
        case .extraLarge: .init(width: 33, height: 18)
        case .large: .init(width: 26, height: 18)
        case .regular: .init(width: 16, height: 16)
        case .small: .init(width: 16, height: 14)
        case .mini: .init(width: 14, height: 12)
        default: .init(width: 34, height: 28)
        }
    }
    var cornerRadius: CGFloat {
        switch self {
        case .extraLarge: 24
        case .large: 12
        case .regular: 4
        case .small: 4
        case .mini: 4
        default: 4
        }
    }
    var horizontal: CGFloat {
        switch self {
        case .extraLarge: -10
        case .large: -6
        case .regular: -8
        case .small: -6
        case .mini: -4
        default: -4
        }
    }
    var vertical: CGFloat {
        switch self {
        case .extraLarge: -4
        case .large: -1
        case .regular: 0
        case .small: 1
        case .mini: 2
        default: 1
        }
    }
}


#Preview {
    @Previewable @State var color: Color? = Color.blue
    @Previewable @State var colorClear: Color? = .clear
    @Previewable @State var nsColor: NSColor? = NSColor.red
    
    ColorSelector(nsColor: $nsColor) {
        Text("Color Picker")
    }
    .frame(width: 210)
    
    ColorSelector(selection: $color, footer: {
        Text("Hello World")
    })
    .pickerSize(.constant(.init(width: 180, height: 280)))
    .frame(width: 210)
    
    ColorSelector(nsColor: $nsColor, footer: {
        Text("Hello World")
    })
    .pickerSize(.constant(.init(width: 180, height: 280)))
    .frame(width: 210)
    
    ColorSelector(selection: $color, footer: {
        Text("Hello World")
    }) {
        Text("Color Picker Footer")
    }
    .pickerSize(.constant(.init(width: 180, height: 280)))
    .frame(width: 210)
    ColorSelector(selection: $color) {
        Text("Color Picker")
    }
    .frame(width: 210)
    .padding()
    ColorSelector("Color", selection: $color)
        .frame(width: 210)
        .padding()
    HStack {
        Button("Button extraLarge Size", action: {}).controlSize(.extraLarge)
        Spacer()
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.extraLarge)
    }
    .frame(width: 210)
    HStack {
        Button("Button large Size", action: {}).controlSize(.large)
        Spacer()
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.large)
    }
    .frame(width: 210)
    HStack {
        Button("Button regular Size", action: {}).controlSize(.regular)
        Spacer()
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.regular)
    }
    .frame(width: 210)
    HStack {
        Button("Button small Size", action: {}).controlSize(.small)
        Spacer()
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.small)
    }
    .frame(width: 210)
    HStack {
        Button("Button mini Size", action: {}).controlSize(.mini)
        Spacer()
        ColorSelector(selection: $color)
            .showsAlpha(false)
            .controlSize(.mini)
    }
    .frame(width: 210)
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
