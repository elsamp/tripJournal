//
//  SaveContentUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import Foundation

protocol SaveContentUseCaseProtocol {
    func save(content: ContentItem, for day: Day)
    func saveImageDataFor(content: ContentItem, data: Data)
}

struct SaveContentUseCase: SaveContentUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func save(content: ContentItem, for day: Day) {
        content.lastSaveDate = Date.now
        dataService.save(content: content, for: day)
    }
    
    func saveImageDataFor(content: ContentItem, data: Data) {
        
        print("UseCase saving photo")
        let imageHelper = ImageHelperService.shared

        print(imageHelper.imageURL(for: content))
        content.photoFileName = imageHelper.fileName(for: content)
        imageHelper.saveImage(data: data, for: content)
        
    }
}
