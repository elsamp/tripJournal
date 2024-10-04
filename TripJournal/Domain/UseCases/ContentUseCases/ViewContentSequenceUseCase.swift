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
 
