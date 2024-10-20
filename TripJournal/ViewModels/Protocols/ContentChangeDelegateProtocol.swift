//
//  ContentChangeDelegateProtocol.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-12.
//

import Foundation

protocol ContentChangeDelegateProtocol {
    func delete(content: ContentViewModel)
}

protocol SequencedItemChangeDelegateProtocol<SequencedItem>: AnyObject {
    
    associatedtype SequencedItem
        
    func delete(_ item: SequencedItem)
    func add(item: SequencedItem, at index: Int?)
}
