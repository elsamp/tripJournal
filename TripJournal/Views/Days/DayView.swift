//
//  DayView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI
import PhotosUI

struct DayView<ViewModel: DayViewModelProtocol>: View {
        
    let topLocationKey = "Top"
    var photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol
    @ObservedObject var viewModel: ViewModel
    @State private var isEditing: Bool
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isShowingDeleteConfirmation = false
    @StateObject var router = Router.shared
    
    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                withAnimation {
                    viewModel.contentSequence.deselectAll()
                }
            }
    }
    
    init(viewModel: ViewModel, photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol) {
        self.viewModel = viewModel
        self.photoDataUpdateDelegate = photoDataUpdateDelegate
        _isEditing = State(initialValue: viewModel.hasUnsavedChanges)
        print(viewModel)
    }
    
    var body: some View {
        
        ScrollViewReader { reader in
            ScrollView{
                LazyVStack(alignment: .leading) {
                    CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageURL: ImageHelperService.shared.imageURLFor(tripId: viewModel.trip.id, dayId: viewModel.id), isEditing: $isEditing)
                        .id(topLocationKey)
                    DayHeaderView(day: viewModel, isEditing: $isEditing)
                        .offset(y: -35)
                    
                    ContentSequenceView(viewModel: viewModel.contentSequence)
                        .allowsHitTesting(!isEditing)
                        .opacity(isEditing ? 0.5 : 1)
                }
                .gesture(isEditing ? nil : tapGesture)
            }
            .onChange(of: isEditing, {
                withAnimation {
                    reader.scrollTo(topLocationKey, anchor: .top) // scroll to Top
                }
            })
            .onChange(of: viewModel.contentSequence.selectedItem, {
                if let id = viewModel.contentSequence.selectedItem?.id {
                    withAnimation {
                        reader.scrollTo(id, anchor: .center) // scroll to selected item
                    }
                }
            })
            .scrollDisabled(isEditing)
            .ignoresSafeArea(edges: .top)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                
                if !isEditing {
                    ToolbarItem(placement: .primaryAction) {
                        editDayButton
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        backButton
                    }
                    ToolbarItem(placement: .bottomBar) {
                        addContentButtons
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
                            deleteDayButton
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .alert("Are you sure you want to delete this Day? This action cannot be undone.", isPresented: $isShowingDeleteConfirmation) {
                
                Button("Yes, Delete Day", role: .destructive) {
                    deleteDay()
                }
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    //MARK: Button View Variables
    
    var editDayButton: some View {
        
        EditItemButton {
            withAnimation {
                viewModel.contentSequence.deselectAll()
                isEditing = true
            }
        }
    }
    
    var saveChangesButton: some View {
        
        SaveButton {
            viewModel.saveDay()
            withAnimation{
                isEditing = false
            }
        }
    }
    
    //TODO: Rethink Implementation and move to ContentSequenceView
    var saveContentChangesButton: some View {
        
        Button {
            viewModel.contentSequence.deselectAll()
        } label: {
            HStack {
                Image(systemName: "checkmark")
                    .font(.title2)
                    .foregroundStyle(.white)
                Text("Done")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.green)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
    
    var cancelEditButton: some View {
        
        CancelButton {
            //If day was never saved, cancel returns user to timeline view
            if viewModel.lastSaveDate == nil {
                router.path.removeLast()
            }
            
            //viewModel.cancelEdit()
            
            withAnimation{
                isEditing = false
            }
        }
    }
    
    var deleteDayButton: some View {
        
        DeleteButton(deleteItemType: "Day") {
            isShowingDeleteConfirmation = true
        }
    }
    
    var backButton: some View {
        
        BackButton {
            if viewModel.contentSequence.selectedItem != nil {
                //TODO: save selected content
                viewModel.contentSequence.deselectAll()
            }
            router.path.removeLast()
        }
    }
    
    var addContentButtons: some View {
        
        HStack(alignment: .center) {
            addTextContentButton
            addPhotoContentButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
    
    var addTextContentButton: some View {
        Button {
            viewModel.contentSequence.addNewTextContent()
            print("Adding Text Content")
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.accentMain)
                    .frame(height: 40)
                
                HStack{
                    Image(systemName: "note.text.badge.plus")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .offset(y: 2)
                    
                    Text("Add Text")
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 5)
        }
    }
    
    var addPhotoContentButton: some View {
        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.accentMain)
                    .frame(height: 40)
                
                HStack {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .offset(y: 2)
                    
                    Text("Add Photo")
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 5)
        }
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            Task {
                if let imageData = try await selectedPhotoItem?.loadTransferable(type: Data.self) {
                    
                    if let uiImage = UIImage(data: imageData), let pngData = uiImage.pngData() {
                        photoDataUpdateDelegate.imageDataUpdatedTo(pngData)
                        viewModel.contentSequence.addNewPhotoContent(with: pngData)
                    }
                }
            }
        }
    }
    
    //MARK: Functions
    
    func deleteDay() {
        viewModel.deleteDay()
        router.path.removeLast()
    }
}


#Preview {

    DayView(viewModel: PreviewHelper.shared.mockDay(), photoDataUpdateDelegate: PreviewHelper.shared)
}
