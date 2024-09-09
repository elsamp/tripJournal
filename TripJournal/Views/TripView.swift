//
//  TripDetailsView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI

struct TripView: View {
    
    let viewModel: TripViewModelProtocol
    @State private var isEditing: Bool
    @StateObject var router = Router.shared
    @ObservedObject var trip: Trip
    
    init(viewModel: TripViewModelProtocol) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.trip.hasUnsavedChanges)
        self.trip = viewModel.trip
    }
    
    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading) {
                CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageData: $trip.coverImageData, isEditing: $isEditing)
                
                TripHeaderView(trip: viewModel.trip, isEditing: $isEditing)
                    .offset(y: -35)
                
                DaySequenceView(days: viewModel.days)
                    .allowsHitTesting(!isEditing)
                    .padding(.horizontal, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationDestination(for: Day.self) { day in
            DayView(viewModel: DayViewModel(day: day))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            if !isEditing {
                ToolbarItem(placement: .primaryAction) {
                    editTripButton
                }
                ToolbarItem(placement: .bottomBar) {
                    addDayButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            } else {
                ToolbarItem(placement: .primaryAction) {
                    saveChangesButton
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    cancelEditButton
                }
                
                if viewModel.trip.lastSaveDate != nil {
                    ToolbarItem(placement: .bottomBar) {
                        deleteTripButton
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .bottomBar)
    }
    
    var editTripButton: some View {
        Button {
            withAnimation {
                isEditing = true
            }
        } label: {
            Image(systemName: "pencil.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
    
    var saveChangesButton: some View {
        Button {
            viewModel.save(trip: viewModel.trip)
            withAnimation{
                isEditing = false
            }
        } label: {
            Text("Save")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(.accentMain)
                .clipShape(.capsule)
        }
    }
    
    var cancelEditButton: some View {
        Button {
            //If trip was never saved, cancel returns user to timeline view
            if viewModel.trip.lastSaveDate == nil {
                router.path.removeLast()
            } else {
                
                viewModel.cancelEdit()
                
                withAnimation{
                    isEditing = false
                }
            }
        } label: {
            Text("Cancel")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(.gray)
                .clipShape(.capsule)
        }
    }
    
    var deleteTripButton: some View {
        Button {
            viewModel.delete(trip: viewModel.trip)
            router.path.removeLast()
        } label: {
            HStack {
                Image(systemName: "trash")
                    .font(.caption)
                Text("Delete Trip")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.white)
        .foregroundStyle(.red)
        .clipShape(.capsule)
    }
    
    var addDayButton: some View {
        Button {
            router.path.append(viewModel.newDay())
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                Text("Add Day")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.accentMain)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
    
    var backButton: some View {
        Button() {
            router.path.removeLast()
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
}






struct DaySequenceView: View {
    
    let days: [Day]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(days) { day in
                NavigationLink(value: day) {
                    DaySequenceItemView(day: day)
                        .padding(.vertical, 8)
                }
            }
             
        }
    }
}


#Preview {
    NavigationStack {
        ZStack{
            TripView(viewModel: TripViewModel(daySequenceProvider: PreviewHelper.shared, trip: PreviewHelper.shared.mockTrip(), tripUpdateDelegate: nil))
        }
    }
}
