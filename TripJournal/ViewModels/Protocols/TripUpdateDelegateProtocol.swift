//
//  TripUpdateDelegateProtocol.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-10.
//

import Foundation

protocol TripUpdateDelegateProtocol: AnyObject {
    func handleChanges(for trip: TripViewModel)
    func handleDeletion(of trip: TripViewModel)
}
