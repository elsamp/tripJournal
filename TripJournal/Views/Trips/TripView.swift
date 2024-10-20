//
//  TripDetailsView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI

struct TripView<ViewModel>: View where ViewModel: TripViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    @State private var isEditing: Bool
    @StateObject var router = Router.shared
    @State private var isShowingDeleteConfirmation = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.hasUnsavedChanges)
        self.viewModel.viewTripDetails()
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView{
                LazyVStack(alignment: .leading) {
                    CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageURL: ImageHelperService.shared.imageURLFor(tripId: viewModel.id), isEditing: $isEditing)
                        .id("Top")
                    
                    TripHeaderView(trip: viewModel, isEditing: $isEditing)
                        .offset(y: -35)
                    ZStack {
                        DaySequenceView(viewModel: viewModel.daySequence)
                            .allowsHitTesting(!isEditing)
                            .padding(.horizontal, 40)
                        
                        Color.white
                            .opacity(isEditing ? 0.5 : 0)
                    }
                }
            }
            .onAppear() {
                viewModel.viewTripDetails()
            }
            .onChange(of: isEditing, {
                withAnimation {
                    reader.scrollTo("Top", anchor: .top) // scroll to Top
                }
            })
            .scrollDisabled(isEditing)
            .ignoresSafeArea(edges: .top)
            .navigationDestination(for: DayViewModel.self) { day in
                DayView(viewModel: day, photoDataUpdateDelegate: day)
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
                    
                    if viewModel.lastSaveDate != nil {
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
            viewModel.saveTrip()
            withAnimation{
                isEditing = false
            }
        }
    }
    
    var cancelEditButton: some View {
        
        CancelButton {
            //If trip was never saved, cancel returns user to timeline view
            if viewModel.lastSaveDate == nil {
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
            if let newDay = viewModel.daySequence.newDay() {
                print("presenting new day \(newDay) with id \(newDay.id)")
                router.path.append(newDay)
            }
        }
    }
    
    var backButton: some View {
        
        BackButton {
            router.path.removeLast()
        }
    }
    
    func deleteTrip() {
        viewModel.deleteTrip()
        router.path.removeLast()
    }
}


#Preview {
    NavigationStack {
        ZStack{
            TripView(viewModel: PreviewHelper.shared.mockTrip())
        }
    }
}
