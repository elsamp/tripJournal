//
//  Trip.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation


struct Trip: Hashable{

    let id: String
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var coverPhotoPath: String?
    var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
}

