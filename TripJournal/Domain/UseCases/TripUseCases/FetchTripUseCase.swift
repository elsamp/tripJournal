//
//  CancelTripEditUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

protocol FetchTripUseCaseProtocol {
    func fetchTrip(for id: String) -> Trip?
}

struct FetchTripUseCase: FetchTripUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchTrip(for id: String) -> Trip? {
        return dataService.fetchTrip(for: id)
    }
}
