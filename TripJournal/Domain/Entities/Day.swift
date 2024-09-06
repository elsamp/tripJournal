//
//  Day.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


class Day: ObservableObject, Identifiable, Hashable, Equatable {
    
    let id: String
    let trip: Trip
    @Published var date: Date
    @Published var title: String
    @Published var coverPhotoPath: String?
    @Published var coverImageData: Data?
    @Published var creationDate: Date
    @Published var lastUpdateDate: Date
    @Published var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Trip has never been saved.
            return true
        }
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}




