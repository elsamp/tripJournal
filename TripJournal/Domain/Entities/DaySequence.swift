//
//  DaySequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation


class DaySequence: ObservableObject, Identifiable {
    
    let id: String
    @Published var days: Set<Day>
    
    init(id: String, days: Set<Day>) {
        self.id = id
        self.days = days
    }
    
    func add(day: Day) {
        days.insert(day)
    }
    
    func remove(day: Day) {
        days.remove(day)
    }
}
