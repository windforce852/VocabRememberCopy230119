//
//  AddCollectionView.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 22/12/2022.
//

import SwiftUI

//Sheet for Add a new VocabCollection
struct AddCollectionSheet: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var collectionName = ""
    @Binding var refreshVocabCollectionList:Bool
    
    var body: some View {
        VStack{
            TextField("Input Collection Name", text: $collectionName)
                .padding()
            Button {
                addCollection()
                refreshVocabCollectionList.toggle()
                dismiss()
            } label: {
                Text("Save")
            }
        }.navigationTitle("Add Collection")
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        
    }
    
    private func addCollection(){
        let vocabCollection = VocabCollection(context: viewContext)
        vocabCollection.id = UUID()
        vocabCollection.timestamp = Date()
        vocabCollection.title = collectionName
        do {
            try viewContext.save()
            print("viewContext.save()")
        } catch {
            //MARK: TODO
        }
    }
}

//struct AddCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCollectionSheet()
//    }
//}
