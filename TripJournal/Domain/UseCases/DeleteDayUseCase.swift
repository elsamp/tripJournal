//
//  DeleteDayUseCase.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-04.
//

import Foundation


protocol DeleteDayUseCaseProtocol {
    func delete(day: Day)
}

struct DeleteDayUseCase: DeleteDayUseCaseProtocol {
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = RealmDataService()) {
        self.dataService = dataService
    }
    
    func delete(day: Day) {
        dataService.delete(day: day)
    }
}
