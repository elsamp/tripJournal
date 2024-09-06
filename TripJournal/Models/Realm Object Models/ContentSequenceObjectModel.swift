//
//  ContentSequenceObjectModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation
import RealmSwift


class ContentSequenceObjectModel: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var dayId: ObjectId
    @Persisted var contentSequence: List<ContentObjectModel>
    
}
