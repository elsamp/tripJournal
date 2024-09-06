//
//  ViewTripSequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol ViewTripTimelineUseCaseProtocol {
    func fetchTripSequence() -> TripSequence
}

struct ViewTripTimelineUseCase: ViewTripTimelineUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchTripSequence() -> TripSequence {
        TripSequence(id: UUID().uuidString, trips: dataService.fetchTrips())
    }

}

