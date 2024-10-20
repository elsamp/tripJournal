//
//  DayViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation


protocol DayViewModelProtocol: ObservableObject, Identifiable, Hashable, Comparable, PhotoDataUpdateDelegatProtocol {
    
    associatedtype TripModel: TripViewModelProtocol
    associatedtype ContentSequenceModel: ContentSequenceViewModelProtocol
    
    var id: String { get }
    var trip: TripModel { get }
    var date: Date { get set }
    var title: String { get set }
    var coverPhotoPath: String? { get set }
    var coverImageData: Data? { get set }
    var creationDate: Date { get }
    var lastUpdateDate: Date { get set }
    var lastSaveDate: Date? { get set }
    var hasUnsavedChanges: Bool { get }
    var tripDayIndex: Int { get }
    
    var contentSequence: ContentSequenceModel { get }
    
    func saveDay()
    func deleteDay()
    
}

class DayViewModel: DayViewModelProtocol {
    
    typealias TripModel = TripViewModel
    typealias ContentSequenceModel = ContentSequenceViewModel
    
    let id: String
    let trip: TripViewModel
    @Published var date: Date
    @Published var title: String
    @Published var coverPhotoPath: String?
    @Published var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Day has never been saved.
            return true
        }
    }
    
    var tripDayIndex: Int {
        return Calendar.current.daysBetween(trip.startDate, and: date) + 1
    }
    
    public private(set) lazy var contentSequence: ContentSequenceViewModel = {
        contentSequenceProvider.fetchContentSquence(for: self)
    }()
    
    private var didUpdateCoverPhoto = false
    
    private let contentSequenceProvider: ViewContentSequenceUseCaseProtocol
    private var saveDayUseCase: SaveDayUseCaseProtocol
    private var deleteDayUseCase: DeleteDayUseCaseProtocol
    private weak var dayUpdateDelegate: DayUpdateDelegateProtocol?
    
    
    init(id: String,
         trip: TripViewModel,
         date: Date,
         title: String,
         coverPhotoPath: String?,
         coverImageData: Data?,
         creationDate: Date,
         lastUpdateDate: Date,
         lastSaveDate: Date?,
         contentSequenceProvider: ViewContentSequenceUseCaseProtocol = ViewContentSequenceUseCase(),
         saveDayUseCase: SaveDayUseCaseProtocol = SaveDayUseCase(),
         deleteDayUseCase: DeleteDayUseCaseProtocol = DeleteDayUseCase(),
         dayUpdateDelegate: DayUpdateDelegateProtocol? = nil) {
        
        self.id = id
        self.trip = trip
        self.date = date
        self.title = title
        self.coverPhotoPath = coverPhotoPath
        self.coverImageData = coverImageData
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate
        self.contentSequenceProvider = contentSequenceProvider
        self.saveDayUseCase = saveDayUseCase
        self.deleteDayUseCase = deleteDayUseCase
        self.dayUpdateDelegate = dayUpdateDelegate
    }
    
    func saveDay() {
        
        if didUpdateCoverPhoto {
            if let data = self.coverImageData {
                saveDayUseCase.saveCoverImage(data: data, for: self)
                didUpdateCoverPhoto = false
            }
        }
        
        saveDayUseCase.save(day: self)
    }
    
    func updateCoverImage(data: Data) {
        coverImageData = data
        didUpdateCoverPhoto = true
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        updateCoverImage(data: data)
    }
    
    func deleteDay() {
        deleteDayUseCase.delete(day: self)

    }
    
    static func == (lhs: DayViewModel, rhs: DayViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: DayViewModel, rhs: DayViewModel) -> Bool {
        lhs.date < rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
