//
//  ContentObjectModel+content.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import Foundation

extension ContentObjectModel {
    
    func content(for day: Day) -> ContentItem {
        return ContentItem(id: self.id, 
                       day: day,
                       sequenceIndex: self.sequenceIndex,
                       type: ContentType(rawValue: self.type) ?? .text,
                       photoFileName: self.fileName,
                       text: self.text ?? "",
                       creationDate: self.creationDate,
                       lastUpdateDate: self.lastUpdateDate,
                       lastSaveDate: self.lastSaveDate )
    }
}
