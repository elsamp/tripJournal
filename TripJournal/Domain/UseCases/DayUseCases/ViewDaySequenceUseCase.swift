//
//  ViewDaySequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol ViewDaySequenceUseCaseProtocol {
    
    func fetchDaysFor(trip: TripViewModel) -> DaySequenceViewModel
}

struct ViewDaySequenceUseCase: ViewDaySequenceUseCaseProtocol {
    
    typealias TripModel = TripViewModel
    typealias DaySequenceModel = DaySequenceViewModel
        
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchDaysFor(trip: TripViewModel) -> DaySequenceViewModel {
        
        let days = dataService.fetchDaysFor(trip: Trip.fromViewModel(trip))
        var viewModels = Set<DayViewModel>()
        
        for item in days {
            viewModels.insert(item.toViewModel())
        }
        
        return DaySequenceViewModel(trip: trip, days: viewModels)
    }
}
