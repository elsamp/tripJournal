//
//  BackButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct BackButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button() {
            action()
        } label: {
            Image(systemName: "chevron.backward.circle.fill")
                .font(.title2)
                .foregroundStyle(.accentMain)
                .background(.white)
                .clipShape(.circle)
        }
    }
}

#Preview {
    BackButton {
        //do nothing
    }
}
