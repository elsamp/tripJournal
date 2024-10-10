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
    
    func mockTrip() -> TripViewModel {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let startDate1 = userCalendar.date(from: dateComponents)
        
        return TripViewModel(id: UUID().uuidString,
                             title: "Cape Bretton",
                             description: "One last trip to visit my grandparents before they passed",
                             startDate: startDate1 ?? Date.now,
                             endDate: startDate1 != nil ? Date.dateFor(days: 10, since: startDate1!) : Date.now,
                             coverPhotoPath: nil,
                             coverImageData: nil,
                             creationDate: startDate1 ?? Date.now,
                             lastUpdateDate: Date.now,
                             lastSaveDate: Date.now)
    }
    
    func mockDay() -> DayViewModel {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 8
        dateComponents.day = 20
        
        let userCalendar = Calendar(identifier: .gregorian)
        let date = userCalendar.date(from: dateComponents)
        
        return DayViewModel(id: UUID().uuidString,
                            trip: mockTrip(),
                            date: date ?? Date.now,
                            title: "Day at the Beach!",
                            coverPhotoPath: nil,
                            coverImageData: nil,
                            creationDate: Date.now,
                            lastUpdateDate: Date.now,
                            lastSaveDate: Date.now)
    }
    
    func mockTextContent() -> ContentViewModel {
        
        let text =
            """
            This is a longer bit of text to help me see what it looks like in the preview.
            
            It would be nice if I also had a way to do this for pictures, but alas,
            I havn't figured out how to do that yet. Perhaps soon...
            """
        
        return ContentViewModel(id: UUID().uuidString,
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
    
    func mockTextContentWith(text: String) -> ContentViewModel {
        
        return ContentViewModel(id: UUID().uuidString,
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
    
    func mockPhotoContent() -> ContentViewModel {
        
        return ContentViewModel(id: UUID().uuidString,
                day: mockDay(),
                sequenceIndex: 1,
                type: .photo,
                photoFileName: "",
                text: "",
                creationDate: Date.now,
                displayTimestamp: Date.now,
                lastUpdateDate: Date.now,
                lastSaveDate: Date.now)
    }
    
    func fetchDaysFor(trip: TripViewModel) -> DaySequenceViewModel {
        return DaySequenceViewModel(trip: trip, days: [mockDay(), mockDay(), mockDay()])
    }
    
    func delete(content: ContentViewModel) {
        //do nothing
    }
}
