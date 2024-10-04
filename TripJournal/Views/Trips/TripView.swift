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
    @State private var isShowingDeleteConfirmation = false
    
    init(viewModel: TripViewModelProtocol) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.trip.hasUnsavedChanges)
        self.trip = viewModel.trip
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView{
                LazyVStack(alignment: .leading) {
                    CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageURL: ImageHelperService.shared.imageURL(for: trip), isEditing: $isEditing)
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
            .alert("Are you sure you want to delete this Trip? This action cannot be undone.", isPresented: $isShowingDeleteConfirmation) {
                
                Button("Yes, Delete Trip", role: .destructive) {
                    deleteTrip()
                }
                
                Button("Cancel", role: .cancel) { }
            }
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
        
        DeleteButton(deleteItemType: "Trip") {
            isShowingDeleteConfirmation = true
        }
    }
    
    var addDayButton: some View {
        
        AddItemButton(label: "Add Day") {
            router.path.append(viewModel.newDay())
        }
    }
    
    var backButton: some View {
        
        BackButton {
            router.path.removeLast()
        }
    }
    
    func deleteTrip() {
        viewModel.delete(trip: viewModel.trip)
        router.path.removeLast()
    }
}


#Preview {
    NavigationStack {
        ZStack{
            TripView(viewModel: TripViewModel(daySequenceProvider: PreviewHelper.shared, trip: PreviewHelper.shared.mockTrip(), tripUpdateDelegate: nil))
        }
    }
}
