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

/*
struct ViewDaySequenceExampleUseCase: ViewDaySequenceUseCaseProtocol {
    
    
    func fetchDaysFor(tripId: String) -> DaySequence {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let day1Date = userCalendar.date(from: dateComponents)
        
        let days: Set<Day> = [
            Day(id: UUID().uuidString,
                date: day1Date!,
                title: "Setting Off",
                coverPhotoPath: nil,
                creationDate: day1Date!,
                lastUpdateDate: day1Date!),
            Day(id: UUID().uuidString,
                date: Date.dateFor(days: 1, since: day1Date!),
                title: "Bright and Early Adventures",
                coverPhotoPath: nil,
                creationDate: day1Date!,
                lastUpdateDate: day1Date!),
            Day(id: UUID().uuidString,
                date: Date.dateFor(days: 2, since: day1Date!),
                title: "On the Road",
                coverPhotoPath: nil,
                creationDate: day1Date!,
                lastUpdateDate: day1Date!),
            Day(id: UUID().uuidString, 
                date: Date.dateFor(days: 3, since: day1Date!),
                title: "Day at the Beach",
                coverPhotoPath: nil,
                creationDate: day1Date!,
                lastUpdateDate: day1Date!),
        ]
        
        return DaySequence(id: UUID().uuidString, days: days)
    }
}*/
