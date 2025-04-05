//
//  PartialColorTextFormatterConfig.swift
//  PartialColorText
//
//  Created by Visal Rajapakse on 2023-10-26.
//

import SwiftUI

struct PartialColorTextConfig: Codable {
    var prefix = "#{"
    var suffix = "}"
    var textAlignment: TextAlignment?
    var viewAlignment: ViewAlignment?
    var prefixCount: Int { prefix.count }
    var suffixCount: Int { suffix.count }
    
    enum TextAlignment: String, Codable {
        case center = "center"
        case leading = "leading"
        case trailing = "trailing"
        
        var value: SwiftUI.TextAlignment {
            switch self {
            case .center:
                return .center
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
    }
    
    enum ViewAlignment: String, Codable {
        case center = "center"
        case leading = "leading"
        case trailing = "trailing"
        
        var value: Alignment {
            switch self {
            case .center:
                return .center
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
    }
}
