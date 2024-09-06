//
//  Trip.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


class Trip: ObservableObject, Identifiable, Hashable, Equatable {

    let id: String
    @Published var title: String
    @Published var description: String
    @Published var startDate: Date
    @Published var endDate: Date
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
        
        self.coverImageData = ImageHelperService.shared.imageDataFor(trip: self)
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}


