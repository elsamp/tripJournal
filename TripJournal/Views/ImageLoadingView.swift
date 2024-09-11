//
//  ImageLoadingView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-09-11.
//

import SwiftUI

struct ImageLoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.accentMain)
                .opacity(0.5)
            //TODO: custom loading animation
            ProgressView()
        }
    }
}

#Preview {
    ImageLoadingView()
}
