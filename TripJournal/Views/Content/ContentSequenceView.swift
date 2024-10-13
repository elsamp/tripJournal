//
//  ContentSequenceView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-11.
//

import SwiftUI

struct ContentSequenceView<ViewModel>: View where ViewModel: ContentSequenceViewModelProtocol {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.sortedContentItems) { content in
                ContentView(viewModel: content,
                            isSelected: viewModel.isSelected(content: content))
                .id(content.id)
                .onTapGesture {
                    print("tapped content view!")
                    withAnimation {
                        if !viewModel.isSelected(content: content) {
                            if viewModel.isAnySelected() {
                                viewModel.deselectAll()
                            } else {
                                viewModel.select(content: content)
                            }
                        }
                    }
                }
                
            }
            Spacer()
                .frame(height: 100)
        }
    }
}


#Preview {
    ContentSequenceView(viewModel: PreviewHelper.shared.mockContentSequence())
}
