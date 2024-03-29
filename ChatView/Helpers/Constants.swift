//
//  Constants.swift
//  ContactList
//
//  Created by H on 08/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

let accentColor = "#E21415".hexToUIColor()
let formatter = DateFormatter()

typealias chatListCompletion = (_ chats: Root) -> Void

extension Notification.Name {
    static let DidSaveContactInfo = Notification.Name("DidSaveContactInfo")
}
