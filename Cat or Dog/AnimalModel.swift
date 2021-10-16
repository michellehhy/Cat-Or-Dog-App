//
//  AnimalModel.swift
//  Cat or Dog
//
//  Created by Michelle on 16/10/2021.
//

import Foundation

class AnimalModel: ObservableObject {
    
    @Published var animal = Animal()
    
    func getAnimal() {
        let stringURL = Bool.random() ? catUrl : dogUrl
        
        //create and check url object -> network request
        let url = URL(string: stringURL)
        
        guard url != nil else{
            print("couldn't create URL Object")
            return
        }
        
        //create URL session
        let session = URLSession.shared
        
        //create data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                
                //parse json to array of dict
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:Any]] {
                        
                        let item = json.isEmpty ? [:] : json[0]
                        
                        if let animal = Animal (json:item) {
                            
                            DispatchQueue.main.async {
                                
                                //update after imagedata is loaded
                                while animal.imageData == nil {
                                
                                }
                                self.animal = animal
                            }
                        }
                    }
                    
                    
                }catch{
                    print(error)
                }
            }
        }
        //start data task
        dataTask.resume()
        
        
    }
}
