//
//  PreviewHelper.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

struct PreviewHelper: PhotoDataUpdateDelegatProtocol, ViewDaySequenceUseCaseProtocol, ContentChangeDelegateProtocol {

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
    
    func mockTextContent() -> ContentItem {
        
        let text =
            """
            This is a longer bit of text to help me see what it looks like in the preview.
            
            It would be nice if I also had a way to do this for pictures, but alas,
            I havn't figured out how to do that yet. Perhaps soon...
            """
        
        return ContentItem(id: UUID().uuidString,
                day: mockDay(),
                sequenceIndex: 1,
                type: .text,
                photoFileName: nil,
                text: text,
                creationDate: Date.now,
                displayTimestamp: Date.now,
                lastUpdateDate: Date.now,
                lastSaveDate: Date.now)
    }
    
    func mockTextContentWith(text: String) -> ContentItem {
        
        return ContentItem(id: UUID().uuidString,
                day: mockDay(),
                sequenceIndex: 1,
                type: .text,
                photoFileName: nil,
                text: text,
                creationDate: Date.now,
                displayTimestamp: Date.now,
                lastUpdateDate: Date.now,
                lastSaveDate: Date.now)
    }
    
    func fetchDaysFor(trip: Trip) -> DaySequence {
        return DaySequence(id: UUID().uuidString, days: [mockDay(), mockDay(), mockDay()])
    }
    
    func delete(content: ContentItem) {
        //do nothing
    }
}
