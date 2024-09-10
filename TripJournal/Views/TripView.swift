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
        ScrollViewReader { reader in
            ScrollView{
                LazyVStack(alignment: .leading) {
                    CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageData: $trip.coverImageData, isEditing: $isEditing)
                        .id("Top")
                    
                    TripHeaderView(trip: viewModel.trip, isEditing: $isEditing)
                        .offset(y: -35)
                    ZStack {
                        DaySequenceView(days: viewModel.days)
                            .allowsHitTesting(!isEditing)
                            .padding(.horizontal, 40)
                        
                        Color.white
                            .opacity(isEditing ? 0.5 : 0)
                    }
                }
            }
            .onChange(of: isEditing, {
                withAnimation {
                    reader.scrollTo("Top", anchor: .top) // scroll to Top
                }
            })
            .scrollDisabled(isEditing)
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
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
    
    var editTripButton: some View {
        
        EditItemButton {
            withAnimation {
                isEditing = true
            }
        }
    }
    
    var saveChangesButton: some View {
        
        SaveButton {
            viewModel.save(trip: viewModel.trip)
            withAnimation{
                isEditing = false
            }
        }
    }
    
    var cancelEditButton: some View {
        
        CancelButton {
            //If trip was never saved, cancel returns user to timeline view
            if viewModel.trip.lastSaveDate == nil {
                router.path.removeLast()
            } else {
                
                viewModel.cancelEdit()
                
                withAnimation{
                    isEditing = false
                }
            }
        }
    }
    
    var deleteTripButton: some View {
        
        DeleteButton {
            viewModel.delete(trip: viewModel.trip)
            router.path.removeLast()
        }
    }
    
    var addDayButton: some View {
        
        AddItemButton {
            router.path.append(viewModel.newDay())
        }
    }
    
    var backButton: some View {
        
        BackButton {
            router.path.removeLast()
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
