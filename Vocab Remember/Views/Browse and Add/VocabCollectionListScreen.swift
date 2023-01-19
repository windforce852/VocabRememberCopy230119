//
//  ContentView.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI
import CoreData

struct VocabCollectionListScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext //CoreData
    @EnvironmentObject var subScriptionViewModel: SubscriptionViewModel //RevenueCat
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \VocabCollection.timestamp, ascending: false)], animation: .default)
    private var vocabCollections: FetchedResults<VocabCollection>
    
    @State private var showAddCollection:Bool = false
    @State private var showPurchaseOption:Bool = false
    @State private var showSettingsSheet:Bool = false
    @State private var showPayWallSheet:Bool = false
    @State private var showHelp:Bool = false

    @State private var refreshVocabCollectionList:Bool = false //small hack for refresh View
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading){
                
                //Button AddNewCollection & ShowHelp
                HStack{
                    //AddNewCollection
                    Button {
                        addCollectionWithCheck()
                    } label: {
                        Text("+ Add new vocab list")
                            .foregroundColor(.blue)
                    }
                    //Pop up to encourage Free tier user to subscription
                    .alert("Activate Premium Now to add unlimited Vocabs and Vocab Lists", isPresented: $showPurchaseOption) {
                        Button {
                            showPurchaseOption.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        Button {
                            showPayWallSheet.toggle()
                            showPurchaseOption.toggle()
                        } label: {
                            Text("Activate")
                        }
                    }

                    Spacer()
                    
                    //ShowHelp
                    Button {
                        showHelp.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    //Pop up to show help
                    .alert("Create a list and then input vocabs inside the list", isPresented: $showHelp) {
                        Button {
                            showHelp.toggle()
                        } label: {
                            Text("OK")
                        }
                    }

                }
                .padding(.vertical, 15)
                .padding(.horizontal, 35)
                
                
                //List of vocabCollections - from CoreData
                List{
                    ForEach(vocabCollections) { collection in
                        NavigationLink {
                            VocabCollectionScreen(model: collection, refreshVocabCollectionList: $refreshVocabCollectionList)
                        } label: {

                                Text(collection.title ?? "")
                                    .font(.title2)
                                    .padding(.vertical, 15)
                        }
                        .padding(.horizontal, 20)
                    }.onDelete(perform: deleteCollection)
                }
                .navigationTitle("Vocab Lists")
            }
            
            
            //Sheet for add a new VocabCollection
            .sheet(isPresented: $showAddCollection, content: {
                AddCollectionSheet(refreshVocabCollectionList: $refreshVocabCollectionList)
            })
            //Sheet of Settings
            .sheet(isPresented: $showSettingsSheet, content: {
                SettingSheet(showSettings: $showSettingsSheet)
            })
            //Sheet of PayWall
            .sheet(isPresented: $showPayWallSheet, content: {
                PayWallSheet(showPayWall: $showPayWallSheet)
            })
            
            //small hack to trigger View refresh
            .listStyle(refreshVocabCollectionList ?  PlainListStyle() : PlainListStyle())
            
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }//toolbar
        }//navigationView
    }//body
    
    
    //Allow up to X collections if !subscripted. Unlimited if subscripted
    private func addCollectionWithCheck() {
        if vocabCollections.count < AppSetting.shared.maxCollectionsForNonPayUser {
            showAddCollection.toggle()
        } else {
            if !subScriptionViewModel.isSubscriptionActive {
                print("vocabCollections.count >= limit")
                showPurchaseOption.toggle()
            } else {
                showAddCollection.toggle()
            }
        }

    }
    
    private func deleteCollection(offsets: IndexSet) {
        withAnimation {
            offsets.map { vocabCollections[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}//struct


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VocabCollectionListScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
