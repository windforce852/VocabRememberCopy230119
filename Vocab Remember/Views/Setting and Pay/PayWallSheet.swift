//
//  PayWallScreen.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 13/1/2023.
//

import SwiftUI
import RevenueCat

struct PayWallSheet: View {
    
    @Binding var showPayWall: Bool
    
    @EnvironmentObject var subScriptionViewModel: SubscriptionViewModel //Revenue Cat
    @State var currentOffering: Offering? //RevenueCat offers
    @State var inPurchasing = false ///work with screen block, when loading purchasing
    
    var body: some View {
        NavigationView {
            
            ZStack{ ///embed in ZStack for using a transpent layer to block user tapping while loading purchasing
                
                //Paid Features intro
                ScrollView{
                    VStack (alignment: .leading, spacing: 30){
                        PremiumFeatureView(
                            featureIconName: "lock.open.display",
                            featureTitle: "Unlimited Vocabs",
                            featureBody: "Create Unlimited Vocab List and Vocabs"
                        )
                        PremiumFeatureView(
                            featureIconName: "antenna.radiowaves.left.and.right.slash",
                            featureTitle: "No Advertising",
                            featureBody: "Completely eliminate ads from appearing in the app"
                        )
                        PremiumFeatureView(
                            featureIconName: "arrow.up.square",
                            featureTitle: "Free Upgrade",
                            featureBody: "Enjoy all Feature Upgrades in Free"
                        )
                        PremiumFeatureView(
                            featureIconName: "speaker.circle",
                            featureTitle: "Pronounciation Style",
                            featureBody: "Pronounce in different accents and speed"
                        )
                        PremiumFeatureView(
                            featureIconName: "heart",
                            featureTitle: "Support Indie Development",
                            featureBody: "Show your support while getting something useful in return"
                        )
                        
                        //Offerings
                        if currentOffering != nil {
                            ForEach(currentOffering!.availablePackages) { pkg in
                                Button {
                                    inPurchasing = true
                                    
                                    Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                                        if customerInfo?.entitlements.all["Fast Learner Pack"]?.isActive == true {
                                            subScriptionViewModel.isSubscriptionActive = true
                                            inPurchasing = false
                                            
                                            if !userCancelled, error == nil {
                                                showPayWall = false
                                            } else if let error = error {
                                                print("Error while purchasing: \(error)")
                                                //MARK: TODO - POP MESSAGE
                                            }
                                        }
                                    }
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .frame(height: 55)
                                            .foregroundColor(.blue)
                                            .cornerRadius(10)
                                        
                                        Text("\(pkg.storeProduct.subscriptionPeriod!.periodTitle)  \(pkg.storeProduct.localizedPriceString)")
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                        } ///if currentOffering != nil
                        
                        //Restore Purchase
                        HStack {
                            Spacer()
                            Button {
                                Purchases.shared.restorePurchases { (customerInfo, error) in
                                    //...check customerInfo to see if entitlement is now active
                                    if customerInfo?.entitlements.all[AppSetting.shared.entitlement]?.isActive == true {
                                        subScriptionViewModel.isSubscriptionActive = true
                                    }
                                }
                            } label: {
                                Text("Restore Purchase")
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        
                    }///VStack
                    .padding(.top, 25)
                    .padding(.horizontal, 30)
                    .navigationTitle("Premium")
                    
                    //Button Close PayWall
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showPayWall.toggle()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }//toolbar
                    
                    //Display an overlay during a purchase so that user can't keep tapping purchase
                    
                    
                }//ScrollView
                
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(inPurchasing ? 0.5 : 0.0)
                    .edgesIgnoringSafeArea(.all)
            }//ZStack
            
        }//Nav View
        .onAppear{
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                }
            }
        }
    }//Body
}




struct PremiumFeatureView: View {
    var featureIconName: String
    var featureTitle: String
    var featureBody: String
    
    var body: some View{
        HStack{
            Image(systemName: featureIconName)
                .imageScale(.large)
                .padding(.horizontal, 15)
            VStack (alignment: .leading) {
                Text(featureTitle)
                    .bold()
                    .font(.title3)
                Text(featureBody)
            }
        }
    }
}
