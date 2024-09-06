//
//  TripViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol TripViewModelProtocol {
    var trip: Trip { get }
    var days: [Day] { get }
    var coverImageData: Data? { get }
    
    func save(trip: Trip)
    func cancelEdit() 
    func delete(trip: Trip)
    func newDay() -> Day
    func updateCoverImage(data: Data)
}

protocol DayUpdateDelegateProtocol: AnyObject {
    func handleChanges(for day: Day)
    func handleDeletion(of day: Day)
}

class TripViewModel: TripViewModelProtocol, DayUpdateDelegateProtocol {
    
    private var daySequenceProvider: ViewDaySequenceUseCaseProtocol
    private var daySequence: DaySequence
    private var saveTripUseCase: SaveTripUseCaseProtocol
    private var fetchTripUseCase: FetchTripUseCaseProtocol
    private var deleteTripUseCase: DeleteTripUseCaseProtocol
    
    weak var tripUpdateDelegate: TripUpdateDelegateProtocol?
    
    var didUpdateCoverPhoto = false
    var coverImageData: Data? {
        trip.coverImageData
    }
    
    var trip: Trip
    var days: [Day] {
        Array(daySequence.days)
    }
    
    init(daySequenceProvider: ViewDaySequenceUseCaseProtocol = ViewDaySequenceUseCase(), 
         trip:Trip,
         saveTripUseCase: SaveTripUseCaseProtocol = SaveTripUseCase(),
         deleteTripUseCase: DeleteTripUseCaseProtocol = DeleteTripUseCase(),
         fetchTripUseCase: FetchTripUseCaseProtocol = FetchTripUseCase(),
         tripUpdateDelegate: TripUpdateDelegateProtocol?) {
        
        self.daySequenceProvider = daySequenceProvider
        self.trip = trip
        self.daySequence = daySequenceProvider.fetchDaysFor(trip: trip)
        self.saveTripUseCase = saveTripUseCase
        self.deleteTripUseCase = deleteTripUseCase
        self.fetchTripUseCase = fetchTripUseCase
        self.tripUpdateDelegate = tripUpdateDelegate
    }
    
    func save(trip: Trip) {
        if didUpdateCoverPhoto {
            if let data = trip.coverImageData {
                saveTripUseCase.saveCoverImage(data: data, for: trip)
                didUpdateCoverPhoto = false
            }
        }
        
        trip.lastUpdateDate = Date.now
        saveTripUseCase.save(trip: trip)
        tripUpdateDelegate?.handleChanges(for: trip)
    }
    
    func updateCoverImage(data: Data) {
        trip.coverImageData = data
        didUpdateCoverPhoto = true
    }
    
    func cancelEdit() {
        if let lastSavedTripState = fetchTripUseCase.fetchTrip(for: trip.id) {
            trip = lastSavedTripState
            didUpdateCoverPhoto = false
        }
    }
    
    func delete(trip: Trip) {
        deleteTripUseCase.delete(trip: trip)
        tripUpdateDelegate?.handleDeletion(of: trip)
    }
    
    func newDay() -> Day {
        Day(id: UUID().uuidString, trip: trip, date: Date.now, title: "", coverPhotoPath: nil, creationDate: Date.now, lastUpdateDate: Date.now)
    }
    
    func handleChanges(for day: Day) {
        
    }
    
    func handleDeletion(of day: Day) {
        
    }
    
}

