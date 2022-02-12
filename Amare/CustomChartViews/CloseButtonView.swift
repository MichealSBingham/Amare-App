//
//  CloseButtonView.swift
//  Amare
//
//  Created by Micheal Bingham on 2/9/22.
//

import SwiftUI

struct CloseButtonView: View {
var body: some View {
    Image(systemName: "xmark")
        .font(.system(size: 50, weight: .bold))
        .foregroundColor(.white)
        .padding(.all, 5)
        .background(Color.black.opacity(0.6))
        .clipShape(Circle())
        .accessibility(label:Text("Close"))
        .accessibility(hint:Text("Tap to close the screen"))
        .accessibility(addTraits: .isButton)
        .accessibility(removeTraits: .isImage)
}
}

struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView()
    }
}
