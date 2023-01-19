//
//  AppSetting.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 15/1/2023.
//

import Foundation

class AppSetting: ObservableObject {
    
    static let shared = AppSetting()
    
    let entitlement = "Fast Learner Pack"
    
    let maxCollectionsForNonPayUser = 1
    let maxVocabsForNonPayUser = 3
    
    let defaultPronounceSpeed = 3
    let slowestPronounceSpeed = 1
    let fastestPronounceSpeed = 4
    
    let defaultAccent = "en-GB-M"
//    let Accents = ["en-GB-M", "en-US-F", "en-IN-M", "en-IE-F"]
    
    let Accents2 = [
            "en-GB-M" : "com.apple.ttsbundle.Daniel-compact",
            "en-US-F" : "com.apple.ttsbundle.siri_female_en-US_compact",
            "en-IN-M" : "com.apple.ttsbundle.Rishi-compact",
            "en-IE-F" : "com.apple.ttsbundle.Moira-compact"
    ]
}
