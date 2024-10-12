//
//  SaveContentUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import Foundation

protocol SaveContentUseCaseProtocol {
    func save(content: ContentViewModel)
    //func saveImageDataFor(content: ContentItem, data: Data)
    func saveImageData(_ data: Data, tripId: String, dayId: String, contentId: String)
}

struct SaveContentUseCase: SaveContentUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(content: ContentViewModel) {
        
        if content.lastSaveDate != nil {
            content.lastSaveDate = Date.now
            dataService.updateContent(id: content.id,
                                      sequenceIndex: content.sequenceIndex,
                                      type: content.type,
                                      text: content.text,
                                      photoFileName: content.photoFileName,
                                      photoData: content.photoData,
                                      creationDate: content.creationDate,
                                      displayTimestamp: content.displayTimestamp,
                                      lastUpdateDate: content.lastUpdateDate,
                                      lastSaveDate: content.lastSaveDate)
        } else {
            content.lastSaveDate = Date.now
            dataService.createContent(id: content.id,
                                      dayId: content.day.id,
                                      sequenceIndex: content.sequenceIndex,
                                      type: content.type,
                                      text: content.text,
                                      photoFileName: content.photoFileName,
                                      photoData: content.photoData,
                                      creationDate: content.creationDate,
                                      displayTimestamp: content.displayTimestamp,
                                      lastUpdateDate: content.lastUpdateDate,
                                      lastSaveDate: content.lastSaveDate)
        }
        
        if content.type == .photo {
            if let photoData = content.photoData {
                saveImageData(photoData, tripId: content.day.trip.id, dayId: content.day.id, contentId: content.id)
            }
        }
    }
    
    func saveImageData(_ data: Data, tripId: String, dayId: String, contentId: String) {
        ImageHelperService.shared.saveImageData(data, tripId: tripId, dayId: dayId, contentId: contentId)
    }
}
