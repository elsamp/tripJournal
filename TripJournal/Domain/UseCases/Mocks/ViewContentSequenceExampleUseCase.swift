//
//  ViewContentSequenceExampleUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-02.
//

import Foundation

struct ViewContentSequenceExampleUseCase: ViewContentSequenceUseCaseProtocol {
 
     func fetchContentSquence(for day: Day) -> ContentSequence {
         
         let sequence = [
         ContentItem(id: "1",
                     day: day,
                     sequenceIndex: 1,
                     type: .text,
                     photoFileName: nil,
                     text: "I had a really great time today at the beach with Bean. We walked along the whole length and picked up shells and other small pebbles",
                     creationDate: Date.now,
                     displayTimestamp: Date.now,
                     lastUpdateDate: Date.now,
                     lastSaveDate: Date.now),
         ContentItem(id: "2",
                     day: day,
                     sequenceIndex: 1,
                     type: .photo,
                     photoFileName: nil,
                     text: "",
                     creationDate: Date.now,
                     displayTimestamp: Date.now,
                     lastUpdateDate: Date.now,
                     lastSaveDate: Date.now)
         ]
         
         return ContentSequence(id: UUID().uuidString, contentItems: sequence)
     }
 }
