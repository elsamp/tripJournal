//
//  TripSequence_Tests.swift
//  TripJournalUnitTests
//
//  Created by Erica Sampson on 2024-09-02.
//

import XCTest
@testable import TripJournal

final class TripSequence_Tests: XCTestCase {
    
    var tripSequence: TripSequence?

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetTripsByYear_InitializesCorrectly() throws {
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 1998),
        randomTrip(in: 1998),
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        randomTrip(in: 2008),
        randomTrip(in: 2008),
        randomTrip(in: 2013),
        ])
        
        XCTAssertEqual(sequence.tripYears.sorted(), [1998,2005,2008,2013].sorted())
        XCTAssertEqual(sequence.trips(for: 1998).count, 2)
        XCTAssertEqual(sequence.trips(for: 2005).count, 1)
        XCTAssertEqual(sequence.trips(for: 2008).count, 3)
        XCTAssertEqual(sequence.trips(for: 2013).count, 1)
    }
    
    func testAddTrip_UpdatesTripsByYearWhenNewYear() throws {
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        randomTrip(in: 2008),
        randomTrip(in: 2013),
        ])
        
        XCTAssertEqual(sequence.trips(for: 2009).count, 0)
        
        var newTrip = randomTrip(in: 2009)
        sequence.add(trip: newTrip)

        XCTAssertEqual(sequence.trips(for: 2009).count, 1)
        XCTAssertTrue(sequence.trips(for: 2009).contains(where: { t in
            t.id == newTrip.id
        }))
    }
    
    func testAddTrip_UpdatesTripsByYearWhenExistingYear() throws {
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        randomTrip(in: 2008),
        randomTrip(in: 2013),
        ])
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        
        var newTrip = randomTrip(in: 2008)
        sequence.add(trip: newTrip)

        XCTAssertEqual(sequence.trips(for: 2008).count, 3)
        XCTAssertTrue(sequence.trips(for: 2008).contains(where: { t in
            t.id == newTrip.id
        }))
    }
    
    func testAddTrip_DoesNothingWhenTripAlreadyAdded() throws {
        
        let trip = randomTrip(in: 2008)
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        trip,
        randomTrip(in: 2013),
        ])
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)

        sequence.add(trip: trip)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        XCTAssertTrue(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
    }
    
    func testRemoveTrip_UpdatesTripsByYear() throws {
        
        let trip = randomTrip(in: 2008)
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        trip,
        randomTrip(in: 2008),
        randomTrip(in: 2013),
        ])
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 2)
        
        sequence.remove(trip: trip)
        
        XCTAssertEqual(sequence.trips(for: 2008).count, 1)
        XCTAssertFalse(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
    }
    
    func testRemoveTrip_DoesNothingWhenTripNotFound() throws {
        let trip = randomTrip(in: 2008)
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        randomTrip(in: 2008),
        randomTrip(in: 2013),
        ])
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 2)
        
        sequence.remove(trip: trip)
        
        XCTAssertFalse(sequence.trips(for: 2008).contains(where: { t in
            t.id == trip.id
        }))
        
    }
    
    func testUpdateTrip_RemovesAndReAddsCorrectly() throws {
        var trip = randomTrip(in: 2008)
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        trip,
        randomTrip(in: 2013),
        ])
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 2)
        
        trip.startDate = dateFor(day: 20, month: 7, year: 2013)!
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
        var trip = randomTrip(in: 2009)
        
        var sequence = TripSequence(id: UUID().uuidString, trips: [
        randomTrip(in: 2005),
        randomTrip(in: 2008),
        trip,
        randomTrip(in: 2013),
        ])
        
        var trips2008 = sequence.trips(for: 2008)
        XCTAssertEqual(trips2008.count, 1)
        
        trip.startDate = dateFor(day: 20, month: 7, year: 2013)!
        sequence.updateSequence(for: trip)
        
        XCTAssertTrue(sequence.trips(for: 2009).isEmpty)
        XCTAssertTrue(sequence.tripYears.contains(2013))
        XCTAssertFalse(sequence.tripYears.contains(2009))
    }
    
    func dateFor(day: Int, month: Int, year: Int) -> Date? {
        var calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        
        return calendar.date(from: dateComponents)
    }
    
    func randomTrip(in year: Int) -> Trip {
        
        if let startDate = dateFor(day: Int.random(in: 1...28), month: Int.random(in: 1...12), year: year) {
            
            var tripLength = Double(Int.random(in: 2...20))
            
            return Trip(id: UUID().uuidString,
                        startDate: startDate,
                        endDate: Date.dateFor(days: tripLength, since: startDate),
                        creationDate: startDate,
                        lastUpdateDate: Date.dateFor(days: tripLength + 2, since: startDate),
                        lastSaveDate: Date.dateFor(days: tripLength + 2, since: startDate))
        } else {
            return Trip(id: "", startDate: Date.now, endDate: Date.now, creationDate: Date.now, lastUpdateDate: Date.now, lastSaveDate: Date.now)
        }
    }

}
