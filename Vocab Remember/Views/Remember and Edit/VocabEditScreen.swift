//
//  VocabEditView.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI


//Screen for edit existing Vocab, from VocabCollectionScreen, or RememberScreen
struct VocabEditScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let model: Vocab
    
    @State var inLang1 : String
    @State var inLang2 : String
    
    @Binding var refreshVocabViews : Bool
    
    
    init (model: Vocab, refreshHack: Binding<Bool>) {
        self.model = model
//        self._refreshHack = Binding(initialValue: refreshHack)
        self._refreshVocabViews = refreshHack
        self._inLang1 = State(initialValue: model.inLang1 ?? "")
        self._inLang2 = State(initialValue: model.inLang2 ?? "")
    }
    
    
    //MARK: work with the unsuccessful try from VocabCollectionScreen
    //    @Binding var model : Vocab
//        init (model: Binding<Vocab>, refreshHack: Binding<Bool>) {
//        self._model = model
////        self._refreshHack = Binding(initialValue: refreshHack)
//        self._refreshVocabViews = refreshHack
////        self._inLang1 = State(initialValue: model.inLang1!)
////        self._inLang2 = State(initialValue: model.inLang2 ?? "")
//    }

    
    var body: some View {
        
        //work with the unsuccessful try from VocabCollectionScreen
//        var inLang1Binding = Binding(
//            get: { self.model.inLang1 },
//            set: { self.model.inLang1 = $0 }
//        )
//        var inLang2Binding = Binding(
//            get: { self.model.inLang2 },
//            set: { self.model.inLang2 = $0 }
//        )
        
        VStack{
            Spacer()
            
            //Text Editor for "Vocab In English"
            HStack{
                Text("Vocab in English")
                    .padding(.leading, 20)
                Spacer()
            }
//            TextEditor(text: Binding(get: {inLang1Binding ?? ""} , set: {inLang1Binding = $0})) ///unsuccessful try
            TextEditor(text: $inLang1)
                .frame(height: 200)
                .border(Color.accentColor)
                .cornerRadius(3)
                .padding(.horizontal, 20)
            
            //Text Editor for "Vocab Meaning"
            HStack{
                Text("Vocab Meaning")
                    .padding(.leading, 20)
                Spacer()
            }
//            TextEditor(text: inLang2Binding) ///unsuccessful try
            TextEditor(text: $inLang2)
                .frame(height: 200)
                .border(Color.accentColor)
                .cornerRadius(3)
                .padding(.horizontal, 20)
            
            
            //Save,Cancel
            HStack{
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    EditVocab()
                    refreshVocabViews.toggle()
                    dismiss()
                } label: {
                    Text("Save")
                }
                Spacer()
            }
            
            Spacer()
        }///VStack
        
        
    }///body
    
    
    
    private func EditVocab(){
        //Worked method
        model.inLang1 = inLang1
        model.inLang2 = inLang2
        model.timestamp = Date()
        
//        //with unsuccessful try
//        model.inLang1 = inLang1
//        model.inLang2 = inLang2

        do {
            try viewContext.save()
            print("viewContext.save()")
        } catch {
            //MARK: TODO
        }
    }
    
}//struct

//struct VocabEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        VocabEditView()
//    }
//}
