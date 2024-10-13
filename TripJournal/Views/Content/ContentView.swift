//
//  ContentView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-07.
//

import SwiftUI

struct ContentView<ViewModel>: View where ViewModel: ContentViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    var isSelected: Bool
    @State private var isShowingDeleteConfirmation = false
    
    var deleteContentAlertMessage: String {
        return "Are you sure you want to delete this \(viewModel.type.rawValue)? This action cannot be undone."
    }
    
    var deleteContentConfirmation: String {
        return "Yes, delete this \(viewModel.type.rawValue)."
    }
    
    init(viewModel: ViewModel, isSelected: Bool) {
        self.viewModel = viewModel
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
                DatePicker("", selection: $viewModel.displayTimestamp, displayedComponents: .hourAndMinute)
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
            Text(viewModel.displayTimestamp, style: .time)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
                .padding(.horizontal, 28)
                .padding(.top, 15)
        }
    }
    
    @ViewBuilder var contentBody: some View {
        Group {
            switch viewModel.type {
            case .photo:
                ContentPhotoView(viewModel: viewModel,
                                 isSelected: isSelected,
                                 photoDataUpdateDelegate: viewModel)
                
            case .text:
                ContentTextView(viewModel: viewModel, isSelected: isSelected)
                    .onChange(of: isSelected) { oldValue, newValue in
                        if newValue == false {
                            viewModel.save()
                        }
                    }
            }
        }
    }
    
    func deleteContent() {
        viewModel.delete()
    }
    
}


#Preview {
    VStack {
        
        ContentView(viewModel: PreviewHelper.shared.mockTextContent(),
                    isSelected: false)
        
        ContentView(viewModel: PreviewHelper.shared.mockTextContent(),
                    isSelected: true)
        
        /*
        ContentTextView(viewModel: PreviewHelper.shared.mockTextContent(),
                        isSelected: true)
        
        ContentPhotoView(viewModel: PreviewHelper.shared.mockTextContent(),
                         isSelected: true,
                         photoDataUpdateDelegate: PreviewHelper.shared)
        
        ContentTextView(viewModel: PreviewHelper.shared.mockTextContent(),
                        isSelected: false)
        
        ContentTextView(viewModel: PreviewHelper.shared.mockTextContentWith(text: ""),
                        isSelected: false)
        
        ContentTextView(viewModel: PreviewHelper.shared.mockTextContentWith(text: "Sample Text"),
                        isSelected: false)
        
         */
    }
}
