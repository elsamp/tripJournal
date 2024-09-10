//
//  EditButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct EditItemButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "pencil.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
}

#Preview {
    EditItemButton {}
}
