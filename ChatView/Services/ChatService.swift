//
//  ChatService.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

class ChatService {
    // MARK: - ContactInfo getter and setter functions
    func getChatList(completion: chatListCompletion) {
        loadBundleJSON(completion: { (chats) in
            completion(chats)
        })
    }
    
    // MARK:- To decode JSON file to conform by ContactInfo object
    fileprivate func decodeFileToChat(_ filename: URL, _ completion: chatListCompletion) throws {
        let data = try Data(contentsOf: filename, options: .mappedIfSafe)
        //Convert to JSON format
        do {
            let decoder = JSONDecoder()
            let jsonResult = try decoder.decode(Root.self, from: data)
            
            completion(jsonResult)
        } catch let jsonError {
            print("The file data.json could not be decoded. ", jsonError)
        }
    }
    
    // MARK: To load JSON from Bundle (XCode directory)
    fileprivate func loadBundleJSON(completion: chatListCompletion) {
        if let path = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                try decodeFileToChat(path, completion)
            } catch {
                print("The file data.json could not be loaded")
            }
        }
    }
}
