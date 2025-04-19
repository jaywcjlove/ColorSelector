ColorSelector
===

A SwiftUI color picker component library for macOS

```swift
import ColorSelector

struct ContentView: View {
    @State var color: Color = .red
    @State var colorClear: Color = .clear
    
    var body: some View {
        ColorSelector("Color", selection: $color).padding()
        ColorSelector(selection: $colorClear).padding()
    }
}
```