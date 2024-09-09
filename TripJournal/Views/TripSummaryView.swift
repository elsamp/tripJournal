//
//  TripSummaryView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-08.
//

import SwiftUI

struct TripSummaryView: View {
    
    @ObservedObject var trip: Trip
    
    var body: some View {
        ZStack(alignment: .bottom) {
            /*
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .opacity(0.3)
                .offset(y: 2)
             */
            
            VStack(alignment: .leading) {
                Color.clear
                    .overlay (
                        AsyncImage(url: ImageHelperService.shared.imageURL(for: trip)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .clipped()
                            } else if phase.error != nil {
                                Color.red // Indicates an error.
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                            } else {
                                Color.gray // Acts as a placeholder.
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                            }
                        }
                    )
                    .frame(height: 300)
                    .clipped()
                
                Group {
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
            .clipShape(RoundedRectangle(cornerRadius: 10))

        }
        .padding(.bottom, 5)
    }
    
    func coverImageFor(trip: Trip) -> Image? {

        if let data = trip.coverImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
    
    func dateRange(for trip: Trip) -> String {
        
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
    ZStack {
        Color(.white)
        TripSummaryView(trip: PreviewHelper.shared.mockTrip())
    }
}
