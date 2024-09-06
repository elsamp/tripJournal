//
//  TripObjectModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation
import RealmSwift

class TripObjectModel: Object, ObjectKeyIdentifiable {

    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var summaryText: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var coverPhotoPath: String?
    @Persisted var days: List<DayObjectModel>
    @Persisted var creationDate: Date
    @Persisted var lastUpdateDate: Date
    @Persisted var lastSaveDate: Date

}
