//
//  ContentSequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import Foundation

protocol ContentSequenceViewModelProtocol: ObservableObject, ContentChangeDelegateProtocol {
    
    associatedtype ContentModel where ContentModel:ContentViewModelProtocol
    associatedtype DayModel where DayModel:DayViewModelProtocol
    
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

class ContentSequenceViewModel: ContentSequenceViewModelProtocol {

    typealias ContentModel = ContentViewModel
    typealias DayModel = DayViewModel
    
    var day: DayViewModel
    @Published var selectedItem: ContentViewModel? = nil
    @Published var sortedContentItems: [ContentViewModel] = []
    
    private var saveContentUseCase: SaveContentUseCaseProtocol
    private var deleteContentUseCase: DeleteContentUseCaseProtocol
    
    private var contentItems: [ContentViewModel] {
        didSet {
            sortedContentItems = contentItems.sorted()
        }
    }

    init(day: DayViewModel,
         contentItems: [ContentViewModel],
         saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase(),
         deleteContentUseCase: DeleteContentUseCaseProtocol = DeleteContentUseCase()) {
        
        self.day = day
        self.contentItems = contentItems.sorted()
        self.sortedContentItems = self.contentItems
        self.saveContentUseCase = saveContentUseCase
        self.deleteContentUseCase = deleteContentUseCase
        
        registerContentChangeDelegate(self)
    }
    
    func registerContentChangeDelegate(_ delegate: ContentChangeDelegateProtocol) {
        
        for item in contentItems {
            item.registerChangeDelegate(delegate)
        }
    }
    
    func add(content: ContentViewModel) {
        contentItems.append(content)
    }
    
    func add(content: ContentViewModel, at index: Int) {
        contentItems.sort()
        contentItems.insert(content, at: index)
        resetContentIdices()
    }
    
    func remove(content: ContentViewModel) {
        contentItems.sort()
        contentItems.removeAll { item in
            item.id == content.id
        }
        resetContentIdices()
    }
    
    private func resetContentIdices() {
        for i in 0..<contentItems.count {
            contentItems[i].sequenceIndex = i
        }
    }
    
    func select(content: ContentViewModel) {
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
    
    func isSelected(content: ContentViewModel) -> Bool {
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
    
    func delete(content: ContentViewModel) {
        deselectAll()
        remove(content: content)
        deleteContentUseCase.delete(content: content)
        
        //saving all other content sequence items as sequence indeces have been updated
        for item in sortedContentItems {
            saveContentUseCase.save(content: item)
        }
    }
}
