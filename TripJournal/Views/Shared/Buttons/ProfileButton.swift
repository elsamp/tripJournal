//
//  ProfileButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-04.
//

import SwiftUI

struct ProfileButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
}

#Preview {
    ProfileButton {}
}
