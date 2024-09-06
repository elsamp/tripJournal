//
//  RealmDataService.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-28.
//

import Foundation
import RealmSwift

protocol DataServiceProtocol {
    //Trips
    func fetchTrip(for id: String) -> Trip?
    func fetchTrips() -> Set<Trip>
    func save(trip: Trip)
    func delete(trip: Trip)
    
    //Days
    func fetchDaysFor(trip: Trip) -> Set<Day>
    func save(day: Day, for trip: Trip)
    func delete(day: Day)
    
}

class RealmDataService: DataServiceProtocol {
    
    //MARK: Trips (CRUD)
    
    func fetchTrip(for id: String) -> Trip? {
        let model = tripObjectModelFor(tripId: id)
        return model?.trip()
    }
    
    func fetchTrips() -> Set<Trip> {
        let realm = try! Realm()
        let results = realm.objects(TripObjectModel.self)
        
        var tripArray = Set<Trip>()
        
        for tripObject in Set(results) {
            tripArray.insert(tripObject.trip())
        }

        print("Returning Trips: \(results.count)")
        return tripArray
    }
    
    func save(trip: Trip){
        
        if let tripObject = tripObjectModelFor(tripId: trip.id) {
            update(tripObject: tripObject, from: trip)
            print("Saving Trip")
        } else {
            create(trip: trip)
            print("Saving Trip")
        }
    }
    
    private func create(trip: Trip) {

        let model = TripObjectModel()
        
        model.id = trip.id
        model.title = trip.title
        model.summaryText = trip.description
        model.startDate = trip.startDate
        model.endDate = trip.endDate
        model.coverPhotoPath = trip.coverPhotoPath
        model.days = List<DayObjectModel>()
        model.creationDate = trip.creationDate
        model.lastUpdateDate = trip.lastUpdateDate
        model.lastSaveDate = trip.lastSaveDate ?? Date.now
        
        print("saving model \(model.id)")
        let realm = try! Realm()
        try! realm.write {
            realm.add(model)
        }
    }
    
    private func update(tripObject: TripObjectModel, from trip: Trip) {
        
        let realm = try! Realm()
        try! realm.write {
            tripObject.title = trip.title
            tripObject.summaryText = trip.description
            tripObject.startDate = trip.startDate
            tripObject.endDate = trip.endDate
            tripObject.coverPhotoPath = trip.coverPhotoPath
            tripObject.creationDate = trip.creationDate
            tripObject.lastUpdateDate = trip.lastUpdateDate
            tripObject.lastSaveDate = trip.lastSaveDate ?? Date.now
        }
    }
    
    func delete(trip: Trip) {
        let realm = try! Realm()
        if let objectModel = tripObjectModelFor(tripId: trip.id) {
            try! realm.write {
                realm.delete(objectModel)
            }
        }
    }
    
    private func tripObjectModelFor(tripId: String) -> TripObjectModel? {
        let realm = try! Realm()
        let tripObjects = realm.objects(TripObjectModel.self)
        
        let results = tripObjects.where {
            $0.id == tripId
        }
        
        return results.first
    }
    
    
    //MARK: Days
    
    func fetchDaysFor(trip: Trip) -> Set<Day> {
        if let tripObject = tripObjectModelFor(tripId: trip.id) {
            
            print("found tripObject")
            var days = Set<Day>()
            
            for dayObject in tripObject.days {
                days.insert(dayObject.day(for: trip))
            }
            print("returning days \(days.count)")
            return days
        }
        
        return []
    }
    
    func save(day: Day, for trip: Trip) {
        if let dayObject = dayObjectModelFor(dayId: day.id) {
            update(objectModel: dayObject, for: day)
            print("updated Day")
        } else {
            createObjectModelDay(day, for: trip)
            print("created new Day")
        }
    }
    
    private func createObjectModelDay(_ day: Day, for trip: Trip) {
        
        let dayModel = DayObjectModel()
        if let tripModel = tripObjectModelFor(tripId: trip.id) {
            
            dayModel.id = day.id
            dayModel.date = day.date
            dayModel.title = day.title
            dayModel.coverPhotoPath = day.coverPhotoPath
            dayModel.creationDate = day.creationDate
            dayModel.lastUpdateDate = day.lastUpdateDate
            dayModel.lastSaveDate = day.lastSaveDate ?? Date.now
            
            let realm = try! Realm()
            
            do{
                try realm.write {
                    realm.add(dayModel)
                    tripModel.days.append(dayModel)
                    print("appending day \(dayModel) for trip \(tripModel)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func update(objectModel: DayObjectModel, for day: Day) {
        let realm = try! Realm()
        try! realm.write {
            objectModel.date = day.date
            objectModel.title = day.title
            objectModel.coverPhotoPath = day.coverPhotoPath
            //TODO: update content sequence
            objectModel.creationDate = day.creationDate
            objectModel.lastUpdateDate = day.lastUpdateDate
            objectModel.lastSaveDate = day.lastUpdateDate
        }
    }
    
    func delete(day: Day) {
        let realm = try! Realm()
        if let objectModel = dayObjectModelFor(dayId: day.id) {
            try! realm.write {
                realm.delete(objectModel)
            }
        }
    }
    
    //TODO: unify with other objects by using generics
    private func dayObjectModelFor(dayId: String) -> DayObjectModel? {
        let realm = try! Realm()
        let dayObjects = realm.objects(DayObjectModel.self)
        
        let results = dayObjects.where {
            $0.id == dayId
        }
        
        return results.first
    }
}
