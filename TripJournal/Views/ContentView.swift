//
//  ContentView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import SwiftUI

struct ContentView: View {
    var viewModel: ContentViewModelProtocol
    var isSelected: Bool
    @ObservedObject var content: ContentItem
    
    init(viewModel: ContentViewModelProtocol, isSelected: Bool, content: ContentItem) {
        self.viewModel = viewModel
        self.content = viewModel.content
        self.isSelected = isSelected
    }
    
    @ViewBuilder
    var body: some View {
        switch content.type {
            case .photo:
                ContentPhotoView(viewModel: viewModel,
                                 isSelected: isSelected,
                                 photoDataUpdateDelegate: viewModel)
                
            case .text:
                ContentTextView(viewModel: viewModel, isSelected: isSelected)
                .onChange(of: isSelected) { oldValue, newValue in
                    if newValue == false {
                        viewModel.save(content: content)
                    }
                }
                
        }
    }
}

struct ContentTextView: View {
    
    var viewModel: ContentViewModelProtocol
    @ObservedObject var content: ContentItem
    var isSelected = true
    @FocusState private var focused: Bool?
    
    init(viewModel: ContentViewModelProtocol, isSelected: Bool = false) {
        self.viewModel = viewModel
        self.content = viewModel.content
        self.isSelected = isSelected
        print("content view init \(content.id), IsSelected \(isSelected)")
    }
    
    var body: some View {
        if isSelected {
            VStack(alignment: .leading) {
                
                HStack {
                    DatePicker("", selection: $content.displayTimestamp, displayedComponents: .hourAndMinute)
                        .fixedSize()
                        .labelsHidden()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 0)
                    /*
                    Spacer()
                    Text("\(content.sequenceIndex)")*/
                    Spacer()
                    
                    Button {
                        viewModel.delete(content: content)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                            .background(.white)
                            .clipShape(.circle)
                    }
                    .padding(.horizontal, 8)
                }
                
                
                TextField("Today I ...", text: $content.text, axis: .vertical)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.textFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(2)
                    .background(.accentMain)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .focused($focused, equals: isSelected)
                    .onAppear{
                        focused = isSelected
                    }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text(content.displayTimestamp, style: .time)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 2)
                        .padding(.horizontal, 28)
                    /*
                    Spacer()
                    Text("\(content.sequenceIndex)")*/
                    
                }
                
                Text(content.text)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding(.bottom, 30)
                    .padding(.horizontal, 24)

            }
            .frame(maxWidth: .infinity)
            .padding(.top, 15)
        }
        
    }
}

import PhotosUI

struct ContentPhotoView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    var photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol
    var viewModel: ContentViewModelProtocol
    @ObservedObject var content: ContentItem
    var isSelected = true
    @State private var updatedImage: Image?
    
    init(viewModel: ContentViewModelProtocol, isSelected: Bool = false, photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol) {
        self.viewModel = viewModel
        self.content = viewModel.content
        self.isSelected = isSelected
        self.photoDataUpdateDelegate = photoDataUpdateDelegate
        
        print("content view init \(content.id), IsSelected \(isSelected)")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if isSelected {
                HStack {
                    DatePicker("", selection: $content.displayTimestamp, displayedComponents: .hourAndMinute)
                        .fixedSize()
                        .labelsHidden()
                        .padding(.horizontal, 18)
                        .padding(.vertical, 0)
                    
                    Spacer()
                    
                    Button {
                        viewModel.delete(content: content)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                            .background(.white)
                            .clipShape(.circle)
                    }
                    .padding(.horizontal, 8)
                }
            } else {
                Text(content.displayTimestamp, style: .time)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 2)
                    .padding(.horizontal, 28)
                    .padding(.top, 15)
            }
            
            ZStack(alignment: .center) {
                
                if isSelected {
                    Rectangle()
                        .fill(.accentMain)
                }
                
                Group {
                    if updatedImage != nil {
                        updatedImage?
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .opacity(isSelected ? 0.7 : 1)
                    } else {
                        AsyncImage(url: ImageHelperService.shared.imageURL(for: content)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .opacity(isSelected ? 0.7 : 1)
                                } else if phase.error != nil {
                                    ImageMissingView() // Indicates an error.
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                } else {
                                    ImageLoadingView() // Acts as a placeholder.
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                }
                        }
                    }
                    
                    if (isSelected) {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Image(systemName: "photo.badge.plus.fill")
                                .font(.system(size: 60))
                                .padding(5)
                                .foregroundColor(.white)
                            
                        }
                        .onChange(of: selectedItem) { oldValue, newValue in
                            Task {
                                if let imageData = try await selectedItem?.loadTransferable(type: Data.self) {
                                    
                                    if let uiImage = UIImage(data: imageData), let pngData = uiImage.pngData() {
                                        photoDataUpdateDelegate.imageDataUpdatedTo(pngData)
                                        updatedImage = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(isSelected ? 2 : 0)
            }
        }
        
    }
}

#Preview {
    VStack {
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: true)
        
        ContentPhotoView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                     contentChangeDelegate: PreviewHelper.shared),
                         isSelected: true,
                         photoDataUpdateDelegate: PreviewHelper.shared)
        
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: false)
        /*
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContentWith(text: ""),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: false)
        
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContentWith(text: "Sample Text"),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: false)
         */
    }
}
