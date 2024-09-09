//
//  ContentView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var content: Content
    
    @ViewBuilder
    var body: some View {
        switch content.type {
            case .photo:
                if let unwrappedPhotoData = Binding($content.photoData) {
                    ContentPhotoView(imageData: unwrappedPhotoData)
                    /*
                    AsyncImage(url: ImageHelperService.shared.imageURL(for: content)) { phase in
                        if let image = phase.image {
                            image // Displays the loaded image.
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red // Indicates an error.
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                        } else {
                            Color.blue // Acts as a placeholder.
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                        }
                    }
                     */
                }
            case .text:
                if let unwrappedText = Binding($content.text) {
                    ContentTextView(text: unwrappedText)
                }
        }
    }
}

struct ContentTextView: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .background(.textFieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
        }
        .padding(40)
        
    }
}

struct ContentPhotoView: View {
    
    @Binding var imageData: Data
    
    var body: some View {
        VStack {
            
            if let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()
            }
            //Add Picker Button
        }
        
    }
}

#Preview {
    struct PreviewHelperView: View {
        
        @State private var text = "This is some text"
        
        var body: some View {
            ContentTextView(text: $text)
        }
    }
    
    return PreviewHelperView()
}
