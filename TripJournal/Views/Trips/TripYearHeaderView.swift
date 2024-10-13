//
//  TripYearHeaderView.swift
//  TripJournal
//
//  Created by Erica Sampson on 2024-10-04.
//

import SwiftUI

struct TripYearHeaderView: View {
    
    let year: Int
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(.gray)
                .frame(height: 1)
                .opacity(0.3)
            
            Text(verbatim: "\(year)")
                .font(.system(size: 30))
                .fontWeight(.ultraLight)
                .foregroundStyle(.textTitle)
                .padding(.bottom, 10)
            
            Rectangle()
                .fill(.gray)
                .frame(height: 1)
                .opacity(0.3)
        }
        .padding(.top, 20)
    }
}


#Preview {
    TripYearHeaderView(year: 2024)
}
