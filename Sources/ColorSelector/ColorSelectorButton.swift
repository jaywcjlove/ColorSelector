//
//  ColorSelectorSw.swift
//  ColorSelector
//
//  Created by wong on 7/30/25.
//

import SwiftUI

public struct ColorSelectorButton: View {
    @Binding var popover: Bool
    @Binding var selection: Color?
    @Binding var controlSize: ControlSize
    public init(
        popover: Binding<Bool>,
        selection: Binding<Color?>,
        controlSize: Binding<ControlSize>
    ) {
        self._popover = popover
        self._selection = selection
        self._controlSize = controlSize
    }
    public var body: some View {
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
                        .padding(.horizontal, controlSize.horizontal)
                        .padding(.vertical, controlSize.vertical)
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
                        .padding(.vertical, controlSize.vertical)
                        .padding(.horizontal, controlSize.horizontal)
                }
            }
            .frame(maxHeight: .infinity)
        })
        .frame(width: controlSize.colorButton.width)
        .controlSize(controlSize)
    }
}
