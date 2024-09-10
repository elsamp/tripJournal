//
//  ContentSequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

class ContentSequence: ObservableObject, Identifiable {
    let id: String
    @Published var contentItems: [ContentItem]
    @Published var selectedItem: ContentItem? = nil

    init(id: String, contentItems: [ContentItem]) {
        self.id = id
        self.contentItems = contentItems.sorted()
    }
    
    func add(content: ContentItem) {
        contentItems.append(content)
    }
    
    func add(content: ContentItem, at index: Int) {
        contentItems.insert(content, at: index)
        resetContentIdices()
    }
    
    func remove(content: ContentItem) {
        contentItems.remove(at: content.sequenceIndex)
        resetContentIdices()
    }
    
    func resetContentIdices() {
        for i in 0..<contentItems.count {
            contentItems[i].sequenceIndex = i
        }
    }
    
    func select(content: ContentItem) {
        selectedItem = content
        print("Selected \(content.id)")
    }
    
    func deselectAll() {
        selectedItem = nil
    }

}
