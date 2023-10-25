//
//  BackButtonView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/21/23.
//

import SwiftUI



struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
               
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    BackButton()
        .frame(width: 25)
}
