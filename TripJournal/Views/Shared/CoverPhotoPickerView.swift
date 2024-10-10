//
//  CoverPhotoPickerView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-06.
//

import SwiftUI
import PhotosUI

struct CoverPhotoPickerView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    var photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol
    var imageURL: URL
    @Binding var isEditing: Bool
    @State private var updatedImage: Image?
    
    init(selectedItem: PhotosPickerItem? = nil, photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol, imageURL: URL, isEditing: Binding<Bool>) {
        self.selectedItem = selectedItem
        self.photoDataUpdateDelegate = photoDataUpdateDelegate
        self.imageURL = imageURL
        _isEditing = isEditing
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {

            Color.clear
                .overlay (
                    Group {
                        if updatedImage != nil {
                            updatedImage?
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .opacity(isEditing ? 0.7 : 1)
                        } else {
                            
                            AsyncImage(url: imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .opacity(isEditing ? 0.7 : 1)
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
                    }
                )
                    .frame(height: 300)
                    .clipped()
                    .opacity(isEditing ? 0.7 : 1)

            if (isEditing) {
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
    }
    
    func coverImage(data: Data) -> Image? {
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
}

#Preview {
    struct Preview: View {
        
        @State private var isEditing = true
        @State private var imageData: Data? = nil
        
        var body: some View {
            Text("Broken Preview: Need to fix")
                .foregroundStyle(.red)
            /*
            CoverPhotoPickerView(photoDataUpdateDelegate: PreviewHelper.shared, imageURL: ImageHelperService.shared.imageURL(for: PreviewHelper.shared.mockDay()), isEditing: $isEditing)
             */
        }
    }
    
    return Preview()
}
