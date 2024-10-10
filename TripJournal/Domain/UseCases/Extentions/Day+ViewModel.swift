//
//  Day+ViewModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-10.
//

import Foundation

// Provides domain entity mapping to and from ViewModel representation
extension Day {
    
    func toViewModel() -> DayViewModel{
        DayViewModel(id: self.id,
                     trip: self.trip.toViewModel(),
                     date: self.date,
                     title: self.title,
                     coverPhotoPath: self.coverPhotoPath,
                     coverImageData: self.coverImageData,
                     creationDate: self.creationDate,
                     lastUpdateDate: self.lastUpdateDate,
                     lastSaveDate: self.lastUpdateDate)
    }
    
    static func fromViewModel(_ viewModel: DayViewModel) -> Day {
        Day(id: viewModel.id,
            trip: Trip.fromViewModel(viewModel.trip),
            date: viewModel.date,
            title: viewModel.title,
            creationDate: viewModel.creationDate,
            lastUpdateDate: viewModel.lastUpdateDate)
    }
}
