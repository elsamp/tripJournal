//
//  Content.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

struct Content: Identifiable, Codable {
    
    let id: String
    var type: ContentType
    var filePath: String?
    var description: String?
    let creationDate: Date
    let lastUpdateDate: Date

}

enum ContentType: String, Codable {
    case text
    case photo
    //case video
}

struct ContentSequence: Identifiable, Codable {
    let id: String
    let sequence: [Content]
}



