//
//  DaySequenceView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

struct DaySequenceView<ViewModel>: View where ViewModel: DaySequenceViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(viewModel.sortedDays) { day in
                NavigationLink(value: day) {
                    DaySequenceItemView(day: day)
                        .padding(.vertical, 8)
                }
            }
             
        }
    }
}


#Preview {
    
    DaySequenceView(viewModel: PreviewHelper.shared.mockDaySequence())

}
