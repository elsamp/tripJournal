//
//  ContentSequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

protocol ContentSequenceViewModelProtocol: ObservableObject {
    
    associatedtype ContentModel: ContentViewModelProtocol
    associatedtype DayModel: DayViewModelProtocol
    
    var day: DayModel { get }
    var sortedContentItems: [ContentModel] {get}
    var selectedItem: ContentModel? { get set }
    
    func addNewTextContent()
    func addNewPhotoContent(with data: Data)
    func select(content: ContentModel)
    func deselectAll()
    func isSelected(content: ContentModel) -> Bool
    func isAnySelected() -> Bool
}

class ContentSequenceViewModel: ContentSequenceViewModelProtocol, SequencedItemChangeDelegateProtocol {

    typealias ContentModel = ContentViewModel
    typealias DayModel = DayViewModel
    
    var day: DayViewModel
    @Published var selectedItem: ContentModel? = nil
    @Published var sortedContentItems: [ContentModel] = []
    
    private var saveContentUseCase: SaveContentUseCaseProtocol
    private var deleteContentUseCase: DeleteContentUseCaseProtocol
    
    private var contentItems: [ContentViewModel] {
        didSet {
            sortedContentItems = contentItems.sorted()
        }
    }

    init(day: DayViewModel,
         contentItems: [ContentModel],
         saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase(),
         deleteContentUseCase: DeleteContentUseCaseProtocol = DeleteContentUseCase()) {
        
        self.day = day
        self.contentItems = contentItems.sorted()
        self.sortedContentItems = self.contentItems
        self.saveContentUseCase = saveContentUseCase
        self.deleteContentUseCase = deleteContentUseCase
        
        registerContentChangeDelegate(self)
    }
    
    func registerContentChangeDelegate(_ delegate: ContentSequenceViewModel) {
        
        for item in contentItems {
            item.registerChangeDelegate(delegate)
        }
    }
    
    func add(content: ContentModel) {
        contentItems.append(content)
    }
    
    func add(item: ContentModel, at index: Int? = nil) {
        contentItems.sort()
        
        if let index = index {
            contentItems.insert(item, at: index)
        } else {
            contentItems.append(item)
        }
        
        resetContentIdices()
    }
    
    func remove(content: ContentModel) {
        
    }
    
    func delete(_ content: ContentModel) {
        deselectAll()

        contentItems.removeAll { item in
            item.id == content.id
        }
        deleteContentUseCase.delete(content: content)
        contentItems.sort()
        
        resetContentIdices()

    }
    
    private func resetContentIdices() {
        for i in 0..<contentItems.count {
            
            if contentItems[i].sequenceIndex != i {
                contentItems[i].sequenceIndex = i
                saveContentUseCase.save(content: contentItems[i])
            }
        }
    }
    
    func select(content: ContentModel) {
        print("Selected \(content.id)")
        selectedItem = content
    }
    
    func deselectAll() {
        selectedItem = nil
    }
    
    func addNewTextContent() {
        let newContent = ContentViewModel(id: UUID().uuidString,
                                          day: day,
                                          sequenceIndex: contentItems.count, //Place at the end
                                          type: .text,
                                          photoFileName: nil,
                                          text: "",
                                          creationDate: Date.now,
                                          displayTimestamp: Date.now,
                                          lastUpdateDate: Date.now,
                                          lastSaveDate: nil,
                                          contentChangeDelegate: self)
                
        add(content: newContent)
        select(content: newContent)
        saveContentUseCase.save(content: newContent)
    }
    
    func addNewPhotoContent(with data: Data) {
        let newContent = ContentViewModel(id: UUID().uuidString,
                                          day:  day,
                                          sequenceIndex: contentItems.count, //Place at the end
                                          type: .photo,
                                          photoFileName: nil,
                                          text: "",
                                          creationDate: Date.now,
                                          displayTimestamp: Date.now,
                                          lastUpdateDate: Date.now,
                                          lastSaveDate: nil,
                                          contentChangeDelegate: self)
                
        newContent.photoData = data
        saveContentUseCase.saveImageData(data, tripId: day.trip.id, dayId: day.id, contentId: newContent.id)
                
        add(content: newContent)
        select(content: newContent)
        saveContentUseCase.save(content: newContent)
    }
    
    func isSelected(content: ContentModel) -> Bool {
        if let selectedContent = selectedItem {
            
            if content.id == selectedContent.id {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isAnySelected() -> Bool {
        print(selectedItem?.id ?? "nil")
        return selectedItem != nil
    }
    
    
}
