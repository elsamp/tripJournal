//
//  SaveDayUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation

protocol SaveDayUseCaseProtocol {
    func save(day: Day, for trip: Trip)
    func saveCoverImage(data: Data, for day: Day)
}

struct SaveDayUseCase: SaveDayUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(day: Day, for trip: Trip) {
        day.lastSaveDate = Date.now
        dataService.save(day: day, for: trip)
    }
    
    func saveCoverImage(data: Data, for day: Day) {
        
        print("UseCase saving photo")
        let imageHelper = ImageHelperService.shared

        print(imageHelper.imageURL(for: day))
        day.coverPhotoPath = imageHelper.imageURL(for: day).relativePath
        imageHelper.saveImage(data: data, for: day)
        
    }
}
