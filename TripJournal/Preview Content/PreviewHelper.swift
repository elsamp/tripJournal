//
//  PreviewHelper.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

struct PreviewHelper: PhotoDataUpdateDelegatProtocol, ViewDaySequenceUseCaseProtocol {
    
    

    static let shared = PreviewHelper()
    
    private init() {}
    
    //PhotoDataUpdateDelegatProtocol
    func imageDataUpdatedTo(_ data: Data) {
        //do nothing
    }
    
    func mockTrip() -> Trip {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let startDate1 = userCalendar.date(from: dateComponents)
        
        return Trip(id: UUID().uuidString,
                    title: "Cape Bretton",
                    description: "One last trip to visit my grandparents before they passed",
                    startDate: startDate1 ?? Date.now,
                    endDate: startDate1 != nil ? Date.dateFor(days: 10, since: startDate1!) : Date.now,
                    coverPhotoPath: nil,
                    creationDate: startDate1 ?? Date.now,
                    lastUpdateDate: Date.now,
                    lastSaveDate: Date.now)
    }
    
    func mockDay() -> Day {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let date = userCalendar.date(from: dateComponents)
        
        return Day(id: UUID().uuidString,
                   trip: mockTrip(),
                   date: date ?? Date.now,
                   title: "Day at the Beach!",
                   coverPhotoPath: nil,
                   creationDate: Date.now,
                   lastUpdateDate: Date.now)
    }
    
    func fetchDaysFor(trip: Trip) -> DaySequence {
        return DaySequence(id: UUID().uuidString, days: [mockDay(), mockDay(), mockDay()])
    }
    
}
