//
//  DeleteContentUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-11.
//

import Foundation

protocol DeleteContentUseCaseProtocol {
    func delete(content: ContentItem)
}

struct DeleteContentUseCase: DeleteContentUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func delete(content: ContentItem) {
        dataService.deleteContent(content: content)
    }
    
    private func deleteImageDataFor(content: ContentItem) {
        
        //TODO: Implement
        
    }
}
