//
//  DayViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation


protocol DayViewModelProtocol {
    var day: Day { get }
    var contentSequence: ContentSequence { get }
    
    func save(day: Day)
    func delete(day: Day)
}

class DayViewModel: DayViewModelProtocol {
    
    private let contentSequenceProvider: ViewContentSequenceUseCaseProtocol
    private var saveDayUseCase: SaveDayUseCaseProtocol
    private var deleteDayUseCase: DeleteDayUseCaseProtocol
    
    @Published var day: Day
    
    let contentSequence: ContentSequence
    
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
        saveDayUseCase.save(day: day, for: day.trip)
    }
    
    func delete(day: Day) {
        deleteDayUseCase.delete(day: day)
    }
}
