//
//  Trip.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


class Trip: ObservableObject, Identifiable, Hashable, Equatable, Comparable {

    let id: String
    @Published var title: String
    @Published var description: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var coverPhotoPath: String?
    @Published var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Trip has never been saved.
            return true
        }
    }
    var tripYear: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self.startDate)
    }
    
    init(id: String, 
         title: String = "",
         description: String = "",
         startDate: Date, endDate: Date,
         coverPhotoPath: String? = nil,
         creationDate: Date,
         lastUpdateDate: Date,
         lastSaveDate: Date?) {
        
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.coverPhotoPath = coverPhotoPath
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate
        
        resetCoverPhotoData()
    }
    
    func resetCoverPhotoData() {
        self.coverImageData = ImageHelperService.shared.imageDataFor(trip: self)
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        lhs.startDate < rhs.startDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}


