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
    
    var body: some View {
        if isSelected {
            VStack(alignment: .leading) {
                
                HStack {
                    DatePicker("", selection: $content.displayTimestamp, displayedComponents: .hourAndMinute)
                        .fixedSize()
                        .labelsHidden()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 0)
 
                    Spacer()
                    
                    Button {
                        viewModel.delete(content: content)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                            .background(.white)
                            .clipShape(.circle)
                    }
                    .padding(.horizontal, 8)
                }
                
                
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
                
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text(content.displayTimestamp, style: .time)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 2)
                        .padding(.horizontal, 28)
                    
                }
                
                Text(content.text)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding(.bottom, 30)
                    .padding(.horizontal, 24)

            }
            .frame(maxWidth: .infinity)
            .padding(.top, 15)
        }
        
    }
}

#Preview {
    ContentTextView(viewModel: ContentViewModel(content: PreviewHelper.shared.mockTextContent(),
                                                contentChangeDelegate: PreviewHelper.shared),
                    isSelected: false)
}
