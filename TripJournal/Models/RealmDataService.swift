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
    func createDay(_ day: Day, for trip: Trip)
    func updateDay(_ day: Day)
    func delete(day: Day)
    
    //Content
    func fetchContentFor(day: Day) -> Set<ContentItem>
    func createContent(id: String,
                       dayId: String,
                       sequenceIndex: Int,
                       type: ContentType,
                       text: String,
                       photoFileName: String?,
                       photoData: Data?,
                       creationDate: Date,
                       displayTimestamp: Date,
                       lastUpdateDate: Date,
                       lastSaveDate: Date?
    )
    func updateContent(id: String,
                       sequenceIndex: Int,
                       type: ContentType,
                       text: String,
                       photoFileName: String?,
                       photoData: Data?,
                       creationDate: Date,
                       displayTimestamp: Date,
                       lastUpdateDate: Date,
                       lastSaveDate: Date?)
    func deleteContent(withId id: String)
    
}

class RealmDataService: DataServiceProtocol {
    
    
    //MARK: Trips
    
    func fetchTrip(for id: String) -> Trip? {
        let model = tripObjectModelFor(tripId: id)
        return model?.toTrip()
    }
    
    func fetchTrips() -> Set<Trip> {
        let realm = try! Realm()
        let results = realm.objects(TripObjectModel.self)
        
        var tripArray = Set<Trip>()
        
        for tripObject in Set(results) {
            tripArray.insert(tripObject.toTrip())
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
        
        do {
            let realm = try Realm()
            let tripObjects = realm.objects(TripObjectModel.self)
            
            let results = tripObjects.where {
                $0.id == tripId
            }
            
            return results.first
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    //MARK: Days
    
    func fetchDaysFor(trip: Trip) -> Set<Day> {
        if let tripObject = tripObjectModelFor(tripId: trip.id) {
            
            print("found tripObject")
            var days = Set<Day>()
            
            for dayObject in tripObject.days {
                days.insert(dayObject.toDay(for: trip))
            }
            print("returning days \(days.count)")
            return days
        }
        
        return []
    }
        
    func createDay(_ day: Day, for trip: Trip) {
        
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
    
    func updateDay(_ day: Day) {
        if let dayObject = dayObjectModelFor(dayId: day.id) {
            let realm = try! Realm()
            try! realm.write {
                dayObject.date = day.date
                dayObject.title = day.title
                dayObject.coverPhotoPath = day.coverPhotoPath
                dayObject.creationDate = day.creationDate
                dayObject.lastUpdateDate = day.lastUpdateDate
                dayObject.lastSaveDate = day.lastUpdateDate
            }
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
    
    //MARK: Content
    
    //TODO: Refactor
    func fetchContentFor(day: Day) -> Set<ContentItem> {
        
        if let dayObject = dayObjectModelFor(dayId: day.id) {
                
            print("found dayObject")
            var contentSet = Set<ContentItem>()
            
            for contentObject in dayObject.contentSequence {
                contentSet.insert(contentObject.toContentItem(for: day))
            }
            print("returning content \(contentSet.count)")
            return contentSet
        }
        
        return []
        
    }
    
    
    func createContent(id: String,
                       dayId: String,
                       sequenceIndex: Int,
                       type: ContentType,
                       text: String,
                       photoFileName: String?,
                       photoData: Data?,
                       creationDate: Date,
                       displayTimestamp: Date,
                       lastUpdateDate: Date,
                       lastSaveDate: Date?
    ) {
        
        if let dayObjectModel = dayObjectModelFor(dayId: dayId) {
            
            let objectModel = ContentObjectModel()
            objectModel.id = id
            objectModel.sequenceIndex = sequenceIndex
            objectModel.type = type.rawValue
            objectModel.fileName = photoFileName
            objectModel.text = text
            objectModel.creationDate = creationDate
            objectModel.displayTimestamp = displayTimestamp
            objectModel.lastUpdateDate = lastUpdateDate
            objectModel.lastSaveDate = lastSaveDate ?? Date.now
            
            let realm = try! Realm()
            
            do {
                try realm.write {
                    realm.add(objectModel)
                    dayObjectModel.contentSequence.append(objectModel)
                    print("Realm: saved new Content")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    
    func updateContent(id: String,
                       sequenceIndex: Int,
                       type: ContentType,
                       text: String,
                       photoFileName: String?,
                       photoData: Data?,
                       creationDate: Date,
                       displayTimestamp: Date,
                       lastUpdateDate: Date,
                       lastSaveDate: Date?) {
        if let contentObject = contentObjectModelFor(contentId: id) {
            let realm = try! Realm()
            
            try! realm.write {
                contentObject.sequenceIndex = sequenceIndex
                contentObject.type = type.rawValue
                contentObject.fileName = photoFileName
                contentObject.text = text
                contentObject.displayTimestamp = displayTimestamp
                contentObject.lastUpdateDate = lastUpdateDate
                contentObject.lastSaveDate = lastSaveDate ?? Date.now
            }
        }
        
    }
    
    func deleteContent(withId id: String) {
        
        if let objectModel = contentObjectModelFor(contentId: id) {
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(objectModel)
            }
        }
    }
    
    //TODO: unify with other objects by using generics
    private func contentObjectModelFor(contentId: String) -> ContentObjectModel? {
        let realm = try! Realm()
        let contentObjects = realm.objects(ContentObjectModel.self)
        
        let results = contentObjects.where {
            $0.id == contentId
        }

        print("found \(results.count) content item with ID \(contentId)")
        return results.first
    }
    
    /*
    private func objectModelFor<Element>(id: String, objectType: Element.Type) -> Element? where Element : RealmFetchable & ObjectKeyIdentifiable {
        let realm = try! Realm()
        let objects = realm.objects(objectType.self)
        
        let results = objects.where {
            $0.id == id
        }
        
        return results.first
    }
     */
}
