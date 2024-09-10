//
//  DeleteButton.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-10.
//

import SwiftUI

struct DeleteButton: View {
    
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white)
                    .stroke(.red, lineWidth: 2)
                    .frame(width: 200, height: 40)
                
                HStack {
                    Image(systemName: "trash")
                        .font(.caption)
                    Text("Delete Trip")
                }
                .foregroundStyle(.red)

            }
        }
    }
}

#Preview {
    DeleteButton {
        //do nothing
    }
}
