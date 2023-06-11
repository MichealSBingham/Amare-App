//
//  UsernameInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/9/23.
//

import SwiftUI

struct UsernameInputView: View {
    var body: some View {
        
        VStack{
            
            Text("Enter a unique username")
                .font(.largeTitle)
            
        }
        .navigationBarHidden(true)
        
    }
}

struct UsernameInputView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            UsernameInputView()
        }
       
    }
}
