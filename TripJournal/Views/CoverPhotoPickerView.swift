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
    @Binding var imageData: Data?
    @Binding var isEditing: Bool
    
    init(selectedItem: PhotosPickerItem? = nil, photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol, imageData: Binding<Data?>, isEditing: Binding<Bool>) {
        self.selectedItem = selectedItem
        self.photoDataUpdateDelegate = photoDataUpdateDelegate
        _imageData = imageData
        _isEditing = isEditing
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {

            if let imageData = imageData, let image = coverImage(data: imageData) {
                Color.clear
                    .overlay (
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                    )
                    .frame(height: 300)
                    .clipped()
                    .opacity(isEditing ? 0.7 : 1)
            } else {
                Color.gray // Acts as a placeholder.
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
            }
            
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
            CoverPhotoPickerView(photoDataUpdateDelegate: PreviewHelper.shared, imageData: $imageData, isEditing: $isEditing)
        }
    }
    
    return Preview()
}
