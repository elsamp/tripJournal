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
    @State private var isShowingDeleteConfirmation = false
    @ObservedObject var content: ContentItem
    
    var deleteContentAlertMessage: String {
        return "Are you sure you want to delete this \(content.type.rawValue)? This action cannot be undone."
    }
    
    var deleteContentConfirmation: String {
        return "Yes, delete this \(content.type.rawValue)."
    }
    
    init(viewModel: ContentViewModelProtocol, isSelected: Bool, content: ContentItem) {
        self.viewModel = viewModel
        self.content = viewModel.content
        self.isSelected = isSelected
    }
    

    var body: some View {
        
        VStack(alignment: .leading) {
            contentHeader
            contentBody
        }
        .alert(deleteContentAlertMessage, isPresented: $isShowingDeleteConfirmation) {
            Button(deleteContentConfirmation, role: .destructive) {
                deleteContent()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    @ViewBuilder var contentHeader: some View {
        if isSelected {
            HStack {
                DatePicker("", selection: $content.displayTimestamp, displayedComponents: .hourAndMinute)
                    .fixedSize()
                    .labelsHidden()
                    .padding(.horizontal, 18)
                    .padding(.vertical, 0)
                
                Spacer()
                
                Button {
                    isShowingDeleteConfirmation = true
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
    }
    
    @ViewBuilder var contentBody: some View {
        Group {
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
    
    func deleteContent() {
        viewModel.delete(content: content)
    }
    
}





#Preview {
    VStack {
        
        ContentView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                contentChangeDelegate: PreviewHelper.shared),
                    isSelected: false, content: PreviewHelper.shared.mockTextContent())
        
        ContentView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                contentChangeDelegate: PreviewHelper.shared),
                    isSelected: true, content: PreviewHelper.shared.mockTextContent())
        
        /*
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
        
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContentWith(text: ""),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: false)
        
        ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContentWith(text: "Sample Text"),
                                                    contentChangeDelegate: PreviewHelper.shared),
                        isSelected: false)
         */
    }
}
