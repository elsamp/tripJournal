//
//  ViewDaySequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol ViewDaySequenceUseCaseProtocol {
    func fetchDaysFor(trip: Trip) -> DaySequence
}

struct ViewDaySequenceUseCase: ViewDaySequenceUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchDaysFor(trip: Trip) -> DaySequence {
        DaySequence(id: UUID().uuidString, days: dataService.fetchDaysFor(trip: trip))
    }
}
