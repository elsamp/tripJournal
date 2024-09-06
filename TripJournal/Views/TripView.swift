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
    
    init(viewModel: TripViewModelProtocol) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.trip.hasUnsavedChanges)
    }
    
    var body: some View {
        ScrollView{
            LazyVStack {
                if isEditing {
                    TripSummaryEditView(trip: viewModel.trip)
                    CoverPhotoPickerView(viewModel: viewModel)
                } else {
                    TripSummaryView(trip: viewModel.trip)
                    if let data = viewModel.coverImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
                DaySequenceView(days: viewModel.days)
                    .allowsHitTesting(!isEditing)
            }
        }
        .navigationDestination(for: Day.self) { day in
            DayView(viewModel: DayViewModel(day: day))
        }
        .navigationTitle(viewModel.trip.title)
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            
            if !isEditing {
                ToolbarItem(placement: .primaryAction) {
                    editTripButton
                }
                ToolbarItem(placement: .bottomBar) {
                    addDayButton
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
            Text("Edit")
        }
    }
    
    var saveChangesButton: some View {
        Button {
            //save Image to Documents Folder
           
            //persist data
            viewModel.save(trip: viewModel.trip)
            withAnimation{
                isEditing = false
            }
        } label: {
            Text("Save")
        }
    }
    
    var cancelEditButton: some View {
        Button {
            //If trip was never saved, cancel returns user to timeline view
            if viewModel.trip.lastSaveDate == nil {
                router.path.removeLast()
            }
            
            withAnimation{
                isEditing = false
            }
        } label: {
            Text("Cancel")
        }
    }
    
    var deleteTripButton: some View {
        Button {
            viewModel.delete(trip: viewModel.trip)
            router.path.removeLast()
        } label: {
            HStack {
                Image(systemName: "trash")
                Text("Delete Trip")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
    
    var addDayButton: some View {
        Button {
            router.path.append(viewModel.newDay())
        } label: {
            HStack {
                Text("New Day")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.black)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
}


struct TripSummaryEditView: View {
    
    @ObservedObject var trip: Trip
    
    var body: some View {
        VStack {
            TextField("My Trip", text: $trip.title)
                .font(.title3)
                .foregroundStyle(.black)
                .padding(8)
                .background(.textFieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            HStack {
                DatePicker("Start Date", selection: $trip.startDate, displayedComponents: .date)
                    .labelsHidden()
                Text("to")
                DatePicker("End Date", selection: $trip.endDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
        .padding()
    }
}

import PhotosUI

struct CoverPhotoPickerView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var coverImage: Image?
    var viewModel: TripViewModelProtocol
    
    init(viewModel: TripViewModelProtocol) {
        self.selectedItem = nil
        self.viewModel = viewModel
        
        if let data = viewModel.coverImageData {
            self.coverImage = coverImage(data:data)
        }
    }
    
    var body: some View {
        
        VStack {
            coverImage?
                .resizable()
                .scaledToFit()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Select Cover Photo")
                    .padding()
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let imageData = try await selectedItem?.loadTransferable(type: Data.self) {
                        
                        if let uiImage = UIImage(data: imageData), let pngData = uiImage.pngData() {
                            viewModel.updateCoverImage(data: pngData)
                            coverImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }
    }
    
    func coverImage(data: Data) -> Image? {
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
}

struct DaySequenceView: View {
    
    let days: [Day]
    
    var body: some View {
        VStack {
            
            ForEach(days) { day in
                NavigationLink(value: day) {
                    DaySequenceItemView(day: day)
                }
            }
             
        }
    }
}

struct DaySequenceItemView: View {
    
    @ObservedObject var day: Day
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(day.title)
                Text(dateFormatter.string(from: day.date))
            }
            .padding(.vertical)
            Spacer()
            if let photoPath = day.coverPhotoPath {
                Image(photoPath)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal, count:3, spacing: 20)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ZStack{
            TripView(viewModel: TripViewModel(trip: PreviewHelper.shared.mockTrip(), tripUpdateDelegate: nil))
        }
    }
}
