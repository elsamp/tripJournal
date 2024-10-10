//
//  DayHeaderView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

struct DayHeaderView<ViewModel>: View where ViewModel: DayViewModelProtocol{
    
    @ObservedObject var day: ViewModel
    @Binding var isEditing: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            if isEditing {
                TextField("Day:", text: $day.title)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 10)
                
                DatePicker("Date", selection: $day.date, displayedComponents: .date)
                    .labelsHidden()
                
            } else {
                Text(day.title)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.textTitle)
                
                Text(dateFormatter.string(from: day.date))
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
}

#Preview {
    
    struct PreviewView: View {
        
        var day = PreviewHelper.shared.mockDay()
        @State private var isEditing = false
       
        var body: some View {
            Text("Broken Preview: Need to Fix")
                .foregroundStyle(.red)
            //DayHeaderView(day: day, isEditing: $isEditing)
        }
        
    }
    
    return PreviewView()
}
