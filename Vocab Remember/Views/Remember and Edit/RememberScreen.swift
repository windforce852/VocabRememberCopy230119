//
//  RememberView.swift
//  Vocab Remember
//
//  Created by Kwan Ho Leung on 25/12/2022.
//

import SwiftUI
import CoreData
import AVFoundation


//Screen for user to loop through the VocabCollection and memorize the vocabs
struct RememberScreen: View {
    
    var model: VocabCollection //from parent view
    var vocabArray: [Vocab] {
        let set = model.vocabCollectionToVocab as? Set<Vocab> ?? []
        return set.sorted{
            $0.inLang1! > $1.inLang1!
        }
    }
    @State private var arrayCounting: Int = 0

    @EnvironmentObject private var speakMan: SpeakManager //AVFoundation
    
    @State private var showLang1:Bool = true
    @State private var showLang2:Bool = false
    
    @State var refreshHack = false //refresh hack
    
    
    
    
    var body: some View {
        VStack{
            Spacer()
            
            //Button to edit current Vocab
            NavigationLink {
                VocabEditScreen(model: vocabArray[arrayCounting], refreshHack: $refreshHack)
            } label: {
                Text("Edit")
            }


            
            
            //Titie "In English", button to pronounce, button to show hide Vocab in english, and the vocab in english
            Group {
                HStack{
                    Spacer()
                    //title
                    Text("In English")
                        .padding()
                    
                    //button to show hide
                    Button {
                        showLang1.toggle()
                    } label: {
//                        showLang1 == true ? Image(systemName: "eye") : Image(systemName: "eye.slash")
                        if showLang1 == true {
                            Image(systemName: "eye")
                        } else {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    //Button to pronounce the vocab
                    Button {
                        speakMan.pronounce(sound: vocabArray[arrayCounting].inLang1 ?? "")
    //                    SpeakManager.shared.speak(sound: vocabArray[arrayCounting].inLang1 ?? "")
                    } label: {
                        Image(systemName: "speaker")
                    }
                    Spacer()
                }
                //Testing UI method A
    //            ZStack{
    //                Rectangle()
    //                    .frame(width: 300, height: 150)
    //                    .foregroundColor(.gray)
    //                if showLang1 == true {
    //                    Text(vocabArray[arrayCounting].inLang1 ?? "")
    //                } else {
    //                    Image(systemName: "eye.slash")
    //                }
    //            }
                //Testing UI method B
                Text(showLang1 == true ? vocabArray[arrayCounting].inLang1 ?? "" : "......")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(width: 400, height: 200)
                    .background(content: {
                        Rectangle().fill(.yellow).shadow(radius: 3)
                    })
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            
            
            //Title "Meaning" of the vocab, button to show hide the vocab meaning, and the vocab meaning
            Group {
                HStack{
                    Spacer()
                    //title
                    Text("Meaning")
                        .padding()
                    
                    //button show hide
                    Button {
                        showLang2.toggle()
                    } label: {
    //                    Text("Show/Hide")
//                        showLang2 == true ? Image(systemName: "eye") : Image(systemName: "eye.slash")
                        if showLang2 == true {
                            Image(systemName: "eye")
                        } else {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    Spacer()
                }
                
                //Testing UI method A
    //            ZStack{
    //                Rectangle()
    //                    .frame(width: 300, height: 150)
    //                    .foregroundColor(.gray)
    //                if showLang2 == true {
    //                    Text(vocabArray[arrayCounting].inLang2 ?? "")
    //                } else {
    //                    Image(systemName: "eye.slash")
    //                }
    //            }
                
                //Testing UI method B
                Text(showLang2 == true ? vocabArray[arrayCounting].inLang2 ?? "" : "......")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(width: 400, height: 200)
                    .background(content: {
                        Rectangle().fill(.yellow).shadow(radius: 3)
                    })
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            
            
            Spacer()
            
            
            //Controls for selecting Vocab in the collection: Next, Last, and RandomNext
            HStack {
                Spacer()
                
                Button {
                    lastVocab()
                } label: {
                    Text("Last")
                }

                Spacer()
                
                Button {
                    randomVocab()
                } label: {
                    Text("Random")
                        .foregroundColor(refreshHack ? Color(UIColor(.accentColor)) : Color(UIColor(.accentColor))) //refresh hack
                }
                
                Spacer()
                
                Button {
                    nextVocab()
                } label: {
                    Text("Next")
                }
                
                Spacer()
            }
            
            
            Spacer()
        }///VStack
    }/// var body some view
    
    
    
    
    private func lastVocab(){
        if arrayCounting > 0 {
            arrayCounting -= 1
        } else {
            arrayCounting = vocabArray.count - 1
        }
    }
    
    private func nextVocab(){
        if arrayCounting < vocabArray.count - 1 {
            arrayCounting += 1
        } else {
            arrayCounting = 0
        }
    }
    
    private func randomVocab(){
        let tempInt = Int.random(in: 0...vocabArray.count - 1)
        print("RANDOM")
        print("tempInt =\(tempInt)")
        if tempInt != 0 && tempInt == arrayCounting{
            print("tempInt != 0 && tempInt == arrayCounting ; arrayCounting = tempInt - 1")
            arrayCounting = tempInt - 1
        } else if tempInt == 0 && tempInt == arrayCounting {
            print("tempInt == 0 && tempInt == arrayCounting ; arrayCounting = tempInt + 1")
            arrayCounting = tempInt + 1
        } else {
            print("arrayCounting = tempInt")
            arrayCounting = tempInt
        }
    }
    
}

//struct RememberView_Previews: PreviewProvider {
//    static var previews: some View {
//        RememberView()
//    }
//}
