//
//  ContentPhotoView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

import PhotosUI

struct ContentPhotoView<ViewModel>: View where ViewModel: ContentViewModelProtocol {
    
    var photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol
    @ObservedObject var viewModel: ViewModel
    var isSelected: Bool
    @State private var updatedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    init(viewModel: ViewModel,
         isSelected: Bool = false,
         photoDataUpdateDelegate: PhotoDataUpdateDelegatProtocol) {
        
        self.viewModel = viewModel
        self.isSelected = isSelected
        self.photoDataUpdateDelegate = photoDataUpdateDelegate
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            
            //Background tint and border outline
            if isSelected {
                Rectangle()
                    .fill(.accentMain)
            }
            
            Group {
                
                if updatedImage != nil {
                    //picker image that hasn't been saved yet
                    updatedImage?
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .opacity(isSelected ? 0.7 : 1)
                } else {
                    //imaged loaded from documents having previously been saved
                    AsyncImage(url: ImageHelperService.shared.imageURLFor(tripId: viewModel.day.trip.id, dayId: viewModel.day.id, contentId: viewModel.id)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .opacity(isSelected ? 0.7 : 1)
                            } else if phase.error != nil {
                                ImageMissingView()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                            } else {
                                ImageLoadingView()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                            }
                    }
                }
                
                //overlay photo picker button
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


#Preview {
    ContentPhotoView(viewModel: PreviewHelper.shared.mockPhotoContent(),
                     isSelected: false,
                     photoDataUpdateDelegate: PreviewHelper.shared)
}
