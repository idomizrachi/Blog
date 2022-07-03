//
//  PostDate.swift
//  
//
//  Created by Ido Mizrachi on 29/06/2022.
//

import Foundation

///var date: String? = nil //YYYY-MM-dd - https://www.iso.org/iso-8601-date-and-time-format.html
struct PostDate {
    let year: Int
    let month: Int
    let day: Int
    let date: Date
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)        
    }
}
