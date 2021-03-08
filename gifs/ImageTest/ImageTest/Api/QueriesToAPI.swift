//
//  QueriesToAPI.swift
//  ImageTest
//
//  Created by Maximilian Boiko on 03.03.2021.
//

import Foundation


class QueriesToAPI{
    static let shared = QueriesToAPI()
    
    weak var delegate : ShowAlert?
    
    private let session = URLSession.init(configuration: .default)
        
    func buildAdsoluteUrl(search query: String)-> String{
        let api = "https://api.giphy.com"
        let searchEndpoint = "/v1/gifs/search?"
        let apikey =  "api_key=zKxwlzDUE8rp6tfZ7kql8P8ZfF1VsjKb&"
        let search = "q=\(query)&"
        let limit = "limit=1&offset=0&rating=g&lang=en"
        
        let adsolutionUrl = api + searchEndpoint + apikey + search + limit
        return adsolutionUrl
    }
    
    func getImage(query:String, completion: (([ImageData]?, Error?) -> Void)?){
        
        let absolutionUrl = buildAdsoluteUrl(search:query)
        
        guard let url = URL(string: absolutionUrl) else {
            delegate?.show()
            return}
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if error == nil{
                print("work")
            } else{
                print("noo")
            }
        
            if let jsonData = data, !jsonData.isEmpty {
                print(jsonData)
                do{
                    let result = try! JSONDecoder().decode(ImageListModel.self, from: jsonData)
                    
                    completion?(result.data,nil)
                }catch{
                    completion?(nil,error)
                }
            }
        }).resume()
    }
}

