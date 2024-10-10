//
//  ViewContentSequenceUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation

protocol ViewContentSequenceUseCaseProtocol {
    
    func fetchContentSquence(for day: DayViewModel) -> ContentSequenceViewModel
    
}

struct ViewContentSequenceUseCase: ViewContentSequenceUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func fetchContentSquence(for day: DayViewModel) -> ContentSequenceViewModel {
        
        let contentItems = dataService.fetchContentFor(day: Day.fromViewModel(day))
        var viewModels: [ContentViewModel] = []
        
        for item in contentItems {
            viewModels.append(item.toViewModel())
        }
                                 
        return ContentSequenceViewModel(day: day, contentItems: viewModels)
    }
}
 
