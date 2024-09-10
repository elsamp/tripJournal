//
//  ContentViewModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import Foundation

protocol ContentChangeDelegateProtocol {
    
}

protocol ContentViewModelProtocol: PhotoDataUpdateDelegatProtocol  {
    var content: ContentItem { get }
    
    func save(content: ContentItem)
    func delete(content: ContentItem)
}


class ContentViewModel: ContentViewModelProtocol, PhotoDataUpdateDelegatProtocol {

    var content: ContentItem
    var contentChangeDelegate: ContentChangeDelegateProtocol
    var saveContentUseCase: SaveContentUseCaseProtocol
    
    init(content: ContentItem, contentChangeDelegate: ContentChangeDelegateProtocol, saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase()) {
        self.content = content
        self.contentChangeDelegate = contentChangeDelegate
        self.saveContentUseCase = saveContentUseCase
    }

    
    func save(content: ContentItem) {
        saveContentUseCase.save(content: content, for: content.day)
    }
    
    func delete(content: ContentItem) {
        //TODO: Implement
        print("Delete not yet implemented!")
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        content.photoData = data
        saveContentUseCase.saveImageDataFor(content: content, data: data)
        save(content: content)
    }
    
}
