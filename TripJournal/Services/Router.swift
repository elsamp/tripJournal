//
//  Router.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-30.
//

import Foundation
import SwiftUI


class Router: ObservableObject {
    
    static let shared = Router()
    @Published var path: NavigationPath = NavigationPath()
    
    private init() { }
}
