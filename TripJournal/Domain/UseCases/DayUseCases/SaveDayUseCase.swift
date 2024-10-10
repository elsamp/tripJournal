//
//  SaveDayUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation

protocol SaveDayUseCaseProtocol {
    func save(day: DayViewModel, for trip: TripViewModel)
    func saveCoverImage(data: Data, for day: DayViewModel)
}

struct SaveDayUseCase: SaveDayUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(day: DayViewModel, for trip: TripViewModel) {
        
        if day.lastSaveDate != nil {
            day.lastSaveDate = Date.now
            dataService.updateDay(Day.fromViewModel(day))
        } else {
            day.lastSaveDate = Date.now
            dataService.createDay(Day.fromViewModel(day), for: Trip.fromViewModel(trip))
        }
    }
    
    func saveCoverImage(data: Data, for day: DayViewModel) {
        
        let imageHelper = ImageHelperService.shared
        imageHelper.saveImageData(data, tripId: day.trip.id, dayId: day.id)

    }
}
