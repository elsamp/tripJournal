//
//  Array<Trip>+sort.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-03.
//

import Foundation


extension Trip: Comparable {
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        lhs.startDate < rhs.startDate
    }
}
