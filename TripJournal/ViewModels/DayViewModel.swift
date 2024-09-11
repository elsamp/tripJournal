//
//  DayViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation


protocol DayViewModelProtocol: PhotoDataUpdateDelegatProtocol, ContentChangeDelegateProtocol {
    var day: Day { get }
    var contentSequence: ContentSequence { get }
    var contentArray: [ContentItem] { get }
    
    func save(day: Day)
    func delete(day: Day)
    func addNewTextContent(for day: Day)
    func addNewPhotoContent(with data: Data, for day: Day)
    func select(content: ContentItem)
    func deselectAll()
    func isSelected(content: ContentItem) -> Bool
    func isAnySelected() -> Bool
    
}

class DayViewModel: DayViewModelProtocol, PhotoDataUpdateDelegatProtocol, ContentChangeDelegateProtocol {

    private let contentSequenceProvider: ViewContentSequenceUseCaseProtocol
    private var saveDayUseCase: SaveDayUseCaseProtocol
    private var saveContentUseCase: SaveContentUseCaseProtocol
    private var deleteDayUseCase: DeleteDayUseCaseProtocol
    private var deleteContentUseCase: DeleteContentUseCaseProtocol
    
    public private(set) var day: Day
    public private(set) var contentSequence: ContentSequence
    var contentArray: [ContentItem] {
        contentSequence.contentItems.sorted()
    }
    
    private var didUpdateCoverPhoto = false
    
    init(contentSequenceProvider: ViewContentSequenceUseCaseProtocol = ViewContentSequenceUseCase(), 
         day: Day,
         saveDayUseCase: SaveDayUseCaseProtocol = SaveDayUseCase(),
         saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase(),
         deleteDayUseCase: DeleteDayUseCaseProtocol = DeleteDayUseCase(),
         deleteContentUseCase: DeleteContentUseCaseProtocol = DeleteContentUseCase()) {
        self.contentSequenceProvider = contentSequenceProvider
        self.day = day
        self.contentSequence = contentSequenceProvider.fetchContentSquence(for: day)
        self.saveDayUseCase = saveDayUseCase
        self.saveContentUseCase = saveContentUseCase
        self.deleteDayUseCase = deleteDayUseCase
        self.deleteContentUseCase = deleteContentUseCase
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
        let newContent = ContentItem(id: UUID().uuidString,
                                 day:  day,
                                 sequenceIndex: contentSequence.contentItems.count, //Place at the end
                                 type: .photo,
                                 photoFileName: nil,
                                 text: "",
                                 creationDate: Date.now,
                                 lastUpdateDate: Date.now,
                                 lastSaveDate: nil)
        
        newContent.photoData = data
        saveContentUseCase.saveImageDataFor(content: newContent, data: data)
        
        contentSequence.add(content: newContent)
        contentSequence.select(content: newContent)
        saveContentUseCase.save(content: newContent, for:  day)
        
        print("saved new photo content. SequenceCount \(contentSequence.contentItems.count)")
    }
    
    func addNewTextContent(for day: Day) {
        print("saving new text content. SequenceCount \(contentSequence.contentItems.count)")
        
        let newContent = ContentItem(id: UUID().uuidString,
                                 day: day,
                                 sequenceIndex: contentSequence.contentItems.count, //Place at the end
                                 type: .text,
                                 photoFileName: nil,
                                 text: "",
                                 creationDate: Date.now,
                                 lastUpdateDate: Date.now,
                                 lastSaveDate: nil)
        
        contentSequence.add(content: newContent)
        contentSequence.select(content: newContent)
        saveContentUseCase.save(content: newContent, for:  day)
        
        print("saved new text content. SequenceCount \(contentSequence.contentItems.count)")
    }
    
    func select(content: ContentItem) {
        contentSequence.select(content: content)
    }
    
    func deselectAll() {
        contentSequence.deselectAll()
    }
    
    func isSelected(content: ContentItem) -> Bool {
        if let selectedContent = contentSequence.selectedItem {
            
            
            if content.id == selectedContent.id {
                print("returning TRUE: \(content.id) == \(selectedContent.id)")
                return true
            } else {
                print("returning FALSE: \(content.id) == \(selectedContent.id)")
                return false
            }
        }
        
        print("no item selected to compare against")
        return false
    }
    
    func isAnySelected() -> Bool {
        contentSequence.selectedItem != nil
    }
    
    func delete(content: ContentItem) {
        deselectAll()
        contentSequence.remove(content: content)
        deleteContentUseCase.delete(content: content)
    }
}
