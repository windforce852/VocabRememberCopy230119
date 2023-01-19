//
//  SpeakManager.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 26/12/2022.
//

import Foundation
import AVFoundation


//For pronounce the vocab in RememberScreen
class SpeakManager : ObservableObject{

    let synthesizer = AVSpeechSynthesizer()
    
//    @Published var accents = AppSetting.shared.Accents
    @Published var accents = Array(AppSetting.shared.Accents2.keys)
    @Published var defaultAccent: String = AppSetting.shared.defaultAccent
    @Published var pronounceSpeed = AppSetting.shared.defaultPronounceSpeed
    
    
    
    func pronounce(sound: String) {
        
        let utterance = AVSpeechUtterance(string: sound)
        print("sound content: \(sound)")
        
        switch pronounceSpeed {
        case 4:
            utterance.rate = 0.55
        case 3:
            utterance.rate = 0.5
        case 2:
            utterance.rate = 0.4
        case 1:
            utterance.rate = 0.2
        default:
            utterance.rate = 0.5
        }
        
//        switch defaultAccent {
//        case "en-GB-M":
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-compact")
//            print("case en-GB-M")
//        case "en-US-F":
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
//            print("case en-US-F")
//        case "en-IN-M":
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Rishi-compact")
//            print("case en-IN-M")
//        case "en-IE-F":
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Moira-compact")
//            print("case en-IE-F")
//        default:
//            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
//            print("case default")
//        }
        
        switch defaultAccent {
        case Array(AppSetting.shared.Accents2)[0].0 :
            utterance.voice = AVSpeechSynthesisVoice(identifier: Array(AppSetting.shared.Accents2)[0].1)
        case Array(AppSetting.shared.Accents2)[1].0 :
            utterance.voice = AVSpeechSynthesisVoice(identifier: Array(AppSetting.shared.Accents2)[1].1)
        case Array(AppSetting.shared.Accents2)[2].0 :
            utterance.voice = AVSpeechSynthesisVoice(identifier: Array(AppSetting.shared.Accents2)[2].1)
        case Array(AppSetting.shared.Accents2)[3].0 :
            utterance.voice = AVSpeechSynthesisVoice(identifier: Array(AppSetting.shared.Accents2)[3].1)
        default:
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
            print("case default")
        }
        
        synthesizer.speak(utterance)
        print("Speak")
    }
    
    
//    func speak(sound: String) {
//        print("func speak start")
//        let utterance = AVSpeechUtterance(string: sound)
//        print("sound is \(sound)")
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        utterance.rate = 0.5
//        synthesizer.speak(utterance)
//        print("spoke")
//    }
}
