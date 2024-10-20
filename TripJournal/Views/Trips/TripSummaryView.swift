//
//  TripSummaryView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-08.
//

import SwiftUI

struct TripSummaryView<ViewModel: TripViewModelProtocol>: View {
    
    @ObservedObject var trip: ViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Color.clear
                    .overlay (
                        Group {
                            if let imageData = trip.coverImageData, let uiImage =  UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .clipped()
                            } else {
                                AsyncImage(url: ImageHelperService.shared.imageURLFor(tripId: trip.id)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                            .clipped()
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
                    .frame(height: 300)
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(trip.title)
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(.textTitle)
                        .padding(.top, 4)
                    
                    Text(dateRange(for: trip))
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.textSubheader)
                        .padding(.bottom, 14)
                }
                .padding(.horizontal, 18)

            }
            .background(.white)

        }
        .padding(.bottom, 5)
    }
    
    //TODO: move and unify
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

        return dateRange
    }
}


#Preview {
    ZStack {
        Color(.white)
        TripSummaryView(trip: PreviewHelper.shared.mockTrip())
    }
}
