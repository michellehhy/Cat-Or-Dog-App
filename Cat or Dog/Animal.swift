//
//  Animal.swift
//  Cat or Dog
//
//  Created by Michelle on 16/10/2021.
//

import Foundation
import CoreML
import Vision

struct Result: Identifiable {
    var imageLabel: String
    var confidence: Double
    var id = UUID()
}

class Animal {
    
    // url for image
    var imageUrl: String
    
    // image data
    var imageData: Data?
    
    //classified results
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init(){
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
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
        self.results = []
        
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
                self.classifyAnimal()
            }
        }
        
        //start data task
        dataTask.resume()
    }
    
    func classifyAnimal() {
        
        //get reference to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        //create an image handler
        let handler = VNImageRequestHandler(data:imageData!)
        
        //create request to the model
        let request = VNCoreMLRequest(model: model) { request, error in
           
            guard let results = request.results as? [VNClassificationObservation] else{
                print("Couldn't classify animal")
                return
            }
            
            for classification in results {
                
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
        }
        //execute the request
        do {
            try handler.perform([request])
        }catch {
            print("Invalid Image")
        }
        
    }
    
    
}
