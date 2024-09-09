//
//  Calendar+daysBetween.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-09.
//

import Foundation


extension Calendar {
    
    func daysBetween(_ fromDate: Date, and toDate: Date) -> Int {
        
        let fromDay = startOfDay(for: fromDate)
        let toDay = startOfDay(for: toDate)
        
        let numberOfDays = dateComponents([.day], from: fromDay, to: toDay)
        
        return numberOfDays.day ?? 0
    }
}
