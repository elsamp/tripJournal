//
//  TripYearView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-04.
//

import SwiftUI

struct TripYearView: View {
    
    let trips: [Trip]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(trips) { trip in
                
                NavigationLink(value: trip) {
                    TripSummaryView(trip: trip)
                }
                
            }
        }
    }
}

#Preview {
    TripYearView(trips: [PreviewHelper.shared.mockTrip()])
}
