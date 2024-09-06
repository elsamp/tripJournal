//
//  PhotoDataProvider.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

typealias PhotoDataHandler = PhotoDataProviderProtocol & PhotoDataUpdateDelegatProtocol

protocol PhotoDataProviderProtocol {
    
    var imageData: Data? { get }
    
}

protocol PhotoDataUpdateDelegatProtocol {
    
    func imageDataUpdatedTo(_ data: Data)
    
}
