//
//  Day.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


class Day: ObservableObject, Identifiable, Hashable, Equatable, Comparable {
    
    let id: String
    let trip: Trip
    @Published var date: Date
    @Published var title: String
    @Published var coverPhotoPath: String?
    @Published var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Day has never been saved.
            return true
        }
    }
    
    var tripDayIndex: Int {
        
        return Calendar.current.daysBetween(trip.startDate, and: date) + 1
        
    }
    
    init(id: String, trip: Trip, date: Date, title: String, coverPhotoPath: String? = nil, creationDate: Date, lastUpdateDate: Date, lastSaveDate: Date? = nil) {
        self.id = id
        self.trip = trip
        self.date = date
        self.title = title
        self.coverPhotoPath = coverPhotoPath
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate
        
        self.coverImageData = ImageHelperService.shared.imageDataFor(day: self)
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.date < rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}




