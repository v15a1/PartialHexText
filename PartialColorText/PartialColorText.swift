//
//  PartialColorText.swift
//  PartialColorText
//
//  Created by Visal Rajapakse on 2023-10-26.
//

import SwiftUI

struct PartialColorText: View {
    // MARK: Variables and Configs
    var text: String = ""
    var config: PartialColorTextConfig!
    private var stringsToColor: [(String, Color)] = []
    private var attributedString: AttributedString = ""
    
    // MARK: Initializers
    /// Displays partially colored text based on a JSON response
    /// - Parameter data: DTO representing the data and configs received via JSON response.
    init(data: PartialColorTextData) {
        if let config = data.config {
            self.config = config
        } else {
            self.config = .init()
        }
        let colors = data.colors.map { Color(hex: $0) }
        setup(text: data.text, colors)
    }
    
    /// Allows manual configuration of partially colored texts
    /// - Parameters:
    ///   - text: Text with `PartiaLColorText` formatting. Formatting can be configured in `PartialColorTextConfig`
    ///   - textAlignment: Text alignment of the text
    ///   - viewAlignment: View bound alignment of the text
    ///   - colors: Colors to use for formatting
    init(text: String,
         textAlignment: PartialColorTextConfig.TextAlignment = .leading,
         viewAlignment: PartialColorTextConfig.ViewAlignment = .center,
         _ colors: Color...) {
        var config = PartialColorTextConfig()
        config.textAlignment = textAlignment
        config.viewAlignment = viewAlignment
        self.config = config
        
        setup(text: text, colors)
    }
    
    var body: some View {
        Text(attributedString)
            .multilineTextAlignment(config.textAlignment?.value ?? .center)
            .frame(maxWidth: .infinity, alignment: config.viewAlignment?.value ?? .center)
        
    }
    
    /// Sets up the component
    /// - Parameters:
    ///   - text: Text to add color formatting to
    ///   - colors: Colors to include in the formatted text
    mutating func setup(text: String, _ colors: [Color]) {
        let (text, stringsToColor) = partiallyColor(text: text, colors)
        self.text = text
        self.stringsToColor = stringsToColor
        
        let mutableString = NSMutableAttributedString.init(string: self.text)
        
        // Colors the text
        stringsToColor.forEach {
            let range = (text as NSString).range(of: $0.0)
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor($0.1), range: range)
        }
        
        self.attributedString = AttributedString(mutableString)
    }
    
    /// Formats the text with color
    /// - Parameters:
    ///   - text: Text to add color formatting to
    ///   - colors: Colors to add to the text
    /// - Returns: Text with `PartialColorText` formatting removed alongside an array of tuples including `String` and `Colors` for formatting
    private func partiallyColor(text: String, _ colors: [Color]) -> (String, [(String, Color)]) {
        // Single-pass scanning
        var result: [(range: Range<String.Index>, color: Color)] = []
        var currentIndex = text.startIndex
        var colorIndex = 0
        
        while currentIndex < text.endIndex {
            if let prefixRange = text[currentIndex...].range(of: config.prefix) {
                let startIndex = text.index(prefixRange.upperBound, offsetBy: 0)
                currentIndex = prefixRange.upperBound
                
                if let suffixRange = text[currentIndex...].range(of: config.suffix) {
                    let endIndex = suffixRange.lowerBound
                    let substring = String(text[startIndex..<endIndex])
                    
                    if colorIndex < colors.count {
                        result.append((range: startIndex..<endIndex, color: colors[colorIndex]))
                        colorIndex += 1
                    }
                    
                    currentIndex = suffixRange.upperBound
                } else {
                    currentIndex = text.endIndex
                }
            } else {
                break
            }
        }
        
        // Create the resulting text without markers
        var reformattedText = text
        reformattedText = reformattedText.replacingOccurrences(of: config.prefix, with: "")
        reformattedText = reformattedText.replacingOccurrences(of: config.suffix, with: "")
        
        // Map results to the format needed by callers
        let stringsToColor = result.map { (String(text[$0.range]), $0.color) }
        
        return (reformattedText, stringsToColor)
    }
}

#Preview {
    PartialColorText(text: "Hello #{There}, General #{Kenobi}", .pink, .blue)
}
