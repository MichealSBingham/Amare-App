//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/17/22.
//

import SwiftUI
import VTabView
import UICircularProgressRing

struct UserProfileView: View {
    var body: some View {
		
		
			
			
			VStack{
				
				UserImageView()
					.padding()
				
				Text("Diana 😉 at you")
					.fontWeight(.light)
				
				
				HStack{
					
					Text("Diana Hassell")
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding(.horizontal)
					Spacer()
					Text("mid 20s")
						.font(.title)
						.fontWeight(.light)
						.padding(.horizontal)
				}
				.padding(.top)
				
				BriefAstrologyProfileTabView()
					
					
				
				TagsView()
					.padding(.vertical)
				
				ZStack{
					
					Image("branding/water")
						.resizable()
						.frame(width: UIScreen.main.bounds.width)
						.ignoresSafeArea()
					
					
					
					
					VTabView{
						AboutThemView()
						AboutYouAndThemView()
					}.tabViewStyle(.page(indexDisplayMode: .always))
					
					
					
					
				
					
					
						
				}
			
				
				
				
				
				
				
				
			}
		
        
		
		
		
		

		
    }
}



struct AboutThemView: View {
	var body: some View {
		
		TabView{
			ProfileCard()
			ProfileCard()
			ProfileCard()
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
	}
}


struct AboutYouAndThemView: View {
	
	@State var synastryscore = RingProgress.percent(0)
	@State var chemistry = RingProgress.percent(0)
	@State var love = RingProgress.percent(0)
	@State var sex = RingProgress.percent(0)
	
	let o_ringstyle: RingStyle = .init(
		color: .color(.gray),
		strokeStyle: .init(lineWidth: 10)
	)
	
	var body: some View {
		
		TabView{
		
					ProgressRing(progress: $synastryscore, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "synastry")) { percent in
							   
							   
							   let pcent = Int(round(percent*100))
							   
							   VStack{
								   
									   
								   
								   Text("\(pcent)")
												   .font(.title)
												   .bold()
							   }
							   
							   
						   }
						   .animation(.easeInOut(duration: 5))
							   .frame(width: 150, height: 150)
							   //.offset(y: 35)
							   
							   .onAppear {
								   
								   AmareApp().delay(3) {
									   
									   withAnimation(.easeInOut(duration: 3)) {
										   synastryscore = RingProgress.percent(Double.random(in: 0...1))

									   }

								   }
							   }
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
	}
	
	
	func ringStyleFor(progress: String ) -> RingStyle {
		
		var color: Color = .green
		
		var number = 0.0
	
		switch progress {
		case "synastry":
			number = synastryscore.asDouble ?? 0
		case "chemistry":
			number = chemistry.asDouble ?? 0
		case "sex":
			number = sex.asDouble ?? 0
		case "love":
			number = love.asDouble ?? 0
		default:
			number = 0
		}
		
		 number = number*100
		
		if number <= 25.0 { color = .red }
		if number > 25.0 {color = .orange}
		if number >= 40.0  {color = .yellow}
		if number >= 60.0 { color = .green }
		if number >= 85.0 {color = .blue}
		
				
		
	   return  .init(
						color: .color(color),
						strokeStyle: .init(lineWidth: 5),
						padding: 2.5)
	}
}


struct ProfileCard: View {
	
	var text = "Ordinary life often seems drab and uninteresting to Diana and Diana must have something that stirs her imagination, some vision or ideal or dream to motivate her."
	var body: some View {
		
		
		
		ZStack{
			
			
			Text(text)
				.foregroundColor(.white)
				.padding()
				.frame(width: CGFloat(400), height: CGFloat(200))
				
			
				
		}
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: CGFloat(50)))
		.colorScheme(.dark)
		//.foregroundColor(Color.black.opacity(0.8))
		.foregroundStyle(.ultraThinMaterial)
		.cornerRadius(25)
		.padding()
		
		
	}
}

struct BriefAstrologyProfileTabView: View {
	
	var body: some View {
		
		TabView{
			
			HStack{
				SunSignView()
					.padding(.horizontal)
					.padding(.top, -10)
				Spacer()
			}
			
			
			HStack{
				PlanetView()
					.padding()
				PlanetView()
					.padding()
				PlanetView()
					.padding()
			}
			
			HStack{
				 
				PlanetView()
					.padding()
				PlanetView()
					.padding()
				PlanetView()
					.padding()
			}
				
				
		}
		.frame(width: .infinity, height: 55)
		.tabViewStyle(.page(indexDisplayMode: .never))
			
			
		
		
		
	}
}

struct PlanetView: View {
	var body: some View {
		
		
		VStack{
			
			HStack{
				
				Image("ZodiacIcons/Moon")
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				Image("ZodiacIcons/Cancer")
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				
		
			}
			
			Text("Cancer Moon")
		
		}
		
		
	}
}

struct TagsView: View {
	var body: some View {
		
		
		VStack{
			
			HStack{
				
				TagView(description: "Extrovert", color : .green)
				TagView(description: "Sensitive", color: .green)
				TagView(description: "Moderate", color: .green)
				TagView(description: "🍷", color: .green)
			}
			
			HStack{
				
				TagView(description: "Loves The Outdoors", color : .yellow)
				TagView(description: "Talks A Lot", color: .red)
				TagView(description: "Likes Cats", color: .green)
				
			}
		}
		
		
	}
}


struct TagView: View {
	
	var description: String = "Extrovert"
	var color: Color = .green
	
	var body: some View{
		Text(description)
			.fixedSize(horizontal: false, vertical: true)
			  .multilineTextAlignment(.center)
			  .padding(.horizontal)
			  .padding(.vertical, 3)
			.foregroundColor(.white)
			.background(
				Capsule()
					.fill(color)
					
					
			)
			
	}
}

struct TagView_Previews: PreviewProvider{
	static var previews: some View{
		TagView(description: "Loves The Outdoors", color: .yellow)
	}
}

struct SunSignView: View {
	var body: some View {
		
		HStack{
			
			Group{
				
				Image("ZodiacIcons/Sun")
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				Image("ZodiacIcons/Scorpio")
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
			}
			Text("Scorpio")
				.bold()
			Text("15’32°")
			Image("ZodiacIcons/water")
				.resizable()
				.scaledToFit()
				.frame(width: 25, height: 25)
		}
		
	}
}

struct UserImageView: View {
	
	var body: some View {
		
		Image("branding/woman")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 400, height: 250, alignment: .center)
			.clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
	}
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}


struct UserImageView_Previews: PreviewProvider {
	static var previews: some View {
		UserImageView()
	}
}

