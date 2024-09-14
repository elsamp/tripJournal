//
//  AddItemButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct AddItemButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                Text("Add Day")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(.accentMain)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
}

#Preview {
    AddItemButton {
        //do nothing
    }
}
