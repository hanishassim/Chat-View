//
//  APIRequest.swift
//  Chat View
//
//  Created by H on 13/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

enum APIError: Error {
    case response
    case encoding
    case serialization
    case decoding
    case other
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "https://reqres.in/api/\(endpoint)"
        
        guard let resourceURL = URL.init(string: resourceString) else {
            fatalError()
        }
        
        self.resourceURL = resourceURL
    }
    
    func send(message: String, completion: @escaping(Result<Chat, APIError>) -> Void) {
        do {
            var urlRequest = URLRequest.init(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let messageDict = ["message": message]
            let encoder = JSONEncoder()
            
            let jsonData = try encoder.encode(messageDict)
            
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201, let jsonData = data else {
                    completion(.failure(.response))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        // try to read out a string array
                        guard let message = json["message"] as? String, let createdAt = json["createdAt"] as? String else {
                            completion(.failure(.other))
                            
                            return
                        }
                        
                        let chat = Chat.init(timestamp: createdAt, direction: .outgoing, message: message)
                        
                        completion(.success(chat))
                    }
                } catch {
                    completion(.failure(.serialization))
                }
            }
             dataTask.resume()
        } catch {
            completion(.failure(.encoding))
        }
    }
}
