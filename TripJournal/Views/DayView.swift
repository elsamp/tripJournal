//
//  DayView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-08-27.
//

import SwiftUI
import PhotosUI

struct DayView: View {
    
    var viewModel: DayViewModelProtocol
    @State private var isEditing: Bool
    @StateObject var router = Router.shared
    @ObservedObject var day: Day
    @ObservedObject var contentSequence: ContentSequence
    
    @State private var selectedItem: PhotosPickerItem?
    
    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                print("tapped scrollview")
                withAnimation {
                    viewModel.deselectAll()
                }
            }
    }
    
    init(viewModel: DayViewModelProtocol) {
        self.viewModel = viewModel
        _isEditing = State(initialValue: viewModel.day.hasUnsavedChanges)
        self.day = viewModel.day
        self.contentSequence = viewModel.contentSequence
    }
    
    var body: some View {
        
        ScrollViewReader { reader in
            ScrollView{
                LazyVStack(alignment: .leading) {
                    CoverPhotoPickerView(photoDataUpdateDelegate: viewModel, imageURL: ImageHelperService.shared.imageURL(for: day), isEditing: $isEditing)
                        .id("Top")
                    DayHeaderView(day: viewModel.day, isEditing: $isEditing)
                        .offset(y: -35)
                    
                    ContentSequenceView(viewModel: viewModel)
                        .allowsHitTesting(!isEditing)
                        .opacity(isEditing ? 0.5 : 1)
                }
                .gesture(isEditing ? nil : tapGesture)
            }
            .onChange(of: isEditing, {
                withAnimation {
                    reader.scrollTo("Top", anchor: .top) // scroll to Top
                }
            })
            .onChange(of: contentSequence.selectedItem, {
                
                if let id = contentSequence.selectedItem?.id {
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
                    if !viewModel.isAnySelected() {
                        ToolbarItem(placement: .bottomBar) {
                            addContentButtons
                        }
                    } else {
                        ToolbarItem(placement: .bottomBar) {
                            saveContentChangesButton
                        }
                    }
                } else {
                    ToolbarItem(placement: .primaryAction) {
                        saveChangesButton
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        cancelEditButton
                    }
                    if viewModel.day.lastSaveDate != nil {
                        ToolbarItem(placement: .bottomBar) {
                            deleteDayButton
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
    
    var editDayButton: some View {
        
        EditItemButton {
            withAnimation {
                viewModel.deselectAll()
                isEditing = true
            }
        }
    }
    
    var saveChangesButton: some View {
        
        SaveButton {
            viewModel.save(day: viewModel.day)
            withAnimation{
                isEditing = false
            }
        }
    }
    var saveContentChangesButton: some View {
        
        Button {
            viewModel.deselectAll()
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
            if viewModel.day.lastSaveDate == nil {
                router.path.removeLast()
            }
            
            withAnimation{
                isEditing = false
            }
        }
    }
    
    var deleteDayButton: some View {
        
        DeleteButton(deleteItemType: "Day") {
            viewModel.delete(day: viewModel.day)
            router.path.removeLast()
        }
    }
    
    var backButton: some View {
        
        BackButton {
            if contentSequence.selectedItem != nil {
                //TODO: save selected content
                viewModel.deselectAll()
            }
            router.path.removeLast()
        }
    }
    
    var addContentButtons: some View {
        
        HStack(alignment: .center) {
            
            Button {
                viewModel.addNewTextContent(for: viewModel.day)
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
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
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
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let imageData = try await selectedItem?.loadTransferable(type: Data.self) {
                        
                        if let uiImage = UIImage(data: imageData), let pngData = uiImage.pngData() {
                            viewModel.addNewPhotoContent(with: pngData, for: viewModel.day)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}

struct DayHeaderView: View {
    
    @ObservedObject var day: Day
    @Binding var isEditing: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            if isEditing {
                TextField("Day:", text: $day.title)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 10)
                
                DatePicker("Date", selection: $day.date, displayedComponents: .date)
                    .labelsHidden()
                
            } else {
                Text(day.title)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.textTitle)
                
                Text(dateFormatter.string(from: day.date))
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(.textSubheader)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
}


#Preview {
    DayView(viewModel: DayViewModel(contentSequenceProvider: ViewContentSequenceExampleUseCase(), day: PreviewHelper.shared.mockDay()))
}
