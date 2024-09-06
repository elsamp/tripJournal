//
//  DayObjectModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation
import RealmSwift

class DayObjectModel: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var title: String
    @Persisted var coverPhotoPath: String?
    @Persisted var contentSequence: ContentSequenceObjectModel?
    @Persisted var creationDate: Date
    @Persisted var lastUpdateDate: Date
    @Persisted var lastSaveDate: Date
    
}
