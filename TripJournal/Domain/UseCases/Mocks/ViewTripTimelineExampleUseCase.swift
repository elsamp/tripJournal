//
//  ViewTripSequenceExampleUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-01.
//

import Foundation

struct ViewTripTimelineExampleUseCase: ViewTripTimelineUseCaseProtocol {
    
    func fetchTrips() -> Set<TripViewModel> {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let startDate1 = userCalendar.date(from: dateComponents)
        
        let trip1 = TripViewModel(id: UUID().uuidString,
                                  title: "Cape Bretton",
                                  description: "One last trip to visit my grandparents before they passed",
                                  startDate: startDate1 ?? Date.now,
                                  endDate: startDate1 != nil ? Date.dateFor(days: 10, since: startDate1!) : Date.now,
                                  coverPhotoPath: nil,
                                  coverImageData: nil,
                                  creationDate: startDate1 ?? Date.now,
                                  lastUpdateDate: Date.now,
                                  lastSaveDate: nil)
        
        dateComponents.year = 2020
        dateComponents.month = 7
        dateComponents.day = 18
        
        let startDate2 = userCalendar.date(from: dateComponents)
        
        let trip2 = TripViewModel(id: UUID().uuidString,
                                  title: "PEC Getaway",
                                  description: "",
                                  startDate: startDate2 ?? Date.now,
                                  endDate: startDate2 != nil ? Date.dateFor(days: 5, since: startDate2!) : Date.now,
                                  coverPhotoPath: nil,
                                  coverImageData: nil,
                                  creationDate: startDate2 ?? Date.now,
                                  lastUpdateDate: Date.now,
                                  lastSaveDate: nil)
        
        
        dateComponents.year = 2019
        dateComponents.month = 9
        dateComponents.day = 7
        
        let startDate3 = userCalendar.date(from: dateComponents)
        
        let trip3 = TripViewModel(id: UUID().uuidString,
                                  title: "Weekend in Kignston",
                                  description: "A last minute getaway with my Bean! What a wonderful weekend and getaway from the everyday stress.",
                                  startDate: startDate3 ?? Date.now,
                                  endDate: startDate3 != nil ? Date.dateFor(days: 3, since: startDate3!) : Date.now,
                                  coverPhotoPath: nil,
                                  coverImageData: nil,
                                  creationDate: startDate3 ?? Date.now,
                                  lastUpdateDate: Date.now,
                                  lastSaveDate: nil)
        
        return [trip1, trip2, trip3]
    }
}
