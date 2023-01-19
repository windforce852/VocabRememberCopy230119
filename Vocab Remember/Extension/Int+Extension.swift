//
//  Int+Extension.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 13/1/2023.
//

import Foundation

extension Int {
    var displaySpeakingSpeed: String {
        switch self{
        case 1: return "Very Slow"
        case 2: return "Slow"
        case 3: return "Normal"
        case 4: return "Fast"
        default: return "Default"
        }
    }
}
