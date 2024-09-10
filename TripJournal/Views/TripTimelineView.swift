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
                VStack(alignment: .center) {
                    
                    Text("Trip Journal")
                        .font(.custom("BradleyHandITCTT-Bold", size: 30))
                        .foregroundStyle(.accentMain)
                    
                    ForEach(viewModel.tripYears, id: \.self) { year in
                        TripYearHeaderView(year: year)
                        TripYearView(trips: viewModel.trips(for: year))
                    }
                }
            }
            .frame(maxWidth: .infinity)
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
                    .background(.accentMain)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                }
                 
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .background(.white)
        }
    }
}

struct TripYearView: View {
    
    let trips: [Trip]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(trips) { trip in
                
                NavigationLink(value: trip) {
                    TripSummaryView(trip: trip)
                }
                .padding(.horizontal, 10)
                
            }
        }
    }
}

struct TripYearHeaderView: View {
    
    let year: Int
    
    var body: some View {
        HStack {
            Text(verbatim: "\(year)")
                .font(.system(size: 60))
                .fontWeight(.ultraLight)
                .foregroundStyle(.textTitle)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    TripTimelineView(viewModel: TripSequenceViewModel(tripSequenceProvider: PreviewViewTripTimelineUseCase()))
}
