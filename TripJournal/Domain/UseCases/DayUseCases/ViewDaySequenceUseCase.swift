//
//  ViewDaySequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol ViewDaySequenceUseCaseProtocol {
    
    func fetchDaysFor(tripId: String) -> Set<DayViewModel>
}

struct ViewDaySequenceUseCase: ViewDaySequenceUseCaseProtocol {
    
    typealias TripModel = TripViewModel
    typealias DaySequenceModel = DaySequenceViewModel
        
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchDaysFor(tripId: String) -> Set<DayViewModel> {
        
        let days = dataService.fetchDaysFor(tripId: tripId)
        var viewModels = Set<DayViewModel>()
        var trip: TripViewModel?
        
        for item in days {
            viewModels.insert(item.toViewModel())
            
            if trip == nil {
                trip = item.trip.toViewModel()
            }
        }
        
        return viewModels
    }
}
