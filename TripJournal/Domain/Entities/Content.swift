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
    //case video
}

class Content: ObservableObject, Identifiable, Hashable, Comparable {
    
    let id: String
    let day: Day
    @Published var sequenceIndex: Int
    @Published var type: ContentType
    @Published var text: String?
    @Published var photoFileName: String?
    @Published var photoData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Content has never been saved.
            return true
        }
    }
    
    init(id: String, day: Day, sequenceIndex: Int, type: ContentType, photoFileName: String?, text: String?, creationDate: Date, lastUpdateDate: Date, lastSaveDate: Date?) {
        self.id = id
        self.day = day
        self.sequenceIndex = sequenceIndex
        self.type = type
        self.photoFileName = photoFileName
        self.text = text
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate
        
        self.photoData = ImageHelperService.shared.imageDataFor(content: self)
    }
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Content, rhs: Content) -> Bool {
        lhs.sequenceIndex < rhs.sequenceIndex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}






