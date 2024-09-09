//
//  ContentObjectModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation
import RealmSwift


class ContentObjectModel: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var sequenceIndex: Int
    @Persisted var type: String
    @Persisted var fileName: String?
    @Persisted var text: String?
    @Persisted var creationDate: Date
    @Persisted var lastUpdateDate: Date
    @Persisted var lastSaveDate: Date
}
