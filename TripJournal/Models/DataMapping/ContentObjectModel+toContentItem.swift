//
//  ContentObjectModel+content.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import Foundation

extension ContentObjectModel {
    
    func toContentItem(for day: Day) -> ContentItem {
        return ContentItem(id: self.id,
                           day: day,
                           sequenceIndex: self.sequenceIndex,
                           type: ContentType(rawValue: self.type) ?? .text,
                           text: self.text ?? "",
                           photoFileName: self.fileName,
                           creationDate: self.creationDate,
                           displayTimestamp: self.displayTimestamp,
                           lastUpdateDate: self.lastUpdateDate,
                           lastSaveDate: self.lastSaveDate )
    }
}
