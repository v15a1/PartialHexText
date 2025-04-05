//
//  PartialColorTextData.swift
//  PartialColorText
//
//  Created by Visal Rajapakse on 2023-10-26.
//

import Foundation

struct PartialColorTextData: Codable {
    var config: PartialColorTextConfig?
    var text: String
    var colors: [String]
}
