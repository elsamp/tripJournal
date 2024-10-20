//
//  ContentViewModel.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import Foundation


protocol ContentViewModelProtocol: ObservableObject, Identifiable, Hashable, Comparable, Equatable, PhotoDataUpdateDelegatProtocol  {
    
    associatedtype DayModel: DayViewModelProtocol
    
    func save()
    func delete()
    
    var id: String { get }
    var day: DayModel { get }
    var sequenceIndex: Int { get }
    var type: ContentType { get }
    var text: String { get set }
    var photoFileName: String? { get }
    var photoData: Data? { get }
    var creationDate: Date { get }
    var displayTimestamp: Date { get set }
    var lastUpdateDate: Date { get }
    var lastSaveDate: Date? { get }
    var hasUnsavedChanges: Bool { get }
}


class ContentViewModel: ContentViewModelProtocol{
    
    typealias DayModel = DayViewModel

    let id: String
    let day: DayViewModel
    @Published var sequenceIndex: Int
    @Published var type: ContentType
    @Published var text: String
    @Published var photoFileName: String?
    @Published var photoData: Data?
    let creationDate: Date
    var displayTimestamp: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Content has never been saved.
            return true
        }
    }
    
    private weak var contentChangeDelegate: (any SequencedItemChangeDelegateProtocol<ContentViewModel>)?
    private var saveContentUseCase: SaveContentUseCaseProtocol
    
    init(id: String,
         day: DayViewModel,
         sequenceIndex: Int,
         type: ContentType,
         photoFileName: String?,
         text: String,
         creationDate: Date,
         displayTimestamp: Date,
         lastUpdateDate: Date,
         lastSaveDate: Date?,
         contentChangeDelegate: (any SequencedItemChangeDelegateProtocol<ContentViewModel>)? = nil,
         saveContentUseCase: SaveContentUseCaseProtocol = SaveContentUseCase()) {
        
        self.id = id
        self.day = day
        self.sequenceIndex = sequenceIndex
        self.type = type
        self.photoFileName = photoFileName
        self.text = text
        self.creationDate = creationDate
        self.displayTimestamp = displayTimestamp
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate
        
        self.photoData = ImageHelperService.shared.fetchImageDataFor(tripId: day.trip.id, dayId: day.id, contentId: self.id)
        self.contentChangeDelegate = contentChangeDelegate
        self.saveContentUseCase = saveContentUseCase
    }
    
    func registerChangeDelegate(_ delegate: (any SequencedItemChangeDelegateProtocol<ContentViewModel>)?) {
        contentChangeDelegate = delegate
    }

    func save() {
        saveContentUseCase.save(content: self)
    }
    
    func delete() {
        if let contentChangeDelegate = contentChangeDelegate {
            contentChangeDelegate.delete(self)
        }
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        photoData = data
        saveContentUseCase.saveImageData(data, tripId: day.trip.id, dayId: day.id, contentId: id)
        save()
    }
    
    
    static func == (lhs: ContentViewModel, rhs: ContentViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: ContentViewModel, rhs: ContentViewModel) -> Bool {
        lhs.sequenceIndex < rhs.sequenceIndex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
