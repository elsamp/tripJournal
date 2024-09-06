//
//  Date+SecondsForDays.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


extension Date {
    
    static func secondsForDays(_ dayCount: Double) -> Double {
        return 86400 * dayCount
    }
    
    static func dateFor(days: Double, since date: Date) -> Date {
        Date(timeInterval: secondsForDays(days), since: date)
    }
}
