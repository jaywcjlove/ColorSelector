//
//  ColorSelectorModifierExample.swift
//  ColorSelector
//
//  Created by wong on 7/30/25.
//

import SwiftUI

struct ColorSelectorModifierExample: View {
    @State private var backgroundColor: Color? = .blue
    @State private var textColor: Color? = .primary
    @State private var borderColor: Color? = .red
    @State private var accentColor: Color? = .green
    @State private var shadowColor: NSColor? = NSColor.gray
    
    // Popover states - controlled externally
    @State private var showBackgroundPicker = false
    @State private var showTextPicker = false
    @State private var showBorderPicker = false
    @State private var showAccentPicker = false
    @State private var showShadowPicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ColorSelector Modifier Examples")
                .font(.title)
                .padding()
            
            Text("Click on any element below to open color picker!")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Example 1: Basic usage with external popover control
            VStack {
                Text("Background Color")
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        showBackgroundPicker = true
                    }
                    .colorSelectorPopover(
                        selection: $backgroundColor,
                        isPresented: $showBackgroundPicker
                    )
                
                Rectangle()
                    .fill(backgroundColor ?? .clear)
                    .frame(height: 60)
                    .overlay(
                        Text("Sample Background")
                            .foregroundColor(.white)
                    )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Example 2: Button trigger with no alpha
            VStack {
                Button("Choose Border Color") {
                    showBorderPicker = true
                }
                .padding()
                .colorSelectorPopover(
                    selection: $borderColor,
                    isPresented: $showBorderPicker,
                    showsAlpha: false
                )
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor ?? .red, lineWidth: 3)
                    )
                    .overlay(
                        Text("Sample Border")
                            .foregroundColor(.primary)
                    )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Example 3: Custom arrow position
            VStack {
                HStack {
                    Text("Text Color:")
                    Spacer()
                    Button("Select") {
                        showTextPicker = true
                    }
                    .colorSelectorPopover(
                        selection: $textColor,
                        isPresented: $showTextPicker,
                        arrowEdge: .bottom
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Text("This text uses the selected color")
                    .font(.headline)
                    .foregroundColor(textColor ?? .primary)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Example 4: NSColor binding with programmatic trigger
            VStack {
                HStack {
                    Text("Shadow Color (NSColor)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        showShadowPicker = true
                    }) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(shadowColor != nil ? Color(nsColor: shadowColor!) : .gray)
                            .frame(width: 30, height: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .colorSelectorPopover(
                        nsColor: $shadowColor,
                        isPresented: $showShadowPicker,
                        arrowEdge: .top
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Text("Text with Shadow")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .shadow(
                        color: shadowColor != nil ? Color(nsColor: shadowColor!) : .clear,
                        radius: 5, x: 2, y: 2
                    )
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Example 5: Color swatch with multiple triggers
            VStack {
                Text("Accent Color Swatches")
                    .font(.headline)
                
                HStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .fill(accentColor ?? .gray)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary, lineWidth: 1)
                                    .opacity(0.3)
                            )
                            .onTapGesture {
                                showAccentPicker = true
                            }
                    }
                }
                .colorSelectorPopover(
                    selection: $accentColor,
                    isPresented: $showAccentPicker
                )
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: 450)
    }
}

#Preview {
    ColorSelectorModifierExample()
}
