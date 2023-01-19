//
//  SettingScreen.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 13/1/2023.
//

import SwiftUI

//For App Setting, and trigger PayWall
struct SettingSheet: View {
    
    @EnvironmentObject var speakman: SpeakManager //AVFoudation
    @EnvironmentObject var subScriptionViewModel: SubscriptionViewModel //RevenueCat
    @Binding var showSettings: Bool
    
    @State var showPayWall: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                
                //Show PayWallButton only if not in subscription
                if !subScriptionViewModel.isSubscriptionActive {
                    Button {
                        showPayWall.toggle()
                    } label: {
                        ZStack{
                            Rectangle()
                                .frame(height: 50)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                            Text("Premium")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding(15)
                    }
                }
                
                //App settings, disable some of them if not paid user
                Section("General") {
                    HStack{
                        Text("Max Vocab Lists")
                        Spacer()
                        Text(String(AppSetting.shared.maxCollectionsForNonPayUser))
                    }
                    HStack{
                        Text("Max vocabs per Vocab List")
                        Spacer()
                        Text(String(AppSetting.shared.maxVocabsForNonPayUser))
                    }
                    HStack{
                        Stepper("Speaking speed: \(speakman.pronounceSpeed.displaySpeakingSpeed)",
                                value: $speakman.pronounceSpeed,
                                in: AppSetting.shared.slowestPronounceSpeed...AppSetting.shared.fastestPronounceSpeed)
                        .disabled(!subScriptionViewModel.isSubscriptionActive ? true : false)
                    }
                    HStack{
                        Picker("Accent", selection: $speakman.defaultAccent){
                            ForEach(speakman.accents, id: \.self) {
                                Text($0)
                            }
                        }
                        .disabled(!subScriptionViewModel.isSubscriptionActive ? true : false)
                    }
                }
            }//list
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Text("Close")
                    }
                }
            }
            .sheet(isPresented: $showPayWall) {
                PayWallSheet(showPayWall: $showPayWall)
            }
        }
    }
}

//struct SettingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingSheet()
//    }
//}
