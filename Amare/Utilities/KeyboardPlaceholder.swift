//
//  KeyboardPlaceholder.swift
//  Amare
//
//  Created by Micheal Bingham on 11/4/23.
//

import SwiftUI

import SwiftUI

struct KeyboardPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 300) // Adjust the height based on the keyboard height you want to simulate
    }
}

struct KeyboardPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardPlaceholder()
    }
}


#Preview {
    KeyboardPlaceholder()
}
