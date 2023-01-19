//
//  Vocab_RememberApp.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI
import RevenueCat

@main
struct Vocab_RememberApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            VocabCollectionListScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(SpeakManager())
                .environmentObject(SubscriptionViewModel())
        }
    }
    
    init() {
        Purchases.logLevel = .debug // for showing debug msg
        Purchases.configure(withAPIKey: CatKey.shared.revenueCatKey)
    }
}
