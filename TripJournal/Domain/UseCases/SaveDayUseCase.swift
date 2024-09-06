//
//  SaveDayUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation

protocol SaveDayUseCaseProtocol {
    func save(day: Day, for trip: Trip)
}

struct SaveDayUseCase: SaveDayUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(day: Day, for trip: Trip) {
        day.lastSaveDate = Date.now
        dataService.save(day: day, for: trip)
    }
}
