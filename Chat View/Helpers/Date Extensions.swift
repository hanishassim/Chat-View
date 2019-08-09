//
//  Date Extensions.swift
//  Chat View
//
//  Created by H on 09/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

extension Date {
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    
    func printDayAndDate() -> String {
        let dateFormatterPrint = DateFormatter()
        
        var dateFormat = "E, d MMM"
        if !self.isInSameYear(date: Date()) {
            dateFormat += " yyyy"
        }
        dateFormatterPrint.dateFormat = dateFormat
        
        return dateFormatterPrint.string(from: self)
    }
    
    func printTime() -> String {
        let dateFormatterPrint = DateFormatter()
        
        let dateFormat = "h:mm a"
        dateFormatterPrint.dateFormat = dateFormat
        
        return dateFormatterPrint.string(from: self)
    }
}
