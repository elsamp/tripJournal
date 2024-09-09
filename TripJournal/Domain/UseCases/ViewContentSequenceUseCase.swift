//
//  ViewContentSequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation

protocol ViewContentSequenceUseCaseProtocol {
    
    func fetchContentSquence(for day: Day) -> ContentSequence
    
}

struct ViewContentSequenceUseCase: ViewContentSequenceUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchContentSquence(for day: Day) -> ContentSequence {
        return ContentSequence(id: UUID().uuidString, contentItems: Array(dataService.fetchContentFor(day: day)))
    }
}

/*
 struct ViewContentSequenceExampleUseCase: ViewContentSequenceUseCaseProtocol {
 
 func fetchContentSquence(for dayId: String) -> ContentSequence {
 
 let sequence = [
 Content(id: UUID().uuidString,
 type: .text,
 description: "This is a longer bit of text so that I can see a few lines in the layout.",
 creationDate: Date.now,
 lastUpdateDate: Date.now),
 Content(id: UUID().uuidString,
 type: .text,
 description: "Another longer bit of text. Let's see if I can make this one longer thatn what I had for the last.",
 creationDate: Date.now,
 lastUpdateDate: Date.now)
 ]
 
 return ContentSequence(id: UUID().uuidString, sequence: sequence)
 }
 }
 */
