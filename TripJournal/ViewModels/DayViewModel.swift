//
//  DayViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation


protocol DayViewModelProtocol: PhotoDataUpdateDelegatProtocol {
    var day: Day { get }
    var contentSequence: ContentSequence { get }
    
    func save(day: Day)
    func delete(day: Day)
}

class DayViewModel: DayViewModelProtocol, PhotoDataUpdateDelegatProtocol {

    private let contentSequenceProvider: ViewContentSequenceUseCaseProtocol
    private var saveDayUseCase: SaveDayUseCaseProtocol
    private var deleteDayUseCase: DeleteDayUseCaseProtocol
    
    var day: Day
    let contentSequence: ContentSequence
    
    private var didUpdateCoverPhoto = false
    
    init(contentSequenceProvider: ViewContentSequenceUseCaseProtocol = ViewContentSequenceExampleUseCase(), 
         day: Day,
         saveDayUseCase: SaveDayUseCaseProtocol = SaveDayUseCase(),
         deleteDayUseCase: DeleteDayUseCaseProtocol = DeleteDayUseCase()) {
        self.contentSequenceProvider = contentSequenceProvider
        self.day = day
        self.contentSequence = contentSequenceProvider.fetchContentSquence(for: "")
        self.saveDayUseCase = saveDayUseCase
        self.deleteDayUseCase = deleteDayUseCase
    }
    
    func save(day: Day) {
        
        if didUpdateCoverPhoto {
            if let data = day.coverImageData {
                saveDayUseCase.saveCoverImage(data: data, for: day)
                didUpdateCoverPhoto = false
            }
        }
        
        saveDayUseCase.save(day: day, for: day.trip)
    }
    
    func updateCoverImage(data: Data) {
        day.coverImageData = data
        didUpdateCoverPhoto = true
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        updateCoverImage(data: data)
    }
    
    func delete(day: Day) {
        deleteDayUseCase.delete(day: day)
    }
}
