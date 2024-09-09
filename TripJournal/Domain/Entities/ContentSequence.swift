//
//  ContentSequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

class ContentSequence: ObservableObject, Identifiable {
    let id: String
    @Published var contentItems: [Content]

    init(id: String, contentItems: [Content]) {
        self.id = id
        self.contentItems = contentItems.sorted()
    }
    
    func add(content: Content) {
        contentItems.append(content)
    }
    
    func add(content: Content, at index: Int) {
        contentItems.insert(content, at: index)
        resetContentIdices()
    }
    
    func remove(content: Content) {
        contentItems.remove(at: content.sequenceIndex)
        resetContentIdices()
    }
    
    func resetContentIdices() {
        for i in 0..<contentItems.count {
            contentItems[i].sequenceIndex = i
        }
    }

}
