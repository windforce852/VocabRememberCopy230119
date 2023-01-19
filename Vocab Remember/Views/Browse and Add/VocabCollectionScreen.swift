//
//  VocabCollectionView.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI
import CoreData

struct VocabCollectionScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext //CoreData
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel //RevenueCat
        
    var model: VocabCollection //Get the single VocabCollection from parent view
    
    @Binding var refreshVocabCollectionList:Bool //refresh hack for parent view
    @State var refreshVocabCollection:Bool = false //refresh hack for child view
    
    @State private var showAddVocab:Bool = false
    @State private var showPurchaseOption: Bool = false
    @State private var showPayWallSheet: Bool = false
    @State private var showHelp: Bool = false
    
    //Picker
    @State private var sortWaySelection: String = "By Title"
    let sortWays = ["By Title", "By Date"]
    @State private var selectedIndex = 0
    
    //MARK: PETER: when .onChange active, the sorted [Vocab] array is expected to be assigned to this state var, and use if in List ForEach
    @State var arrayInModel : [Vocab]? = nil

    
    
    //Another unsuccessful try
//    @State var arrayInModel : [Vocab]
//    var vocabArray1: [Vocab] {
//        let set = model.vocabCollectionToVocab as? Set<Vocab> ?? []
//        return set.sorted{
//            $0.inLang1! > $1.inLang1!
//        }
//    }
//    var vocabArray2: [Vocab] {
//        let set = model.vocabCollectionToVocab as? Set<Vocab> ?? []
//        return set.sorted{
//            $0.timestamp! < $1.timestamp!
//        }
//    }
//    init (model: VocabCollection, refreshHack: Binding<Bool>) {
//        self.model = model
//        self._arrayInModel = State(initialValue: vocabArray1)
//    }

    
    
    var body: some View {
        ZStack{
            VStack{
                
                //Picker
                HStack{
                    Spacer()
                    Picker("Sort", selection: $sortWaySelection) {
                        ForEach(sortWays, id: \.self) {
                            Text($0)
                        }
                    }
                    //MARK: PETER: I moved the code from VocabCollection+Extension to here, try to get the vocabCollectionToVocab Set (from parent view) and make it a sorted array. Depends on picker choice, it will be sorted by alphabet or timestamp
//                    .onChange(of: selectedIndex, perform: { newValue in
//                        if newValue == 0 {
//                            arrayInModel = (model.vocabCollectionToVocab as? Set<Vocab> ?? [] ).sorted{$0.inLang1! < $1.inLang1!}
//                        } else {
//                            arrayInModel = (model.vocabCollectionToVocab as? Set<Vocab> ?? [] ).sorted{$0.timestamp! < $1.timestamp!}
//                        }
//                    }
//                    )
                    .pickerStyle(.menu)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                }
                
                //Button AddVocab and showHelp
                HStack{
                    //AddVocab
                    Button {
                        addVocabWithCheck()
                    } label: {
                        Text("Add Vocab")
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
                    .alert("Create vocabs here, and then press 'Exercise' to remember the vocabs ", isPresented: $showHelp) {
                        Button {
                            showHelp.toggle()
                        } label: {
                            Text("OK")
                        }
                    }
                }///HStack
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                
                
                //List ForEach of vocabCollectionToVocab sorted array
                List {
                    //MARK: PETER: the actived one is my original method. the app can run but the List will not change. The commented line is the method work with .onChange, with bugs
                    ForEach(sortWaySelection == "By Title" ? model.vocabArrayByAlphabet : model.vocabArrayByTimestamp) { vocab in
//                    ForEach($arrayInModel, id: \.self) { vocab in
                        NavigationLink {
                            VocabEditScreen(model: vocab, refreshHack: $refreshVocabCollection)
                        } label: {
                            Text(vocab.inLang1 ?? "")
                        }
                    }
                    .onDelete(perform: deleteVocab)
                }///List
            }///VStack
            
            //Stay on screen Island with button Exercise, to trigger RememberScreen
            VStack{
                Spacer()
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                ZStack{
                    Rectangle()
                        .frame(height: 80)
                        .foregroundColor(.white)
                    NavigationLink {
                        RememberScreen(model: model)
                    } label: {
                        ZStack{
                            Rectangle()
                                .frame(width: 250, height: 50)
                                .cornerRadius(25)
                                //If the counting of the array of ForEach == 0, the button is gray, else, blue
                                .foregroundColor((selectedIndex == 0 ? model.vocabArrayByAlphabet : model.vocabArrayByTimestamp).count == 0 ? .gray : .blue)
                            Text("Exercise")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }///ButtonLabel
                    //If the counting of the array of ForEach == 0, the button is disabled, else, active
                    .disabled((selectedIndex == 0 ? model.vocabArrayByAlphabet : model.vocabArrayByTimestamp).count == 0 ? true : false )
                }///ZStack
            }///VStack
        }///ZStack
        
        
        .navigationTitle(model.title ?? "")
        .listStyle(refreshVocabCollection ? PlainListStyle() : PlainListStyle()) //refresh hack
        
        
        .sheet(isPresented: $showAddVocab, content: {
            AddVocabSheet(model: model, refreshVocabColleciton: $refreshVocabCollection)
        })
        .sheet(isPresented: $showPayWallSheet, content: {
            PayWallSheet(showPayWall: $showPayWallSheet)
        })
        
        
    }//body some view
    
    
    //----------FUNC----------
    
    //Allow up to X Vocabs if !subscripted. Unlimited if subscripted
    private func addVocabWithCheck() {
        //un pay
        guard subscriptionViewModel.isSubscriptionActive else {
            if (sortWaySelection == "By Title" ? model.vocabArrayByAlphabet : model.vocabArrayByTimestamp).count >= AppSetting.shared.maxVocabsForNonPayUser {
                print(">=7")
                showPurchaseOption.toggle()
            } else {
                showAddVocab.toggle()
            }
            return
        }
        showAddVocab.toggle()
    }
    
    
    private func deleteVocab(offsets: IndexSet) {
        withAnimation {
            offsets.map{ model.vocabArrayByAlphabet[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}///struct




//struct VocabCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        VocabCollectionView()
//    }
//}
