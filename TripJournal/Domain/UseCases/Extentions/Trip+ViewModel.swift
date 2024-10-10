//
//  Trip+ViewModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-10.
//

import Foundation

// Provides domain entity mapping to and from ViewModel representation
extension Trip {
    func toViewModel() -> TripViewModel {
        TripViewModel(id: self.id,
                      title: self.title,
                      description: self.description,
                      startDate: self.startDate,
                      endDate: self.endDate,
                      coverPhotoPath: self.coverPhotoPath,
                      coverImageData: self.coverImageData,
                      creationDate: self.creationDate,
                      lastUpdateDate: self.lastUpdateDate,
                      lastSaveDate: self.lastSaveDate)
    }
    
    static func fromViewModel(_ viewModel: TripViewModel) -> Trip {
        Trip(id: viewModel.id,
             title: viewModel.title,
             description: viewModel.description,
             startDate: viewModel.startDate,
             endDate: viewModel.endDate,
             creationDate: viewModel.creationDate,
             lastUpdateDate: viewModel.lastUpdateDate)
    }
}
