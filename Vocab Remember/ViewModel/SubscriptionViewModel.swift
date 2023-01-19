//
//  SubscriptionViewModel.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 14/1/2023.
//

import Foundation
import SwiftUI
import RevenueCat

//Get app subscription status and provide a bool for view to check if provide Paid tier content
class SubscriptionViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    init() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isSubscriptionActive = customerInfo?.entitlements.all[AppSetting.shared.entitlement]?.isActive == true
            print("isSubscriptionActive")
        }
    }
}
