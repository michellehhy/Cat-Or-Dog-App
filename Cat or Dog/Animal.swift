//
//  Animal.swift
//  Cat or Dog
//
//  Created by Michelle on 16/10/2021.
//

import Foundation

class Animal {
    
    // url for image
    var imageUrl: String
    
    // image data
    var imageData: Data?
    
    init(){
        self.imageUrl = ""
        self.imageData = nil
    }
    
    //optional initialiser that can return nil
    init? (json: [String:Any]){
        
        //check if json has url
        guard let imageUrl = json["url"] as? String else{
            return nil
        }
        
        //set animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        
        //dl image
        getImage()
        
    }
    
    func getImage(){
        
        //create + check URL object
        let url = URL(string: imageUrl)
        
        guard url != nil else {
            print("Couldn't get URL Object")
            return
        }
        //get URL session
        let session = URLSession.shared
        
        //create data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            if error == nil && data != nil {
                self.imageData = data
            }
        }
        
        //start data task
        dataTask.resume()
    }
    
    
}
