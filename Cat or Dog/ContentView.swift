//
//  ContentView.swift
//  Cat or Dog
//
//  Created by Michelle on 01/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: AnimalModel 
    
    var body: some View {
        VStack {
            GeometryReader{geometry in
                //cannot create image from data directly, create a UI image first
                Image(uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            }
            
            
            HStack{
                Text("What is it?")
                    .font(.title)
                    .bold()
                    .padding(.leading,10)
                
                Spacer()
                Button(action: {
                    self.model.getAnimal()
                }, label: {
                    Text("Next")
                        .bold()
                })
                .padding(.trailing, 10)
                
            }
            if #available(iOS 14.0, *) {
                ScrollView {
                    LazyVStack {
                        ForEach(model.animal.results) {result in AnimalRow(imageLabel: result.imageLabel, confidence: result.confidence)
                            .padding(.horizontal)
                        }
                    }
                }
            }else {
                List(model.animal.results) {result in
                    AnimalRow(imageLabel: result.imageLabel, confidence: result.confidence)
                        .padding(.horizontal)
                }

            
            }
        }
        .onAppear(perform: model.getAnimal)
        //show text when image is shown
        .opacity(model.animal.imageData == nil ? 0 :1 )
        .animation(.easeIn)
        
    }
}

//struct ContentView_Previews: Preview Provider {
//    static var previews: some View {
//        ContentView(model:AnimalModel())
//    }
//}
