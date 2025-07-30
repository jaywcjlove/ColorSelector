//
//  ColorSelectorModifier.swift
//  ColorSelector
//
//  Created by wong on 7/30/25.
//

import SwiftUI

/// A ViewModifier that adds a ColorSelector popover to any view, providing an easy way to add color selection functionality.
/// 
/// This modifier attaches a color picker popover to any view. The popover state is controlled externally through a binding.
///
/// Example usage:
/// ```swift
/// @State private var showColorPicker = false
/// @State private var selectedColor: Color? = .blue
/// 
/// Text("Background Color")
///     .onTapGesture { showColorPicker = true }
///     .colorSelector(selection: $selectedColor, isPresented: $showColorPicker)
/// ```
public struct ColorSelectorModifier: ViewModifier {
    @Binding private var selection: Color?
    @Binding private var isPresented: Bool
    private let arrowEdge: Edge?
    private let showsAlpha: Bool
    
    @State private var hue: CGFloat = 0.0
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var alpha: CGFloat = 1.0
    
    /// Creates a new ColorSelectorModifier.
    /// - Parameters:
    ///   - selection: A binding to the selected color
    ///   - isPresented: A binding to control whether the popover is shown
    ///   - arrowEdge: The edge where the popover arrow should appear
    ///   - showsAlpha: Whether to show alpha (transparency) controls
    public init(
        selection: Binding<Color?>,
        isPresented: Binding<Bool>,
        arrowEdge: Edge? = nil,
        showsAlpha: Bool = true
    ) {
        self._selection = selection
        self._isPresented = isPresented
        self.arrowEdge = arrowEdge
        self.showsAlpha = showsAlpha
    }
    
    public func body(content: Content) -> some View {
        content
            .popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
                ZStack {
                    Color(nsColor: NSColor.windowBackgroundColor).scaleEffect(1.5)
                    Sketch(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha
                    )
                    .showsAlpha(showsAlpha)
                    .onChange(of: hue, initial: false) { _, _ in
                        updateColor()
                    }
                    .onChange(of: brightness, initial: false) { _, _ in
                        updateColor()
                    }
                    .onChange(of: saturation, initial: false) { _, _ in
                        updateColor()
                    }
                    .onChange(of: alpha, initial: false) { _, _ in
                        updateColor()
                    }
                }
                .frame(width: 180, height: 250)
                .onAppear {
                    initializeFromSelection()
                }
            }
    }
    
    private func updateColor() {
        selection = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    private func initializeFromSelection() {
        let color = selection ?? Color.clear
        hue = color.hue
        saturation = color.saturation
        brightness = color.brightness
        alpha = color.alpha
    }
}

public extension View {
    /// Adds a color selector popover to the view.
    /// - Parameters:
    ///   - selection: A binding to the selected color
    ///   - isPresented: A binding to control whether the popover is shown
    ///   - arrowEdge: The edge where the popover arrow should appear
    ///   - showsAlpha: Whether to show alpha (transparency) controls
    /// - Returns: A view that shows a color picker popover when isPresented is true
    func colorSelectorPopover(
        selection: Binding<Color?>,
        isPresented: Binding<Bool>,
        arrowEdge: Edge? = nil,
        showsAlpha: Bool = true
    ) -> some View {
        modifier(ColorSelectorModifier(
            selection: selection,
            isPresented: isPresented,
            arrowEdge: arrowEdge,
            showsAlpha: showsAlpha
        ))
    }
    
    /// Adds a color selector popover to the view with NSColor binding.
    /// - Parameters:
    ///   - nsColor: A binding to the selected NSColor
    ///   - isPresented: A binding to control whether the popover is shown
    ///   - arrowEdge: The edge where the popover arrow should appear
    ///   - showsAlpha: Whether to show alpha (transparency) controls
    /// - Returns: A view that shows a color picker popover when isPresented is true
    func colorSelectorPopover(
        nsColor: Binding<NSColor?>,
        isPresented: Binding<Bool>,
        arrowEdge: Edge? = nil,
        showsAlpha: Bool = true
    ) -> some View {
        let colorBinding = Binding<Color?> {
            if let nsColor = nsColor.wrappedValue {
                return Color(nsColor: nsColor)
            } else {
                return nil
            }
        } set: { newValue in
            nsColor.wrappedValue = newValue?.toNSColor
        }
        
        return modifier(ColorSelectorModifier(
            selection: colorBinding,
            isPresented: isPresented,
            arrowEdge: arrowEdge,
            showsAlpha: showsAlpha
        ))
    }
}
