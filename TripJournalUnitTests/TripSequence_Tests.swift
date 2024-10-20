//
//  TripSequenceViewModel_Tests.swift
//  TripJournalUnitTests
//
//  Created by Erica Sampson on 2024-09-02.
//

import XCTest
@testable import TripJournal

final class TripSequenceViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetTripsByYear_InitializesCorrectly() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [1998, 1998, 2005, 2008, 2008, 2008, 2013]
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        XCTAssertEqual(sequence.tripYears.sorted(), [1998,2005,2008,2013].sorted())
        XCTAssertEqual(sequence.trips(for: 1998).count, 2)
        XCTAssertEqual(sequence.trips(for: 2005).count, 1)
        XCTAssertEqual(sequence.trips(for: 2008).count, 3)
        XCTAssertEqual(sequence.trips(for: 2013).count, 1)
    }
    
    func testAddTrip_UpdatesTripsByYearWhenNewYear() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2008, 2013]
        
        let sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        XCTAssertEqual(sequence.trips(for: 2009).count, 0)
        
        let newTrip = RandomTripGenerator().randomTrip(in: 2009)
        sequence.add(trip: newTrip)

        XCTAssertEqual(sequence.trips(for: 2009).count, 1)
        XCTAssertTrue(sequence.trips(for: 2009).contains(where: { t in
            t.id == newTrip.id
        }))
    }
    
    func testAddTrip_UpdatesTripsByYearWhenExistingYear() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2008, 2008]
        
        let sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        
        let newTrip = RandomTripGenerator().randomTrip(in: 2008)
        sequence.add(trip: newTrip)

        XCTAssertEqual(sequence.trips(for: 2008).count, 3)
        XCTAssertTrue(sequence.trips(for: 2008).contains(where: { t in
            t.id == newTrip.id
        }))
    }
    
    func testAddTrip_DoesNothingWhenTripAlreadyAdded() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2013]
        
        let trip = RandomTripGenerator().randomTrip(in: 2008)
        tripProvider.includedTrips.append(trip)
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)

        sequence.add(trip: trip)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        XCTAssertTrue(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
    }
    
    func testRemoveTrip_UpdatesTripsByYear() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2013]
        
        let trip = RandomTripGenerator().randomTrip(in: 2008)
        tripProvider.includedTrips.append(trip)
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        
        sequence.remove(trip: trip)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 1)
        XCTAssertFalse(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
    }
    
    func testRemoveTrip_DoesNothingWhenTripNotFound() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2008, 2013]
        
        let trip = RandomTripGenerator().randomTrip(in: 2008)
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 2)
        
        sequence.remove(trip: trip)
        
        XCTAssertFalse(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
        
    }
    
    func testUpdateTrip_RemovesAndReAddsCorrectly() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2013]
        
        let trip = RandomTripGenerator().randomTrip(in: 2008)
        tripProvider.includedTrips.append(trip)
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 2)
        
        trip.startDate = DateHelper().dateFor(day: 20, month: 7, year: 2013)!
        sequence.updateSequence(for: trip)
        
        trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 1)
        XCTAssertFalse(trips2008.contains(where: { t in
            t.id == trip.id
        }))
        
        var trips2013 = sequence.trips(for: 2013)
        XCTAssertEqual(trips2013.count, 2)
        XCTAssertTrue(trips2013.contains(where: { t in
            t.id == trip.id
        }))
        
    }
    
    func testUpdateTrip_RemovesYear() throws {
        
        var tripProvider = MockTripSequenceProvider()
        tripProvider.years = [2005, 2008, 2013]
        
        let trip = RandomTripGenerator().randomTrip(in: 2009)
        tripProvider.includedTrips.append(trip)
        
        var sequence = TripSequenceViewModel(tripSequenceProvider: tripProvider)
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 1)
        
        trip.startDate = DateHelper().dateFor(day: 20, month: 7, year: 2013)!
        sequence.updateSequence(for: trip)
        
        XCTAssertTrue(sequence.trips(for: 2009).isEmpty)
        XCTAssertTrue(sequence.tripYears.contains(2013))
        XCTAssertFalse(sequence.tripYears.contains(2009))
    }
    
}

struct MockTripSequenceProvider: ViewTripTimelineUseCaseProtocol {
    
    var years: [Int] = []
    var includedTrips: [TripViewModel] = []
    
    func fetchTrips() -> Set<TripViewModel> {
        
        let tripGenerator = RandomTripGenerator()
        var trips: Set<TripViewModel> = []
        
        for year in years {
            trips.insert(tripGenerator.randomTrip(in: year))
        }
        
        trips.formUnion(includedTrips)
        
        return trips
    }
}

struct DateHelper {
    
    func dateFor(day: Int, month: Int, year: Int) -> Date? {
        var calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        
        return calendar.date(from: dateComponents)
    }
}

struct RandomTripGenerator {
    
    func randomTrip(in year: Int) -> TripViewModel {
        
        if let startDate = DateHelper().dateFor(day: Int.random(in: 1...28), month: Int.random(in: 1...12), year: year) {
            
            var tripLength = Double(Int.random(in: 2...20))
            
            return TripViewModel(id: UUID().uuidString,
                                 title: "Title",
                                 description: "Description",
                                 startDate: startDate,
                                 endDate: Date.dateFor(days: tripLength, since: startDate),
                                 coverPhotoPath: nil,
                                 coverImageData: nil,
                                 creationDate: startDate,
                                 lastUpdateDate: Date.dateFor(days: tripLength + 2, since: startDate),
                                 lastSaveDate: Date.dateFor(days: tripLength + 2, since: startDate))
        } else {
            return TripViewModel(id: "",
                                 title: "",
                                 description: "",
                                 startDate: Date.now,
                                 endDate: Date.now,
                                 coverPhotoPath: nil,
                                 coverImageData: nil,
                                 creationDate: Date.now,
                                 lastUpdateDate: Date.now,
                                 lastSaveDate: Date.now)
        }
    }
}


