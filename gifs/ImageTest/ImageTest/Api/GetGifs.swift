//
//  GetGifs.swift
//  ImageTest
//
//  Created by Maximilian Boiko on 08.03.2021.
//

import Foundation
import RealmSwift

class GetGifs{
    
    static let shared = GetGifs()
    
    let serviseQueue = DispatchQueue.init(label: "getGifs", qos: .userInitiated, attributes: .concurrent)
    
    private let session = URLSession.init(configuration: .default)
    
    func loadGifFromURl(imageObject: ImageRealm, completion: ((Data?,Error?) -> Void)?){
       
        if let data = imageObject.gifData{
            completion?(data,nil)
            return
        }
        
        guard let url = URL(string: imageObject.url) else {return}
        let urlReauest = URLRequest(url: url)
        
        serviseQueue.async {
        
            self.session.dataTask(with: urlReauest , completionHandler: {(data,response,error) in
            
                if let image = data, !image.isEmpty {
                    DispatchQueue.main.async {
                        do{
                            let realm = try! Realm()
                            completion?(image,nil)
                            try realm.write({
                                imageObject.gifData = image
                                realm.add(imageObject)
                            })
                            
                        }catch{
                            completion?(nil,error)
                        }
                    }
                }
            }).resume()
        }
    }
}
