//
//  ContentView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI

struct TripTimelineView<ViewModel: TripSequenceViewModelProtocol>: View {
    
    let viewModel: ViewModel
    @StateObject var router = Router.shared
    
    init(viewModel: ViewModel = TripSequenceViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                VStack(alignment: .center) {
                    ForEach(viewModel.tripYears, id: \.self) { year in
                        TripYearHeaderView(year: year)
                        TripYearView(trips: viewModel.trips(for: year))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationDestination(for: TripViewModel.self) { trip in
                TripView(viewModel: trip)
            }
            .toolbar {
                
                ToolbarItem(placement: .bottomBar) {
                    AddItemButton(label: "Add Trip") {
                        router.path.append(viewModel.newTrip())
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ProfileButton {
                        //TODO: Open Profile
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    SearchButton {
                        //TODO: Search Trips
                    }
                }
                
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .background(.white)
            .navigationTitle("Trip Journal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    TripTimelineView(viewModel: TripSequenceViewModel(tripSequenceProvider: PreviewViewTripTimelineUseCase()))
}
