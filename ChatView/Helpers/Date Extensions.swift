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
    
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    
    func printTime() -> String {
        let dateFormatterPrint = DateFormatter()
        
        let dateFormat = "h:mm a"
        dateFormatterPrint.dateFormat = dateFormat
        
        return dateFormatterPrint.string(from: self)
    }
    
    var printDayAndDate: String {
        guard !Calendar.current.isDateInToday(self) else {
            return "Today"
        }
        
        guard !Calendar.current.isDateInYesterday(self) else {
            return "Yesterday"
        }
        
        let dateFormatterPrint = DateFormatter()
        var dateFormat = "EE"
        
        if !Date().isInSameWeek(date: self) {
            dateFormat += ", d MMM"
            
            if !Date().isInSameYear(date: self) {
                dateFormat += " yyyy"
            }
        }
        
        dateFormatterPrint.dateFormat = dateFormat
        
        return dateFormatterPrint.string(from: self)
    }
    
    var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.string(from: self)
    }
}
