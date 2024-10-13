//
//  ContentTextView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-14.
//

import SwiftUI

struct ContentTextView<ViewModel>: View where ViewModel: ContentViewModelProtocol {
    
    var isSelected: Bool
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focused: Bool?
    
    init(viewModel: ViewModel, isSelected: Bool = false) {
        self.viewModel = viewModel
        self.isSelected = isSelected
    }
    
    @ViewBuilder var body: some View {
        if isSelected {
            TextField("Today I ...", text: $viewModel.text, axis: .vertical)
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
            Text(viewModel.text)
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
    
    ContentTextView(viewModel: PreviewHelper.shared.mockTextContent(),
                    isSelected: false)
     
}
