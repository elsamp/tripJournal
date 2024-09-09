//
//  DayViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation


protocol DayViewModelProtocol: PhotoDataUpdateDelegatProtocol {
    var day: Day { get }
    var contentSequence: ContentSequence { get }
    var contentArray: [Content] { get }
    
    func save(day: Day)
    func delete(day: Day)
    func addNewTextContent(type: ContentType, for day: Day)
    func addNewPhotoContent(with data: Data, for day: Day)
}

class DayViewModel: DayViewModelProtocol, PhotoDataUpdateDelegatProtocol {

    private let contentSequenceProvider: ViewContentSequenceUseCaseProtocol
    private var saveDayUseCase: SaveDayUseCaseProtocol
    private var saveContentUseCase: SaveContentUseCaseProtocol
    private var deleteDayUseCase: DeleteDayUseCaseProtocol
    
    public private(set) var day: Day
    public private(set) var contentSequence: ContentSequence
    var contentArray: [Content] {
        contentSequence.contentItems.sorted()
    }
    
    private var didUpdateCoverPhoto = false
    
    init(contentSequenceProvider: ViewContentSequenceUseCaseProtocol = ViewContentSequenceUseCase(), 
         day: Day,
         saveDayUseCase: SaveDayUseCaseProtocol = SaveDayUseCase(),
         saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase(),
         deleteDayUseCase: DeleteDayUseCaseProtocol = DeleteDayUseCase()) {
        self.contentSequenceProvider = contentSequenceProvider
        self.day = day
        self.contentSequence = contentSequenceProvider.fetchContentSquence(for: day)
        self.saveDayUseCase = saveDayUseCase
        self.saveContentUseCase = saveContentUseCase
        self.deleteDayUseCase = deleteDayUseCase
    }
    
    func save(day: Day) {
        
        if didUpdateCoverPhoto {
            if let data = day.coverImageData {
                saveDayUseCase.saveCoverImage(data: data, for: day)
                didUpdateCoverPhoto = false
            }
        }
        
        //Rethink this to improve IOC
        for contentItem in contentSequence.contentItems {
            if contentItem.hasUnsavedChanges {
                saveContentUseCase.save(content: contentItem, for: day)
            }
        }
        
        saveDayUseCase.save(day: day, for: day.trip)
    }
    
    func updateCoverImage(data: Data) {
        day.coverImageData = data
        didUpdateCoverPhoto = true
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        updateCoverImage(data: data)
    }
    
    func delete(day: Day) {
        deleteDayUseCase.delete(day: day)
    }
    
    func addNewPhotoContent(with data: Data, for day: Day) {
        
        print("saving new photo content. SequenceCount \(contentSequence.contentItems.count)")
        let newContent = Content(id: UUID().uuidString,
                                 day: day,
                                 sequenceIndex: contentSequence.contentItems.count, //Place at the end
                                 type: .photo,
                                 photoFileName: nil,
                                 text: nil,
                                 creationDate: Date.now,
                                 lastUpdateDate: Date.now,
                                 lastSaveDate: nil)
        
        saveContentUseCase.saveImageDataFor(content: newContent, data: data)
        
        contentSequence.add(content: newContent)
        saveContentUseCase.save(content: newContent, for: day)
        
        print("saved new photo content. SequenceCount \(contentSequence.contentItems.count)")
    }
    
    func addNewTextContent(type: ContentType, for day: Day) {
        print("saving new text content. SequenceCount \(contentSequence.contentItems.count)")
        
        let newContent = Content(id: UUID().uuidString,
                                 day: day,
                                 sequenceIndex: contentSequence.contentItems.count, //Place at the end
                                 type: .text,
                                 photoFileName: nil,
                                 text: "Testing",
                                 creationDate: Date.now,
                                 lastUpdateDate: Date.now,
                                 lastSaveDate: nil)
        
        contentSequence.add(content: newContent)
        saveContentUseCase.save(content: newContent, for: day)
        
        print("saved new text content. SequenceCount \(contentSequence.contentItems.count)")
    }
}
