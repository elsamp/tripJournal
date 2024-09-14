//
//  SaveButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct SaveButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("Save")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(.accentMain)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    SaveButton {}
}
