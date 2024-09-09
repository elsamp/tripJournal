//
//  Preview-ViewTripTimelineUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-08.
//

import Foundation

struct PreviewViewTripTimelineUseCase: ViewTripTimelineUseCaseProtocol {
    
    func fetchTripSequence() -> TripSequence {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let startDate1 = userCalendar.date(from: dateComponents)
        
        let trip1 = Trip(id: UUID().uuidString,
                        title: "Cape Bretton",
                        description: "One last trip to visit my grandparents before they passed",
                        startDate: startDate1 ?? Date.now,
                        endDate: startDate1 != nil ? Date.dateFor(days: 10, since: startDate1!) : Date.now,
                        coverPhotoPath: nil,
                        creationDate: startDate1 ?? Date.now,
                        lastUpdateDate: Date.now,
                        lastSaveDate: nil)
        
        dateComponents.year = 2020
        dateComponents.month = 7
        dateComponents.day = 18
        
        let startDate2 = userCalendar.date(from: dateComponents)
        
        let trip2 = Trip(id: UUID().uuidString,
                        title: "PEC Getaway",
                        startDate: startDate2 ?? Date.now,
                        endDate: startDate2 != nil ? Date.dateFor(days: 5, since: startDate2!) : Date.now,
                        coverPhotoPath: nil,
                        creationDate: startDate2 ?? Date.now,
                        lastUpdateDate: Date.now,
                        lastSaveDate: nil)
        
        
        dateComponents.year = 2019
        dateComponents.month = 9
        dateComponents.day = 7
        
        let startDate3 = userCalendar.date(from: dateComponents)
        
        let trip3 = Trip(id: UUID().uuidString,
                        title: "Weekend in Kignston",
                        description: "A last minute getaway with my Bean! What a wonderful weekend and getaway from the everyday stress.",
                        startDate: startDate3 ?? Date.now,
                        endDate: startDate3 != nil ? Date.dateFor(days: 3, since: startDate3!) : Date.now,
                        coverPhotoPath: nil,
                        creationDate: startDate3 ?? Date.now,
                        lastUpdateDate: Date.now,
                        lastSaveDate: nil)
        
        return TripSequence(id: UUID().uuidString, trips: [trip1, trip2, trip3])
        
    }

}
