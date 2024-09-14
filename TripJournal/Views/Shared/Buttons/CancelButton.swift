//
//  CancelButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct CancelButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("Cancel")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(.gray)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    CancelButton { }
}
