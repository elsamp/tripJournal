//
//  TripSequenceViewController.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import Foundation

protocol TripSequenceViewModelProtocol: ObservableObject, TripUpdateDelegateProtocol {
    
    associatedtype TripModel: TripViewModelProtocol
    
    var tripYears: [Int] { get }
    func trips(for year: Int) -> [TripModel]
    func newTrip() -> TripModel
}

class TripSequenceViewModel: TripSequenceViewModelProtocol {
    
    typealias TripModel = TripViewModel
    
    @Published var tripsByYear = [Int : Set<TripViewModel>]()
    let tripSequenceProvider: ViewTripTimelineUseCaseProtocol
    
    init(tripSequenceProvider: ViewTripTimelineUseCaseProtocol = ViewTripTimelineUseCase()) {

        self.tripSequenceProvider = tripSequenceProvider
        self.tripsByYear = added(trips: tripSequenceProvider.fetchTrips())
    }
    
    //MARK: CRUD
    //Create
    func newTrip() -> TripViewModel {
        TripViewModel(id: UUID().uuidString,
                      title: "",
                      description: "",
                      startDate: Date.now,
                      endDate: Date.dateFor(days: 1, since: Date.now),
                      coverPhotoPath: nil,
                      coverImageData: nil,
                      creationDate: Date.now,
                      lastUpdateDate: Date.now,
                      lastSaveDate: nil)

    }
    
    //Read
    var tripYears: [Int] {
        tripsByYear.keys.sorted().reversed().map { $0 }
    }
    
    func trips(for year: Int) -> [TripViewModel] {
        
        if let trips = tripsByYear[year] {
            return Array(trips)
        } else {
            return []
        }
    }
    
    //Update
    //TODO: explore whether we can/should do this with published events
    func handleChanges(for trip: TripViewModel) {
        updateSequence(for: trip)
    }
    
    //Delete
    func handleDeletion(of trip: TripViewModel) {
        remove(trip: trip)
    }
    
    func add(trip: TripViewModel) {
        self.tripsByYear = added(trip: trip, to: self.tripsByYear)
    }
    
    func updateSequence(for trip: TripViewModel) {
        //remove trip from it's current possition and then re-add to ensure it's in the right place
        //TODO: re-think this
        remove(trip: trip)
        print("Removing \(trip.id)")
        
        add(trip: trip)
        print("Adding \(trip.id)")
    }
    
    func remove(trip: TripViewModel) {
        self.tripsByYear = removed(trip: trip, from: self.tripsByYear)
    }
    
    //TODO: update to use inout
    private func added(trips: Set<TripViewModel>, to dictionary: [Int : Set<TripViewModel>] = [Int : Set<TripViewModel>]()) -> [Int : Set<TripViewModel>] {
        var tripDict = dictionary
        
        for trip in trips {
            
            let key = trip.tripYear

            if var trips = tripDict[key] {
                trips.insert(trip)
                print("Added \(trip.id)")
                tripDict[key] = trips
            } else {
                tripDict[key] = [trip]
            }
        }
        
        return tripDict
    }
    
    private func added(trip: TripViewModel, to dictionary: [Int : Set<TripViewModel>]) -> [Int : Set<TripViewModel>] {
        var tripDict = dictionary
        let key = trip.tripYear

        if var trips = tripDict[key] {
            trips.insert(trip)
            print("Added \(trip.id)")
            tripDict[key] = trips
        } else {
            tripDict[key] = [trip]
        }
        return tripDict
    }
    
    private func removed(trip: TripViewModel, from dictionary: [Int : Set<TripViewModel>]) -> [Int : Set<TripViewModel>] {
        var tripDict = dictionary

        //check all keys as year may have changed
        for key in tripDict.keys {
            if var trips = tripDict[key] {
                trips.remove(trip)
                print("Removed \(trip.id)")
                tripDict[key] = trips.isEmpty ? nil : trips
            }
        }
        return tripDict
    }
    
}
