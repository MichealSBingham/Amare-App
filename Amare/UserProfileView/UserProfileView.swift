//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/17/22.
//

import SwiftUI
//import VTabView
import UICircularProgressRing
import URLImage

var randomPlanet: Planet = Planet(name: .Sun, angle: 17.82, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Cancer, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)

class UserProfileDataModel: ObservableObject{
	
}

struct UserProfileView: View {
	
	@EnvironmentObject  var dataModel: UserDataModel
	
	@Environment(\.colorScheme) var colorScheme
	
    var body: some View {
		
		
			
			
			VStack{
				
				UserImageView(profile_image_url: dataModel.userData.profile_image_url)
					.padding()
				
				Text((dataModel.userData.winkedAtMe ?? false) ? "\(dataModel.userData.name ?? "") 😉 at you" : "")
					.fontWeight(.light)
				
				
				HStack{
					
					Text(dataModel.userData.name ?? "")
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
				
				BriefAstrologyProfileTabView(natalChart: dataModel.userData.natal_chart)
					
					
				
				TagsView()
					.padding(.vertical)
				
				ZStack{
					
					Image("branding/water")
						.resizable()
						.frame(width: UIScreen.main.bounds.width)
						.ignoresSafeArea()
					
					
					
					
					VStack{
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
				
					.frame(width: CGFloat(400), height: CGFloat(180))
				
				
			//VStack{
				
				//Spacer()
				
				
			HStack{
				Spacer()
				
				ProfileImageView(profile_image_url: .constant("https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80"), size: CGFloat(55))
					.padding()
					.offset(y: 55)
				
			}
					
			//}
				
			
				
		
			
			
			
				
			
				
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
	
	var natalChart: NatalChart? 
	
	var body: some View {
		
		TabView{
			
			HStack{
				
				var sun = natalChart?.planets.get(planet: .Sun) ?? randomPlanet
				SunSignView(planet: sun)
					.padding(.horizontal)
					.padding(.top, -10)
				Spacer()
			}
			
			
			HStack{
				var sun = natalChart?.planets.get(planet: .Sun) ?? randomPlanet
				PlanetView(planet: sun )
					.padding()
				
				var moon = natalChart?.planets.get(planet: .Moon) ?? randomPlanet
				PlanetView(planet: moon)
					.padding()
				
				//TODO: Change to the ascendant
				var rando = natalChart?.planets.get(planet: .Moon) ?? randomPlanet
				PlanetView(planet: rando)
					.padding()
			}
			
			HStack{
				
				var mercury = natalChart?.planets.get(planet: .Mercury) ?? randomPlanet
				var venus = natalChart?.planets.get(planet: .Venus) ?? randomPlanet
				var mars = natalChart?.planets.get(planet: .Mars) ?? randomPlanet
				 
				PlanetView(planet: mercury)
					.padding()
				PlanetView(planet: venus)
					.padding()
				PlanetView(planet: mars)
					.padding()
			}
			
			HStack{
				
				var jupiter = natalChart?.planets.get(planet: .Jupiter) ?? randomPlanet
				var saturn = natalChart?.planets.get(planet: .Saturn) ?? randomPlanet
				var uranus = natalChart?.planets.get(planet: .Uranus) ?? randomPlanet
				 
				PlanetView(planet: jupiter)
					.padding()
				PlanetView(planet: saturn)
					.padding()
				PlanetView(planet: uranus)
					.padding()
			}
			
			HStack{
				
				var neptune = natalChart?.planets.get(planet: .Neptune) ?? randomPlanet
				var pluto = natalChart?.planets.get(planet: .Pluto) ?? randomPlanet
				 
				PlanetView(planet: neptune)
					.padding()
				PlanetView(planet: pluto)
					.padding()
				
			}
				
				
		}
		.frame(width: .infinity, height: 55)
		.tabViewStyle(.page(indexDisplayMode: .never))
			
			
		
		
		
	}
}

struct PlanetView: View {
	
	var planet: Planet = Planet(name: .Mercury, angle: 17.82, element: .fire, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Leo, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)
	
	var body: some View {
		
		
		VStack{
			
			HStack{
				
				planet.name.image()
					//.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				planet.sign.image()
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				
		
			}
			
			Text("**\(planet.sign.rawValue)** \(planet.name.rawValue)")
		
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

/*
struct TagView_Previews: PreviewProvider{
	static var previews: some View{
		TagView(description: "Loves The Outdoors", color: .yellow)
	}
}
*/

struct SunSignView: View {
	
	var planet: Planet = Planet(name: .Sun, angle: 17.82, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: nil, longer_placement_interpretation: nil, sign: .Scorpio, house: 7, cusp: nil, speed: 7, forSynastry: false, _aspectThatExists: nil)
	
	var body: some View {
		
		HStack{
			
			Group{
				
				PlanetName.Sun.image()
					//.resizable()
					
					.scaledToFit()
					.frame(width: 25, height: 25)
				planet.sign.image()
					.resizable()
					
					.scaledToFit()
					.frame(width: 25, height: 25)
			}
			Text("\(planet.sign.rawValue)")
				.bold()
			Text("\(planet.angle.dm)")
				
			//Image("ZodiacIcons/water")
			planet.element.image()
				.resizable()
				.scaledToFit()
				.frame(width: 25, height: 25)
		}
		
	}
}

struct UserImageView: View {
	
	var profile_image_url: String?
	
	var body: some View {
		
		/*
		Image("branding/woman")
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 400, height: 250, alignment: .center)
			.clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
		*/
		
		
		  URLImage(URL(string: profile_image_url ?? "https://findamare.com")!) { progress in
			  
			  
			  Image(systemName: "person.circle.fill")
				  .resizable()
				  .aspectRatio(contentMode: .fill)
				  .frame(width: 400, height: 250, alignment: .center)
				  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			  /*
				   .scaleEffect(condition ? 0.9 : 1.0)
				   .animation(animation)
				   .onAppear {
					  
					   DispatchQueue.main.async {
						   
						   withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
							   condition = true
						   }
					   }
				   }
				   */
				   
			  
		  }
		  
	  failure: {  error,retry in
		  
		  //Image(systemName: "person.fill.questionmark")
		  Image(systemName: "person.circle.fill")
			  .resizable()
			  .foregroundColor(.white)
			  .aspectRatio(contentMode: .fill)
			  .frame(width: 400, height: 250, alignment: .center)
			  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			  
	  }
	  
	  
	  content: { image, info in
			  
		  
		  ZStack{
			  
			  
			  image
				  .resizable()
				  .aspectRatio(contentMode: .fill)
				  .frame(width: 400, height: 250, alignment: .center)
				  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			  
			  /*
			  Image(systemName: "person.circle.fill")
				  .resizable()
				  .aspectRatio(contentMode: .fit)
				  .clipShape(Circle())
				  // .frame(width: 100, height: 100)
				   .shadow(radius: 15)
				   .frame(width: size, height: size)
				   .redacted(reason: .placeholder)
			  */
				  
		  }
		  
	  }
	}
}


struct UserProfileView_Previews: PreviewProvider {
	
    static var previews: some View {
		UserProfileView()
            .environmentObject(UserDataModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}

/*
struct UserImageView_Previews: PreviewProvider {
	static var previews: some View {
		UserImageView()
	}
}

*/
