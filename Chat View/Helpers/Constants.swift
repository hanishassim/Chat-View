//
//  Constants.swift
//  ContactList
//
//  Created by H on 08/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

let accentColor = "#E21415".hexToUIColor()

extension Notification.Name {
    static let DidSaveContactInfo = Notification.Name("DidSaveContactInfo")
}

typealias chatListCompletion = (_ chats: [Chat]) -> Void

enum ChatDirection: String, Codable {
    case incoming = "INCOMING"
    case outgoing = "OUTGOING"
}
