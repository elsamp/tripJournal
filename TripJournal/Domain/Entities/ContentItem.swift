//
//  Content.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

enum ContentType: String {
    case text
    case photo
}

struct ContentItem: Hashable {
    
    let id: String
    let day: Day
    var sequenceIndex: Int
    var type: ContentType
    var text: String
    var photoFileName: String?
    var photoData: Data?
    let creationDate: Date
    var displayTimestamp: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?

}








