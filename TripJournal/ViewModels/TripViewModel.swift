//
//  TripViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol TripViewModelProtocol: ObservableObject, Hashable, Identifiable, PhotoDataUpdateDelegatProtocol, DayUpdateDelegateProtocol, PhotoDataUpdateDelegatProtocol {
    
    associatedtype DaySequenceModel: DaySequenceViewModelProtocol
    
    var id: String { get }
    var title: String { get set }
    var description: String { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var coverPhotoPath: String? { get }
    var coverImageData: Data? { get set }
    var creationDate: Date { get }
    var lastUpdateDate: Date { get set }
    var lastSaveDate: Date? { get }
    var hasUnsavedChanges: Bool { get }
    var daySequence: DaySequenceModel { get }
    var tripYear: Int { get }
    
    func viewTripDetails()
    func saveTrip()
    func cancelEdit()
    func deleteTrip()
    func updateCoverImage(data: Data)
    func imageDataUpdatedTo(_ data: Data)
}

protocol DayUpdateDelegateProtocol: AnyObject {
    func handleChanges(for day: Day)
    func handleDeletion(of day: Day)
}

class TripViewModel: TripViewModelProtocol {
    
    typealias DaySequenceModel = DaySequenceViewModel
    
    let id: String
    @Published var title: String
    @Published var description: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var coverPhotoPath: String?
    @Published var coverImageData: Data?
    let creationDate: Date
    var lastUpdateDate: Date
    var lastSaveDate: Date?
    var hasUnsavedChanges: Bool {
        
        if let saveDate = lastSaveDate {
            return lastUpdateDate > saveDate
        } else {
            //Trip has never been saved.
            return true
        }
    }
    
    var tripYear: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self.startDate)
    }
    
    @Published var daySequence: DaySequenceViewModel
    
    private var saveTripUseCase: SaveTripUseCaseProtocol
    private var deleteTripUseCase: DeleteTripUseCaseProtocol
    
    weak var tripUpdateDelegate: TripUpdateDelegateProtocol?
    var didUpdateCoverPhoto = false
    
    init(id: String,
         title: String,
         description: String,
         startDate: Date,
         endDate: Date,
         coverPhotoPath: String?,
         coverImageData: Data?,
         creationDate: Date,
         lastUpdateDate: Date,
         lastSaveDate: Date?,
         saveTripUseCase: SaveTripUseCaseProtocol = SaveTripUseCase(),
         deleteTripUseCase: DeleteTripUseCaseProtocol = DeleteTripUseCase(),
         tripUpdateDelegate: TripUpdateDelegateProtocol? = nil) {
        
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.coverPhotoPath = coverPhotoPath
        self.coverImageData = coverImageData
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.lastSaveDate = lastSaveDate

        self.saveTripUseCase = saveTripUseCase
        self.deleteTripUseCase = deleteTripUseCase
        self.tripUpdateDelegate = tripUpdateDelegate
        
        self.daySequence = DaySequenceModel()
        self.daySequence.trip = self
        
    }
    
    func saveTrip() {
        if didUpdateCoverPhoto {
            if let data = coverImageData {
                saveTripUseCase.saveCoverImage(data: data, for: self)
                didUpdateCoverPhoto = false
            }
        }

        saveTripUseCase.save(trip: self)
        tripUpdateDelegate?.handleChanges(for: self)
    }
    
    func viewTripDetails() {
        self.daySequence.loadDays()
    }
    
    func updateCoverImage(data: Data) {
        coverImageData = data
        didUpdateCoverPhoto = true
    }
    
    func imageDataUpdatedTo(_ data: Data) {
        updateCoverImage(data: data)
    }
    
    func cancelEdit() {
        //TODO: Make this work again
    }
    
    func deleteTrip() {
        deleteTripUseCase.delete(trip: self)
        tripUpdateDelegate?.handleDeletion(of: self)
    }
    
    //TODO: Move to DaySequence
    func handleChanges(for day: Day) {
        
    }
    //TODO: Move to DaySequence
    func handleDeletion(of day: Day) {
        
    }
    
    static func == (lhs: TripViewModel, rhs: TripViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: TripViewModel, rhs: TripViewModel) -> Bool {
        lhs.startDate < rhs.startDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

