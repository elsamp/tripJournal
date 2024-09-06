//
//  DayView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI

struct DayView: View {
    
    var viewModel: DayViewModelProtocol
    @State private var isEditing: Bool
    @StateObject var router = Router.shared
    @ObservedObject var day: Day
    
    init(viewModel: DayViewModelProtocol) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.day.hasUnsavedChanges)
        self.day = viewModel.day
    }
    
    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading) {
                DayDetailsView(day: viewModel.day, isEditing: $isEditing)
                CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageData: $day.coverImageData, isEditing: $isEditing)
                ContentSequenceView(contentSequence: viewModel.contentSequence)
            }
        }
        .navigationTitle(viewModel.day.title)
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            
            if !isEditing {
                ToolbarItem(placement: .primaryAction) {
                    editDayButton
                }
                /*
                ToolbarItem(placement: .bottomBar) {
                    addContentButton
                }
                 */
            } else {
                ToolbarItem(placement: .primaryAction) {
                    saveChangesButton
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    cancelEditButton
                }
                
                if viewModel.day.lastSaveDate != nil {
                    ToolbarItem(placement: .bottomBar) {
                        deleteTripButton
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .bottomBar)
    }
    
    var editDayButton: some View {
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
            viewModel.save(day: viewModel.day)
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
            if viewModel.day.lastSaveDate == nil {
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
            viewModel.delete(day: viewModel.day)
            router.path.removeLast()
        } label: {
            HStack {
                Image(systemName: "trash")
                Text("Delete Day")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
}

struct DayDetailsView: View {
    
    @ObservedObject var day: Day
    @Binding var isEditing: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if isEditing {
                TextField("Day:", text: $day.title)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                DatePicker("Date", selection: $day.date, displayedComponents: .date)
                    .labelsHidden()
                
            } else {
                Text(day.title)
                Text(dateFormatter.string(from: day.date))
            }
        }
    }
}


struct ContentSequenceView: View {
    
    let contentSequence: ContentSequence
    
    var body: some View {
        VStack {
            ForEach(contentSequence.sequence) { content in
                contentView(for: content)
            }
        }
    }
    
    @ViewBuilder func contentView(for content: Content) -> some View {
        switch content.type {
            case .photo:
            PhotoContentView(content: content)
            case .text:
            TextContentView(content: content)
        }
    }
}

struct TextContentView: View {
    
    var content: Content
    
    var body: some View {
        
        if let text = content.description {
            Text(text)
        }
    }
}

struct PhotoContentView: View {
    
    var content: Content
    
    var body: some View {
        
        if let filePath = content.filePath {
            Image(filePath)
        }
    }
}

#Preview {
    DayView(viewModel: DayViewModel(day: PreviewHelper.shared.mockDay()))
}
