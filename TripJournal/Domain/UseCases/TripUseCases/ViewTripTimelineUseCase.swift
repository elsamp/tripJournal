//
//  ViewTripSequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol ViewTripTimelineUseCaseProtocol {
    func fetchTrips() -> Set<TripViewModel>
}

struct ViewTripTimelineUseCase: ViewTripTimelineUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchTrips() -> Set<TripViewModel> {
        let trips = dataService.fetchTrips()
        var viewModels = Set<TripViewModel>()
        
        for item in trips {
            viewModels.insert(item.toViewModel())
        }
        
        return viewModels
    }

}

