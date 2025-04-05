![Simulator Screen Recording - iPhone 16 Pro - 2025-04-05 at 16 38 47](https://github.com/user-attachments/assets/074243c8-ad30-4e45-a600-e8a2a07ecc86)

# PartialHexText

A lightweight SwiftUI library that allows developers to dynamically color specific portions of text using hex color codes and custom formatting.

## Features

- Apply different colors to specific text segments using simple markup
- Configure custom prefix and suffix markers for coloring
- Support for hex color codes
- Control text and view alignment
- Load configuration and styled text directly from JSON

## Usage

### Basic Usage

```swift
import PartialHexText

struct ContentView: View {
    var body: some View {
        // Apply pink color to "There" and blue color to "Kenobi"
        PartialHexText(text: "Hello #{There}, General #{Kenobi}", .pink, .blue)
    }
}
```

### Custom Formatting

```swift
import PartialHexText

struct CustomFormatView: View {
    var body: some View {
        // Using custom prefix/suffix markers
        let config = PartialHexTextConfig(
            prefix: "@[", 
            suffix: "]",
            textAlignment: .center,
            viewAlignment: .leading
        )
        
        PartialHexText(
            text: "This is @[custom] formatting with @[different] markers",
            config: config,
            .red, .green
        )
    }
}
```

### Loading from JSON

Parse dynamic text formatting directly from a server response or configuration file:

```swift
let jsonData = """
{
    "config": {
        "prefix": "#(",
        "suffix": ")",
        "textAlignment": "leading",
        "viewAlignment": "trailing"
    },
    "text": "#(PartialHexText) is a #(SwiftUI) library that allows #(dynamic) text coloring",
    "colors": [
        "#1450A3",
        "#279EFF",
        "#FF6969"
    ]
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
if let data = try? decoder.decode(PartialHexTextData.self, from: jsonData) {
    PartialHexText(data: data)
}
```

## Example

Here's how the component renders with different configurations:

```swift
// Standard usage
PartialHexText(text: "Hello #{World}, this is #{Partial} #{Hex} #{Text}", 
               .blue, .red, .green, .purple)

// Custom configuration
let config = PartialHexTextConfig(prefix: "*", suffix: "*")
PartialHexText(text: "Different *markers* can be *used*",
               config: config,
               .orange, .teal)
```

## Requirements

- iOS 15.0+
