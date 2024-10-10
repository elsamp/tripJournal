//
//  DeleteContentUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-11.
//

import Foundation

protocol DeleteContentUseCaseProtocol {
    
    func delete(content: ContentViewModel)
}

struct DeleteContentUseCase: DeleteContentUseCaseProtocol {
        
    typealias ContentModel = ContentViewModel
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func delete(content: ContentViewModel) {
        dataService.deleteContent(withId: content.id)
        //TODO: If content type is photo, delete image data
    }
    
    private func deleteImageDataFor(content: ContentItem) {
        
        //TODO: Implement
        
    }
}
