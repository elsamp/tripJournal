//
//  DayObjectModel+day.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation

extension DayObjectModel {
    
    func toDay(for trip: Trip) -> Day {
        Day(id: self.id,
            trip: trip,
            date: self.date,
            title: self.title,
            coverPhotoPath: self.coverPhotoPath,
            creationDate: self.creationDate,
            lastUpdateDate: self.lastUpdateDate,
            lastSaveDate: self.lastUpdateDate)
    }
}
