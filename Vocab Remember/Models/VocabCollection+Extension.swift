//
//  VocabCollection+Extension.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import Foundation
import CoreData


//Turn CoreData attribute vocabCollectionToVocab into a sorted Vocab array for View to display in List ForEach
extension VocabCollection {
    public var vocabArrayByAlphabet:[Vocab] {
        let set = vocabCollectionToVocab as? Set<Vocab> ?? []
        return set.sorted{
            $0.inLang1! < $1.inLang1!
        }
    }
    
    public var vocabArrayByTimestamp:[Vocab] {
        let set = vocabCollectionToVocab as? Set<Vocab> ?? []
        return set.sorted{
            $0.timestamp! < $1.timestamp!
        }
    }
    
}
