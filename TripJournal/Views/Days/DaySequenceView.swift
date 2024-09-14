//
//  DaySequenceView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

struct DaySequenceView: View {
    
    let days: [Day]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(days) { day in
                NavigationLink(value: day) {
                    DaySequenceItemView(day: day)
                        .padding(.vertical, 8)
                }
            }
             
        }
    }
}

#Preview {
    DaySequenceView(days:[PreviewHelper.shared.mockDay(),
                          PreviewHelper.shared.mockDay(),
                          PreviewHelper.shared.mockDay()])
}
