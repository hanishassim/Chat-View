//
//  Chat.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

enum ChatDirection: String, Codable {
    case incoming = "INCOMING"
    case outgoing = "OUTGOING"
}

struct Chat: Codable {
    let timestamp: String
    let direction: ChatDirection
    let message: String
    
    func generateDateFromTimestampString() -> Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: timestamp) {
            return date
        }
        
        return nil
    }
}

// Struct Root - To conform to the format for json data
struct Root: Decodable {
    private enum CodingKeys: String, CodingKey {
        case chats = "chat"
    }
    let chats: [Chat]
}
