//
//  ContentTextView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

struct ContentTextView: View {
    
    var isSelected: Bool
    var viewModel: ContentViewModelProtocol
    @ObservedObject var content: ContentItem
    @FocusState private var focused: Bool?
    
    init(viewModel: ContentViewModelProtocol, isSelected: Bool = false) {
        self.viewModel = viewModel
        self.content = viewModel.content
        self.isSelected = isSelected
        print("content view init \(content.id), IsSelected \(isSelected)")
    }
    
    @ViewBuilder var body: some View {
        if isSelected {
            TextField("Today I ...", text: $content.text, axis: .vertical)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.textFieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(2)
                .background(.accentMain)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .focused($focused, equals: isSelected)
                .onAppear{
                    focused = isSelected
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
        } else {
            Text(content.text)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .padding(.bottom, 30)
                .padding(.horizontal, 24)
                .padding(.top, 15)
        }
        
    }
}

#Preview {
    ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                contentChangeDelegate: PreviewHelper.shared),
                    isSelected: false)
}
