//
//  API.swift
//  photo-list-tableview
//
//  Created by Mark bergeson on 7/11/21.
//

import Foundation

class API {
    
    static let shared = API()
    
    
    func getPhotoData(page: Int, onComplete: @escaping (_ items: [PhotoList]?) -> ()) {
        
        guard let url = URL(string: "https://api.unsplash.com/photos/?client_id=svXRThWsNdNleok_Es69R_QcvcQ6FEhDi3CuOlLS-QM&page=\(page)&per_page=15&order_by=popular") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([PhotoList].self, from: data)
                DispatchQueue.main.async {
                    onComplete(json)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getImage(urlString: String, onComplete: @escaping (_ data: Data?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                onComplete(data)
            }
        }
        
        task.resume()
    }
    
}
