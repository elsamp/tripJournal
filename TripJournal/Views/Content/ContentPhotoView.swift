//
//  ContentPhotoView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

import PhotosUI

struct ContentPhotoView: View {
    
    var photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol
    var viewModel: ContentViewModelProtocol
    var isSelected: Bool
    @ObservedObject var content: ContentItem
    @State private var updatedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
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
    ContentPhotoView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockPhotoContent(), contentChangeDelegate: PreviewHelper.shared), photoDataUpdateDelegate: PreviewHelper.shared)
}
