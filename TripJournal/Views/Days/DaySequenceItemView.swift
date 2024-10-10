//
//  DaySequenceItemView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-09.
//

import SwiftUI

struct DaySequenceItemView<ViewModel>: View where ViewModel: DayViewModelProtocol {
    
    @ObservedObject var day: ViewModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            //TODO: make this async
            if let data = ImageHelperService.shared.fetchImageDataFor(tripId: day.trip.id, dayId: day.id, contentId: nil), let uiImage = UIImage(data: data) {
                Circle()
                    .overlay (
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    )
                    .containerRelativeFrame(.horizontal, count:5, spacing: 20)
                    .clipShape(.circle)
            } else {
                Circle()
                    .foregroundColor(.gray)
                    .containerRelativeFrame(.horizontal, count:5, spacing: 20)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Day \(day.tripDayIndex)")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.accentMain)
                    Text(dateFormatter.string(from: day.date))
                        .font(.caption)
                        .foregroundStyle(.textSubheader)
                }
                
                //Divider line
                Rectangle()
                    .frame(width: 1, height: 35)
                    .foregroundStyle(.gray)
                    .opacity(0.5)
                    .padding(.horizontal, 5)
                
                Text(day.title)
                    .font(.headline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.textTitle)
                    .lineLimit(2)
                
                Spacer()
            }
            
            Spacer()
            
        }
    }
}


#Preview {
    Text("Broken Preview: Need To Fix")
        .foregroundStyle(.red)
    //DaySequenceItemView(day: PreviewHelper.shared.mockDay())
}
