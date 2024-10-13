//
//  TripDetailsView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-08.
//

import SwiftUI

struct TripHeaderView<ViewModel>: View where ViewModel: TripViewModelProtocol {

    @ObservedObject var trip: ViewModel
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            //Trip Title
            if isEditing {
                TextField("My Trip", text: $trip.title)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 10)
                
                HStack {
                    DatePicker("Start Date", selection: $trip.startDate, displayedComponents: .date)
                        .labelsHidden()
                    Text("to")
                    DatePicker("End Date", selection: $trip.endDate, displayedComponents: .date)
                        .labelsHidden()
                }
                
            } else {
                Text(trip.title)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.textTitle)
                
                Text(dateRange(for: trip))
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.textSubheader)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
    
    func dateRange(for trip: ViewModel) -> String {
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        
        let calendar = Calendar(identifier: .gregorian)
        let startDay = calendar.component(.day, from: trip.startDate)
        let startMonth = calendar.component(.month, from: trip.startDate)
        
        var dateComponents = DateComponents()
        dateComponents.month = startMonth
        dateComponents.day = startDay
        
        var dateRange = ""
        
        if let date = calendar.date(from: dateComponents) {
            dateRange = formatter.string(from: date)
        }
        

        let endDay = calendar.component(.day, from: trip.endDate)
        let endMonth = calendar.component(.month, from: trip.endDate)
        
        dateComponents.month = endMonth
        dateComponents.day = endDay
        
        if let date = calendar.date(from: dateComponents) {
            dateRange.append(" - \(formatter.string(from: date))")
        }
        

        print(dateRange)
        return dateRange
    }
}


#Preview {
    struct Preview: View {
        
        @State private var isEditing = false
        
        var body: some View {
            ZStack {
                Color.gray
                TripHeaderView(trip: PreviewHelper.shared.mockTrip(), isEditing: $isEditing)
            }
        }
    }
    
    return Preview()
}
