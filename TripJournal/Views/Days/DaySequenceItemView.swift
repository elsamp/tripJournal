//
//  DaySequenceItemView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-09.
//

import SwiftUI

struct DaySequenceItemView<ViewModel: DayViewModelProtocol>: View {
    
    @ObservedObject var day: ViewModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    init(day: ViewModel) {
        self.day = day
        print(day)
    }
    
    var body: some View {
        HStack(alignment: .center) {

                Circle()
                    .overlay (
                        
                        Group {
                            
                            if let imageData = day.coverImageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                AsyncImage(url: ImageHelperService.shared.imageURLFor(tripId: day.trip.id, dayId: day.id)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else if phase.error != nil {
                                        ImageMissingView()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                    } else {
                                        ImageLoadingView()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                    }
                                }
                            }
                        }
                    )
                    .containerRelativeFrame(.horizontal, count:5, spacing: 20)
                    .clipShape(.circle)
            
            
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
    DaySequenceItemView(day: PreviewHelper.shared.mockDay())
}
