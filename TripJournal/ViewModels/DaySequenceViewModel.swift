//
//  DaySequence.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation

protocol DaySequenceViewModelProtocol: ObservableObject {
    
    associatedtype DayModel: DayViewModelProtocol where DayModel.TripModel == TripModel
    associatedtype TripModel: TripViewModelProtocol
    
    var trip: TripModel { get }
    var sortedDays: [DayModel]  { get }
    
    func newDay() -> DayModel
    func cancelEdit(for day: DayModel)
    func remove(day: DayModel)
    
}

class DaySequenceViewModel: DaySequenceViewModelProtocol  {
    
    typealias DayModel = DayViewModel
    typealias TripModel = TripViewModel
        
    private var days: Set<DayViewModel> {
        didSet {
            sortedDays = Array(days).sorted()
        }
    }
    
    var trip: TripViewModel
    @Published var sortedDays: [DayViewModel]
    
    init(trip: TripViewModel, days: Set<DayViewModel>) {
        self.trip = trip
        self.days = days
        self.sortedDays = Array(days).sorted()
    }
    
    func newDay() -> DayViewModel {
        
        let newDay = DayViewModel(id: UUID().uuidString,
                                  trip: trip,
                                  date: Date.now,
                                  title: "",
                                  coverPhotoPath: nil,
                                  coverImageData: nil,
                                  creationDate: Date.now,
                                  lastUpdateDate: Date.now,
                                  lastSaveDate: nil)
        
        days.insert(newDay)
        
        return newDay
    }
    
    func cancelEdit(for day: DayViewModel) {
        //if day not yet saved
        //days.remove(day)
        //else, refetch trip data from dataStore
    }
    
    func remove(day: DayViewModel) {
        days.remove(day)
    }
}
