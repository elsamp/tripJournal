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
            LazyVStack {
                TripDetailsView(trip: viewModel.trip, isEditing: $isEditing)
                CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageData: $trip.coverImageData, isEditing: $isEditing)
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
            } else {
                
                viewModel.cancelEdit()
                
                withAnimation{
                    isEditing = false
                }
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


struct TripDetailsView: View {

    @ObservedObject var trip: Trip
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            //Trip Title
            if isEditing {
                TextField("My Trip", text: $trip.title)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            } else {
                Text(trip.title)
                    .font(.title3)
                    .foregroundStyle(.black)
            }
            
            //Trip Start-End dates
            if isEditing {
                HStack {
                    DatePicker("Start Date", selection: $trip.startDate, displayedComponents: .date)
                        .labelsHidden()
                    Text("to")
                    DatePicker("End Date", selection: $trip.endDate, displayedComponents: .date)
                        .labelsHidden()
                }
            } else {
                Text(dateRange(for: trip))
                    .font(.subheadline)
                    .foregroundStyle(.black)
            }
        }
        .padding()
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
            if let data = day.coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal, count:3, spacing: 20)
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
