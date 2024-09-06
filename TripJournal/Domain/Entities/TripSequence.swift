//
//  TripSequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-01.
//

import Foundation


class TripSequence: Identifiable, ObservableObject {
    
    let id: String
    @Published var tripsByYear = [Int : Set<Trip>]()
    
    var tripYears: [Int] {
        tripsByYear.keys.sorted().reversed().map { $0 }
    }
    
    init(id: String, trips: Set<Trip>) {
        self.id = id
        self.tripsByYear = added(trips: trips)
    }
    
    func trips(for year: Int) -> [Trip] {
        
        if let trips = tripsByYear[year] {
            return Array(trips)
        } else {
            return []
        }
    }
    
    func add(trip: Trip) {
        self.tripsByYear = added(trip: trip, to: self.tripsByYear)
    }
    
    func updateSequence(for trip: Trip) {
        //remove trip from it's current possition and then re-add to ensure it's in the right place
        //TODO: re-think this
        remove(trip: trip)
        print("Removing \(trip.id)")
        
        add(trip: trip)
        print("Adding \(trip.id)")
    }
    
    func remove(trip: Trip) {
        self.tripsByYear = removed(trip: trip, from: self.tripsByYear)
    }
    
    private func added(trips: Set<Trip>, to dictionary: [Int : Set<Trip>] = [Int : Set<Trip>]()) -> [Int : Set<Trip>] {
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
    
    private func added(trip: Trip, to dictionary: [Int : Set<Trip>]) -> [Int : Set<Trip>] {
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
    
    private func removed(trip: Trip, from dictionary: [Int : Set<Trip>]) -> [Int : Set<Trip>] {
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

