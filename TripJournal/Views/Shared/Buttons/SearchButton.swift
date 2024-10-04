//
//  SearchButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-04.
//

import SwiftUI

struct SearchButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
}

#Preview {
    SearchButton {}
}
