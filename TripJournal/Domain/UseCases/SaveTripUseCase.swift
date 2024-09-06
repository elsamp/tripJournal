//
//  CreateTripUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation

protocol SaveTripUseCaseProtocol {
    func save(trip: Trip)
    func saveCoverImage(data: Data, for trip: Trip)
}

struct SaveTripUseCase: SaveTripUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(trip: Trip) {
        trip.lastSaveDate = Date.now
        dataService.save(trip: trip)
    }
    
    func saveCoverImage(data: Data, for trip: Trip) {
        
        print("UseCase saving photo")
        let imageHelper = ImageHelperService.shared

        print(imageHelper.imageURL(for: trip))
        trip.coverPhotoPath = imageHelper.imageURL(for: trip).relativePath
        imageHelper.saveImage(data: data, for: trip)
        
    }
}
