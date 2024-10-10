//
//  CreateTripUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation

protocol SaveTripUseCaseProtocol {
    func save(trip: TripViewModel)
    func saveCoverImage(data: Data, for trip: TripViewModel)
}

struct SaveTripUseCase: SaveTripUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(trip: TripViewModel) {
        trip.lastSaveDate = Date.now
        dataService.save(trip: Trip.fromViewModel(trip))
    }
    
    func saveCoverImage(data: Data, for trip: TripViewModel) {
        ImageHelperService.shared.saveImageData(data, tripId: trip.id)
    }
}
