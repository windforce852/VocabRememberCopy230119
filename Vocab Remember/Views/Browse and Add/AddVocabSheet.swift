//
//  AddVocabSheet.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI

//Sheet for add a new Vocab to a VocabCollection
struct AddVocabSheet: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let model: VocabCollection
    
    @Binding var refreshVocabColleciton: Bool //refresh hack
    
    @State var inLang1 = ""
    @State var inLang2 = ""
    
    var body: some View {
        NavigationView {
            VStack{
                
                //Input the Vocab in english
                HStack{
                    Text("Vocab in English")
                        .font(.title3)
                        .padding(.leading, 20)
                    Spacer()
                }
                TextField("Input vocab in English", text: $inLang1)
                    .textFieldStyle(.roundedBorder)
                    .border(Color.blue)
                    .font(Font.system(size: 60, design: .default))
                    .cornerRadius(3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                //Input the meaning of the Vocab in user's mother language
                HStack{
                    Text("Vocab Meaning")
                        .font(.title3)
                        .padding(.leading, 20)
                    Spacer()
                }
                TextEditor(text: $inLang2)
                    .font(.title3)
                    .frame(height: 200)
                    .border(Color.blue)
                    .cornerRadius(3)
                    .padding(.horizontal, 20)
                
                //Button addVocab
                Button {
                    addVocab()
                    refreshVocabColleciton.toggle()
                    dismiss()
                } label: {
                    Text("Save")
                }
            }//VStack
            .navigationTitle("Add Vocab")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }//toolBar
        }//NavView
    }//body
    
    private func addVocab(){
        let vocab = Vocab(context: viewContext)
        vocab.id = UUID()
        vocab.timestamp = Date()
        vocab.inLang1 = inLang1
        vocab.inLang2 = inLang2
        model.addToVocabCollectionToVocab(vocab)
        do {
            try viewContext.save()
            print("viewContext.save()")
        } catch {
            print("add Vocab fail")
        }
    }
}//struct



//struct AddVocabSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        AddVocabSheet()
//    }
//}
