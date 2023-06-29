//
//  TileView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/26/23.
//

import SwiftUI


/// Button that takes a 'Tile' shape form.
struct TileView: View {
	var icon: Image?
	var label: String = ""
	@Binding var isSelected: Bool
	var action: (() -> Void)? = nil
	
	
	

	var body: some View {
		
		
			
			VStack {
				icon?
					
					.resizable()
					.foregroundColor(.white)
					.aspectRatio(contentMode: .fit)
					.frame(width: 50, height: 50)
				Text(label)
					//.font(.body)
					.foregroundColor(.white)
			}
			.padding()
			.frame(width: 120, height: 120)
			.background(isSelected ? (Color(.amare)) : Color(.darkGray))
			.cornerRadius(10)
			.shadow(radius: isSelected ? 5 : 10)
			.scaleEffect(isSelected ? 0.95 : 1.0)
			//.animation(.easeIn(duration: 0.3))
			.onTapGesture {
				withAnimation(.easeIn(duration: 0.2)){
					isSelected.toggle()
				}
				
				(action ?? {})()
			}
		

		
		 
	}
}




struct TileView_Previews: PreviewProvider {
    static var previews: some View {
		ZStack{
			//Background()
			HStack{
				//TileView(icon: Image(systemName: "figure.dress.line.vertical.figure"), label: "Dating")

				
				TileView(icon: Image("Onboarding/dating"), label: "Dating", isSelected: .constant(true), action: {
						print("nothing")
				})
				
				TileView(icon: Image("Onboarding/friendship"), label: "Friendship", isSelected: .constant(false), action: {
						print("nothing")
				})
				
				TileView(icon: Image("Onboarding/self_discovery"), label: "Discovery", isSelected: .constant(false), action: {
						print("nothing")
				})
					
					
				//TileView(icon: Image(systemName: "figure.dress.line.vertical.figure"), label: "Dating")

			}
			
			
		}
			
		
		
    }
}
