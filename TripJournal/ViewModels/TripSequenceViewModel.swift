//
//  TripSequenceViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol TripSequenceViewModelProtocol: TripUpdateDelegateProtocol {
    var tripYears: [Int] { get }
    func trips(for year: Int) -> [Trip]
    func newTrip() -> Trip
}

protocol TripUpdateDelegateProtocol: AnyObject {
    func handleChanges(for trip: Trip)
    func handleDeletion(of trip: Trip)
}

class TripSequenceViewModel: TripSequenceViewModelProtocol, TripUpdateDelegateProtocol {

    let tripSequenceProvider: ViewTripTimelineUseCaseProtocol
    private var tripSequence: TripSequence

    init(tripSequenceProvider: ViewTripTimelineUseCaseProtocol = ViewTripTimelineUseCase()) {
        self.tripSequenceProvider = tripSequenceProvider
        self.tripSequence = tripSequenceProvider.fetchTripSequence()
    }
    
    //MARK: CRUD
    //Create
    func newTrip() -> Trip {
        Trip(id: UUID().uuidString,
             startDate: Date.now,
             endDate: Date.dateFor(days: 1, since: Date.now),
             creationDate: Date.now,
             lastUpdateDate: Date.now,
             lastSaveDate: nil)
    }
    
    //Read
    var tripYears: [Int] {
        tripSequence.tripYears
    }
    
    func trips(for year: Int) -> [Trip] {
        tripSequence.trips(for: year)
    }
    
    //Update
    //TODO: explore wether we can/should do this with Combine
    func handleChanges(for trip: Trip) {
        tripSequence.updateSequence(for: trip)
    }
    
    //Delete
    func handleDeletion(of trip: Trip) {
        tripSequence.remove(trip: trip)
    }
    
}
