//
//  ContentItem+ViewModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-10.
//

import Foundation

// Provides domain entity mapping to and from ViewModel representation
extension ContentItem {
    
    func toViewModel() -> ContentViewModel {
        ContentViewModel(id: self.id,
                         day: self.day.toViewModel(),
                         sequenceIndex: self.sequenceIndex,
                         type: self.type,
                         photoFileName: self.photoFileName,
                         text: self.text,
                         creationDate: self.creationDate,
                         displayTimestamp: self.displayTimestamp,
                         lastUpdateDate: self.lastUpdateDate,
                         lastSaveDate: self.lastSaveDate)
    }
    
    static func fromViewModel(_ viewModel: ContentViewModel) -> ContentItem {
        ContentItem(id: viewModel.id,
                    day: Day.fromViewModel(viewModel.day),
                    sequenceIndex: viewModel.sequenceIndex,
                    type: viewModel.type,
                    text: viewModel.text,
                    creationDate: viewModel.creationDate,
                    displayTimestamp: viewModel.displayTimestamp,
                    lastUpdateDate: viewModel.lastUpdateDate)
    }
}
