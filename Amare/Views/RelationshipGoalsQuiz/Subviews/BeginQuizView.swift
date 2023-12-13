//
//  BeginQuizView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/28/23.
//

import SwiftUI

///This is the first view the user sees when they begin the relationship goals quiz, this introduces it and gives the user the option to dismiss it
struct BeginQuizView: View {
    var body: some View {
		
		VStack{
			
		
			
			Text("Unlock Your Relationship Potential")
				.font(.largeTitle).bold()
				.multilineTextAlignment(.center)
				.padding()
			
		
			
			Text("Let's play a game to find your perfect match!")
				.multilineTextAlignment(.center)
				.font(.subheadline)
				.padding()
			
		
		}
		
		
    }
}

struct BeginQuizView_Previews: PreviewProvider {
    static var previews: some View {
        BeginQuizView()
    }
}
