//
//  ContentView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI

struct TripTimelineView: View {
    
    let viewModel: TripSequenceViewModelProtocol
    @StateObject var router = Router.shared
    
    init(viewModel: TripSequenceViewModelProtocol = TripSequenceViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.tripYears, id: \.self) { year in
                        TripYearHeaderView(year: year)
                        TripYearView(trips: viewModel.trips(for: year))
                    }
                }
            }
            .navigationTitle("My Trips")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Trip.self) { trip in
                TripView(viewModel: TripViewModel(trip: trip, tripUpdateDelegate: viewModel))
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        router.path.append(viewModel.newTrip())
                    } label: {
                        Text("New Trip")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(.black)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                }
                 
            }
            .toolbarBackground(.hidden, for: .bottomBar)
        }
    }
}

struct TripYearView: View {
    
    let trips: [Trip]
    
    var body: some View {
        VStack {
            ForEach(trips) { trip in
                
                NavigationLink(value: trip) {
                    TripSummaryView(trip: trip)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

struct TripYearHeaderView: View {
    
    let year: Int
    
    var body: some View {
        HStack {
            Text(verbatim: "\(year)")
                .font(.largeTitle)
        }
    }
}

struct TripSummaryView: View {
    
    @ObservedObject var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(trip.title)
                    .font(.title3)
                    .foregroundStyle(.black)
                Spacer()
                Text(dateRange(for: trip))
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }
            .padding(.horizontal)
            
            if let image = coverImageFor(trip: trip) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()
                    
                    
            } else {
                Rectangle()
                    .fill(.gray)
                    .containerRelativeFrame(.vertical, count: 7, span: 3, spacing: 0)
            }
            
            if !trip.description.isEmpty {
                Text(trip.description)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .foregroundStyle(.black)
            }
            
        }
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
    TripTimelineView()
}
