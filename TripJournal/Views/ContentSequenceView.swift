//
//  ContentSequenceView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-11.
//

import SwiftUI

struct ContentSequenceView: View {
    
    var viewModel: DayViewModelProtocol
    @ObservedObject var contentSequence: ContentSequence
    
    init(viewModel: DayViewModelProtocol) {
        self.viewModel = viewModel
        self.contentSequence = viewModel.contentSequence
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(contentSequence.contentItems) { content in
                ContentView(viewModel: ContentViewModel(content: content,
                                                        contentChangeDelegate: viewModel),
                            isSelected: viewModel.isSelected(content: content),
                            content: content)
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
    ContentSequenceView(viewModel: DayViewModel(contentSequenceProvider: ViewContentSequenceExampleUseCase(), day: PreviewHelper.shared.mockDay()))
}
