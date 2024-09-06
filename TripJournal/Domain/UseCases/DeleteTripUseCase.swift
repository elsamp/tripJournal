//
//  DeleteTripUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation


protocol DeleteTripUseCaseProtocol {
    func delete(trip: Trip)
}

struct DeleteTripUseCase: DeleteTripUseCaseProtocol {
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func delete(trip: Trip) {
        dataService.delete(trip: trip)
    }
}
