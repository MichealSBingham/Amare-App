//
//  BeginQuizBodyView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/28/23.
//

import SwiftUI

struct BeginQuizBodyView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@Binding var disablePaging: Bool
	
	// Body Text
	@State var bodyText: String = ""
	@State var fadeIn: Bool = false
	
	
	// Code for the timer
	@State var startDate = Date.now
	@State var timeElapsed: Int = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State var showTimer = true
	
	var nextPage: (() -> Void)?
	
	
	// Body Text 
	let introText = "Take a moment to do this. Let's call them Blake."
	let body1 = "We'll guide you through a series of scenarios and reflections.\nYour responses will help us better understand your unique ideas and thoughts on relationships."
	
	let body2 = "This isn't a foolish compatibility quiz from E-Harmony.\n\nIt's a journey powered by *cutting-edge* **AI**, drawing from **over 500,000** *successful* relationships.\n\nIt's like having a team of relationship experts in your pocket, all working to find your perfect match."
	
	
	let body3 = "Remember there are no right or wrong answers.\nYour responses will be private unless you choose to share them.\nYou can skip this quiz and take it later if you perfer.\n\nReady to dive in?"
	
	@State var timerText: Int = 7
	
	
	var body: some View {
		VStack{
			
			
			Group{
				
				Text("Picture Your Ideal Partner")
					.font(.largeTitle).bold()
					.multilineTextAlignment(.center)
					.lineLimit(1)
					.minimumScaleFactor(0.1)
					.padding()
				
				
				
				
				
				Text(.init(bodyText))
					.multilineTextAlignment(.center)
					.font(.subheadline)
					.padding()
					.animation(.easeInOut, value: fadeIn)
					.onChange(of: bodyText) { newValue in
						fadeIn.toggle()
					}
					.onAppear{
						bodyText = introText
					}
					
				
				
				
				
				//TODO: This should be an actual stop watch instead
				Text("\(timerText)...")
					.opacity(showTimer ? 1: 0 )
					.onReceive(timer) { firedDate in
						
						// This is executed every second
						timeElapsed = Int(firedDate.timeIntervalSince(startDate))
						
						if timeElapsed == 7 {
							withAnimation(.easeInOut(duration: 1)) {
								bodyText = body1
							}
						
						timerText = 11
							
						}
						
						if timeElapsed == 17 {
							
							withAnimation(.easeInOut(duration: 1)) {
								bodyText = body2
							}
							
						timerText = 11
						}
						
						
						if timeElapsed == 27{
							
							withAnimation(.easeInOut(duration: 1)) {
								bodyText = body3
							}
							
						timerText = 11
							
							timer.upstream.connect().cancel()
							withAnimation {
								showTimer = false
							}
							
							disablePaging = false
							
						}
						
						
						timerText -= 1
					}
				
			}
			
			
			
			
			
			HStack{
				
				Button {
					nextPage?()
				} label: {
					
					Text("Begin the Journey")
						
				}
				.padding()
				
		
				
				Button {
					dismiss()
				} label: {
					Text("Skip for Now")
					
				}
				.padding()


			}
			
			
		}
	}
}
	
	struct BeginQuizBodyView_Previews: PreviewProvider {
		static var previews: some View {
			BeginQuizBodyView( disablePaging: .constant(true))
		}
	}
	

