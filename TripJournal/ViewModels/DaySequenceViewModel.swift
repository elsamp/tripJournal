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
    
    var trip: TripModel? { get }
    var sortedDays: [DayModel]  { get }
    
    func loadDays()
    func newDay() -> DayViewModel?
    func cancelEdit(for day: DayModel)
    func remove(day: DayModel)
    
}

enum DayViewModelCreationError: Error {
    case tripNotSet
}

class DaySequenceViewModel: DaySequenceViewModelProtocol  {

    typealias DayModel = DayViewModel
    typealias TripModel = TripViewModel
        
    private var days: Set<DayViewModel> {
        didSet {
            sortedDays = Array(days).sorted()
        }
    }
    
    private let daySequenceProvider: ViewDaySequenceUseCaseProtocol
    
    var trip: TripViewModel?
    @Published var sortedDays: [DayViewModel]
    
    init(days: Set<DayViewModel>? = nil, daySequenceProvider: any ViewDaySequenceUseCaseProtocol = ViewDaySequenceUseCase()) {
        
        if let days = days {
            self.days = days
            self.sortedDays = Array(days).sorted()
        } else {
            self.days = []
            self.sortedDays = []
        }
        self.daySequenceProvider = daySequenceProvider
    }
    
    func loadDays() {
        if let trip = trip {
            days = daySequenceProvider.fetchDaysFor(tripId: trip.id)
        }
    }
    
    func newDay() -> DayViewModel? {
        
        if let trip = trip {
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
        } else {
            return nil
        }
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
