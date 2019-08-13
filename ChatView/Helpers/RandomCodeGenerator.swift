//
//  RandomCodeGenerator.swift
//  ContactList
//
//  Created by H on 08/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

struct RandomCodeGenerator {
    fileprivate let letters = "0123456789abcdefghijklmnopqrstuvwxyz"
    
    func randomString(length: Int = 24) -> String {
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
