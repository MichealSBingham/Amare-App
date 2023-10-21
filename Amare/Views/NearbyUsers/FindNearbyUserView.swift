//
//  FindNearbyUser.swift
//  Amare
//
//  Created by Micheal Bingham on 5/20/22.
//

import SwiftUI
import NearbyInteraction
//import MultipeerKit




struct FindNearbyUserView: View {
	
	/*@Binding*/ var user: AppUser /// was @Binding
	
	@ObservedObject var dataModel: NearbyInteractionHelper //= NearbyInteractionHelper()
	
	@State var textToDisplay: String = "Waiting on their response... "
	
	@State var errorMessage: String = ""
	@State var errorDetected: Bool = false
	
	/// If during blind date mode, we can set this to nil
	@State var otherUsersProfileImage: String? // Reveal this when user reaches other user physically nearby
	
	/// Whether or not this is a `blindDate`/`blindMatch` mode or not
	var blindMode: Bool
	
	// This is so that we can animate the text color change when the background color changes so it can be a better color
	@State var triggerTextColorChange: Color = .gray
	
	@State var triggerBackgroundColorChange: UIColor = #colorLiteral(red: 0.1140513036, green: 0.1181834653, blue: 0.1686092259, alpha: 1)
	
	@State var pulsingAnimationSpeed: SpeedOfAnimation = .normal
	
	@State var moveToUpperRightCorner: Bool = false
	
	@State var metUser: Bool = false
	let grayColor = #colorLiteral(red: 0.1652105868, green: 0.1652105868, blue: 0.1652105868, alpha: 1)

	let defaultColor = #colorLiteral(red: 0.1140513036, green: 0.1181834653, blue: 0.1686092259, alpha: 1)
	
    var body: some View {
		
	
			
			ZStack{
				
				Background(style: .fast)
					.opacity(dataModel.isThere ? 1: 0)
					.animation(.easeInOut, value: dataModel.isThere)
				//MARK: - Loading Screen for Connecting
				VStack{
					
					Spacer()
					
					ZStack{
						
						PulsingView()
							.offset(x: moveToUpperRightCorner ? CGFloat(UIScreen.main.bounds.size.width/2) + CGFloat(70)  : CGFloat(0), y: moveToUpperRightCorner ? CGFloat(-425) - CGFloat(UIScreen.main.bounds.size.width/2)   : CGFloat(0))
							.scaleEffect(moveToUpperRightCorner ? 0.5: 1)
						
						centerImage(connected: $dataModel.connected, profile_image_url: $otherUsersProfileImage, animationSpeed: $pulsingAnimationSpeed)
							.offset(x: moveToUpperRightCorner ? CGFloat(UIScreen.main.bounds.size.width/2) + CGFloat(70)  : CGFloat(0), y: moveToUpperRightCorner ? CGFloat(-425) - CGFloat(UIScreen.main.bounds.size.width/2)   : CGFloat(0))
							.scaleEffect(moveToUpperRightCorner ? 0.5: 1)
							.brightness(!metUser ? 0: 1)
							.alert(isPresented: $errorDetected) {
							Alert(title: Text("Error"), message: Text(errorMessage))
									
						}
							.onAppear {
								//TODO: - Check if blind date mode
								if !blindMode{
									// immediately reveal profile image if it isn't blind mode
									otherUsersProfileImage = user.profileImageUrl
								}
								
							}
							.onChange(of: dataModel.distanceState) { state in
								
								print("Distance state is ... \(state) ")
								withAnimation {
									
									if let state = state {
										
										switch state{
										
										case .farAway:
											print("Setting slow")
											pulsingAnimationSpeed = .slow
										case .halfwayThere:
											print("Setting halfway")
											pulsingAnimationSpeed = .medium
										case .almostThere:
											print("Setting fast")
											pulsingAnimationSpeed = .fast
										
										}
										
									} else {
										print("Setting normal")
										pulsingAnimationSpeed = .normal
									}
								}
								
							}
							.onChange(of: dataModel.direction) { direction  in
								if direction != nil  {
									
									withAnimation {
										moveToUpperRightCorner = true
									}
								} else {
									
									withAnimation {
										moveToUpperRightCorner = false
									}
								}
							}
						
					}
					
					
					
					Spacer()
					
					
					
			

					
					var distance = dataModel.trueDistance ?? Float(0)
					var distanceRounded = round(distance*10)/10.0
					
					var waitingForThemText = AttributedString(stringLiteral: "Waiting for them...")
					
					
					//Text("Waiting for them...")
					Text(dataModel.connected ?
						 distanceAwayStringToAttributedText(string: "\(distanceRounded) m") :
					waitingForThemText)
				//Text(distanceAwayStringToAttributedText(string: "10 m"))
						.font(.largeTitle)
						.bold()
						.foregroundColor(triggerTextColorChange)
						.frame(maxWidth: .infinity, alignment: dataModel.connected ?  .leading : .center)
						//.animation(.easeOut)
						.padding()
						.colorMultiply(.white)
						.onChange(of: dataModel.connected) { connected in
							if !connected{ withAnimation {
								triggerBackgroundColorChange = defaultColor
								moveToUpperRightCorner = false
							}}
						}
						.onChange(of: dataModel.isMovingTowards) { isMovingTowards in
							if isMovingTowards == nil {
								
								withAnimation {
									triggerTextColorChange = .gray
									triggerBackgroundColorChange = defaultColor
								}
								
							} else {
								withAnimation {
									triggerTextColorChange = .white
									
									
									if isMovingTowards! {
										
										if let isFacing = dataModel.isFacing {
											
											triggerBackgroundColorChange = isFacing ? .green : defaultColor
										} else {
											triggerBackgroundColorChange = defaultColor
										}
										
										
										/*
										if let angle = dataModel.direction{
											
											if dataModel.isFacing ?? false  {
												triggerBackgroundColorChange = .green
											} else {
												
												triggerBackgroundColorChange = defaultColor
											}
											
										} else {
											triggerBackgroundColorChange = defaultColor
										}
										
										*/
										
									} else{
										//  moving away 
										
										if let angle = dataModel.direction{
											// moving away, have direction
											triggerBackgroundColorChange = defaultColor
										} else {
											// moving away, no direction
											triggerBackgroundColorChange = .red
										}
									}
									
									
								}
							}
						}
					
						
					
					
					Text(!dataModel.connected ?
						 AttributedString("We're waiting for them to connect so keep breathing. You got this.") :
							navigationInstructionAttributedText(angle: dataModel.direction, isMovingTowards: dataModel.isMovingTowards, isFacing: dataModel.isFacing))
						.colorMultiply(.white)
						.font(.subheadline)
						.foregroundColor(triggerTextColorChange)
						.multilineTextAlignment(.center)
						.frame(maxWidth: .infinity, alignment: dataModel.connected ?  .leading : .center)
						.padding()
						.onChange(of: triggerBackgroundColorChange) { background in
							if background == defaultColor{
								withAnimation {
									triggerTextColorChange = .white
								}
								
							}
						}
					
				 
					
				}
				
				Image(systemName: "arrow.up")
					.resizable()
					.frame(width: 150, height: 200)
					.foregroundColor(.white)
					.aspectRatio(contentMode: .fit)
					.rotationEffect(.radians(Double(dataModel.direction ?? 0 )))
					.opacity(dataModel.direction != nil && dataModel.connected && !dataModel.isThere ? 1: 0)
					.animation(.easeIn, value: dataModel.direction)
					.onChange(of: dataModel.isThere) { reachedOtherUser in
						
						if reachedOtherUser {
							// made it to the other user
							withAnimation{
								
								triggerBackgroundColorChange = .green
								moveToUpperRightCorner = false
								
								// End the nearby stuff
								//showProfile = true
								metUser = true
								dataModel.stopListeningForPeerToken()
								
								
							}
						}
					}
				
				
				
		
				
			}
		
			.brightness(!metUser ? 0: -0.5)
			.navigationTitle(Text(dataModel.connected ? "\(user.name ?? "")" : "DateDar®"))
			.preferredColorScheme(.dark)
			.foregroundColor(.gray)
			.background( Color(triggerBackgroundColorChange) )
		
		
		.onAppear {
			
			// Make sure both devices can even do nearby interaction
			
		
				
        //TODO: Fix this because we  have user.supportsNearbyInteraction property
			
			guard NISession.isSupported && true ?? false else {
				
				if !NISession.isSupported { dataModel.someErrorHappened = NIError(.unsupportedPlatform) } else {
					
					dataModel.someErrorHappened = NearbyUserError.theirDeviceIsntSupported
				}
				
				return
			}
			
			/*
			guard dataModel.properOrientation else {
				
				return
			}
			*/

			
			dataModel.sendToken(them: user.id!)
			
		}
		.onDisappear {
			dataModel.stopListeningForPeerToken()
		}
		
		
		.onChange(of: dataModel.didAnErrorHappen) { errorHappened in
			
			if errorHappened{
				
				if let error = dataModel.someErrorHappened as? NIError {
					switch error.code{
						
					case .unsupportedPlatform:
						errorDetected = true
						errorMessage = "Sorry, your device does not support this feature."
					case .invalidConfiguration:
						errorDetected = true
						errorMessage = "Something went wrong."
					case .sessionFailed:
						errorDetected = true
						errorMessage = "Something failed. Try again."
					case .resourceUsageTimeout:
						errorDetected = true
						errorMessage = "Timeout. "
					case .activeSessionsLimitExceeded:
						errorDetected = true
						errorMessage = "Too many devices."
					case .userDidNotAllow:
						errorDetected = true
						errorMessage = "You will need to allow access to this."
					@unknown default:
						errorDetected = true
						errorMessage = "Not sure what happened."
					}
				}
				
				if let error = dataModel.someErrorHappened as? NearbyUserError {
					
					switch error {
					case .cantDecodeTheirDiscoveryToken:
						errorDetected = true
						errorMessage = "Not able to decode their discovery token."
					case .cantDecodeMyDiscoveryToken:
						errorDetected = true
						errorMessage = "You don't have a token."
					case .timeout:
						errorDetected = true
						errorMessage = "Timeout."
					case .outOfRange:
						errorDetected = true
						errorMessage = "Out of range, please come closer."
					case .noDiscoveryToken:
						errorDetected = true
						errorMessage = "We don't have their discovery token."
					case .theirDeviceIsntSupported:
						errorDetected = true
						errorMessage = "Sorry, their device doesn't support this feature."
					case .disconnected:
						errorDetected = true
						errorMessage = "Devices disconnected, try reconnecting."
					case .wrongOrientation:
						errorDetected = true
						errorMessage = "Please hold your phone right side up."
					}
				}
			} else {
				errorDetected = false
			}
		}
		
		
		
		
		
		
		
        
		
		
	 
    }
	
	
	func distanceAwayStringToAttributedText(string: String) -> AttributedString {
		
		// s
		//var distanceString = "\(dataModel.distanceAway ?? .constant(Float(0))) m"
		
		var stringWithJustNumbers = string.replacingOccurrences(of: " m", with: "")
		
		//var rangeOfNumbers = (string as NSString).range(of: stringWithJustNumbers)
		
		var distanceAttributedString = AttributedString(string)
		
		
		let rangeOfJustNumbers = distanceAttributedString.range(of: stringWithJustNumbers)!
		
		distanceAttributedString[rangeOfJustNumbers].foregroundColor = .white
		
		//if dataModel.isMovingTowards != nil { distanceAttributedString.foregroundColor = .white}
		
		return distanceAttributedString
	}
	
	
	
	/// Returns navigation instructions to the user based on if we're facing them or moving away/towards etc. Returns an attributedstring
	/// - Parameters:
	///   - angle: The direction the other use is relative to us. Will be nil if we are out of their field of view so we don't know the angle.
	///   - isMovingTowards: Whether or not the distance to the user is increasing or decreasing , will be nil if we haven't moved yet because we just connected
	///   - isFacing: Whether or not we're facing the user in field of view
	/// - Returns: The attributed string of the navigation instruction
	func navigationInstructionAttributedText(angle: Float?, isMovingTowards: Bool?, isFacing: Bool? ) -> AttributedString {
		
		var isMovingAway: Bool? = nil
		
		if let isMovingTowards = isMovingTowards {
			isMovingAway = !isMovingTowards
		}

	
	
	
		
		
		if let angle = angle{
			// We have the direction
			
			if let isFacing = isFacing {
				
				if isFacing{
					
					guard isMovingAway != nil else { // Facing and going towards
						var instruction = try! AttributedString(markdown: "Go **straight ahead**.")
					 let rangeOfDirection = instruction.range(of: "straight ahead")!
					 instruction.font = .largeTitle
					 instruction[rangeOfDirection].foregroundColor = .white
					 //if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
					 return instruction }
					
					if isMovingAway ?? true {
						var instruction = try! AttributedString(markdown: "No. Go **straight ahead**.")
						let rangeOfDirection = instruction.range(of: "straight ahead")!
						instruction.font = .largeTitle
						instruction[rangeOfDirection].foregroundColor = .white
					//	if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
						return instruction
					}
					
					// Facing and going towards
					var instruction = try! AttributedString(markdown: "Go **straight ahead**.")
					let rangeOfDirection = instruction.range(of: "straight ahead")!
					instruction.font = .largeTitle
					instruction[rangeOfDirection].foregroundColor = .white
					//if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
					return instruction
					
				}
				
				
				// We're not facing so see if we're left or right
				
				if angle > 0 {
					
					var instruction = try! AttributedString(markdown: "To your **right**.")
					let rangeOfDirection = instruction.range(of: "right")!
					instruction.font = .largeTitle
					instruction[rangeOfDirection].foregroundColor = .white
					return instruction
				}
				
				var instruction = try! AttributedString(markdown: "To your **left**.")
				let rangeOfDirection = instruction.range(of: "left")!
				instruction.font = .largeTitle
				instruction[rangeOfDirection].foregroundColor = .white
			//	if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
				return instruction
			}
			
			else {
				// We're not sure if we're facing ...
				
				// See if go left or right
				
				if angle > 0 {
					
					var instruction = try! AttributedString(markdown: "To your **right**.")
					let rangeOfDirection = instruction.range(of: "right")!
					instruction.font = .largeTitle
					instruction[rangeOfDirection].foregroundColor = .white
				//	if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
					return instruction
				}
				
				var instruction = try! AttributedString(markdown: "To your **left**.")
				let rangeOfDirection = instruction.range(of: "left")!
				instruction.font = .largeTitle
				instruction[rangeOfDirection].foregroundColor = .white
			//	if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
				return instruction
				
			}
		} else {
			
			// We're not in the field of view so we don't have direction so only rely on distance away
			if let isMovingAway = isMovingAway {
				// We know if we're moving away or not
				
				if isMovingAway{
					
					
					
					var instruction = try! AttributedString(markdown: "You're **moving away**.")
					let rangeOfDirection = instruction.range(of: "moving away")!
					instruction.font = .largeTitle
					instruction[rangeOfDirection].foregroundColor = .white
					return instruction
					
				}
				
				// Moving towards
				
				
				
				var instruction = try! AttributedString(markdown: "Keep **moving closer**.")
				let rangeOfDirection = instruction.range(of: "moving closer")!
				instruction.font = .largeTitle
				instruction[rangeOfDirection].foregroundColor = .white
				return instruction
				
			}
			
			
			
			// We don't know so just tell user to keep walking
			
			
			var instruction = try! AttributedString(markdown: "Start **moving around**.")
			let rangeOfDirection = instruction.range(of: "moving around")!
			instruction.font = .largeTitle
			instruction[rangeOfDirection].foregroundColor = .white
		//	if dataModel.isMovingTowards != nil { instruction.foregroundColor = .white}
			return instruction
		}
		
		
	}
}


enum SpeedOfAnimation {
	case slow, normal, medium, fast
}









struct FindNearbyUserView_Previews: PreviewProvider {
	
	 
	
	
    static var previews: some View {
		
		var helper = NearbyInteractionHelper()
		
        let example = AppUser.generateMockData()//AmareUser(id: "3432", name: "Micheal")
        FindNearbyUserView(user: AppUser.generateMockData(), dataModel: helper, blindMode: false).onAppear {
			helper.connected = true
			helper.isFacing = true
			helper.direction = 0
		}
		.environmentObject(helper)
		.environmentObject(BackgroundViewModel())
		
		
    }
}
