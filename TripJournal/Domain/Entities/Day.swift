//
//  Day.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


struct Day: Hashable {
    
    let id: String
    let trip: Trip
    var date: Date
    var title: String
    var coverPhotoPath: String?
    var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    
}




