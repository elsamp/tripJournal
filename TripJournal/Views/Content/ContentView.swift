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
