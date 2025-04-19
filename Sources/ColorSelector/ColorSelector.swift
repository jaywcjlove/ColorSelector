// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct ColorSelector: View {
    @Environment(\.pointSize) private var pointSize
    @Environment(\.cornerSize) private var cornerSize
    @Binding var selection: Color
    @State private var popover: Bool = false
    var title: LocalizedStringKey?
    var arrowEdge: Edge? = nil
    public init(_ title: LocalizedStringKey? = nil, selection: Binding<Color>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self._selection = selection
    }
    
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var hue: CGFloat = 0.0
    @State private var alpha: CGFloat = 1.0
    
    public var body: some View {
        HStack {
            if let title { Text(title) }
            Button(action: {
                popover = true
            }, label: {
                ZStack {
                    if selection != .clear {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(selection)
                            .frame(width: 38, height: 17)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2.5, style: .continuous).stroke(lineWidth: 1).opacity(0.25)
                            )
                            .background(
                                    CheckerboardBackground(squareSize: pointSize.height / 2)
                                        .opacity(0.25)
                            )
                            .mask(RoundedRectangle(cornerRadius: 2.5, style: .continuous))
                            .padding([.leading, .trailing], -5).padding([.top, .bottom], 2)
                    } else {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(.white)
                            .frame(width: 38, height: 17)
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
                            .padding([.leading, .trailing], -5).padding([.top, .bottom], 2)
                    }
                }
            })
            .frame(width: 44, height: 23)
            .popover(isPresented: $popover, arrowEdge: arrowEdge) {
                ZStack {
                    Color(nsColor: NSColor.windowBackgroundColor).scaleEffect(1.5)
                    Sketch(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    )
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
                    hue = selection.hue
                    saturation = selection.saturation
                    brightness = selection.brightness
                    alpha = selection.alpha
                }
            }
        }
    }
    func changeColor() {
        selection = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
}


#Preview {
    @Previewable @State var color: Color = Color.blue
    @Previewable @State var colorClear: Color = .clear
    ColorSelector("Color", selection: $color).padding()
    ColorSelector(selection: $colorClear).padding()
    ColorSelector(selection: $colorClear, arrowEdge: .top).padding()
    
    color.frame(width: 60, height: 30)
}
