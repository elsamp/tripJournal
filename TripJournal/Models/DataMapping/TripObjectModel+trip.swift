//
//  TripObjectModel+trip.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-01.
//

import Foundation

extension TripObjectModel {
    
    func trip() -> Trip {
        return Trip(id: self.id,
                    title: self.title,
                    description: self.summaryText,
                    startDate: self.startDate,
                    endDate: self.endDate,
                    coverPhotoPath: self.coverPhotoPath,
                    creationDate: self.creationDate,
                    lastUpdateDate: self.lastUpdateDate,
                    lastSaveDate: self.lastSaveDate)
    }
}
