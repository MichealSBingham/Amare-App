//
//  FindNearbyUser.swift
//  Amare
//
//  Created by Micheal Bingham on 5/20/22.
//

import SwiftUI
import NearbyInteraction
//import MultipeerKit
/*
import EasyFirebase



struct FindNearbyUserView: View {
	
	@Binding var user: AmareUser
	
	@EnvironmentObject var dataModel: NearbyInteractionHelper// = NearbyInteractionHelper()
	
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
									otherUsersProfileImage = user.profile_image_url
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
			
		
				
			
			
			guard NISession.isSupported && user.supportsNearbyInteraction ?? false else {
				
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

//TODO: - flipping animation (card flip)
/// If awaiting connection, this is the location icon, otherwise this should animate to the other user's profile pic
///  -TODO:
struct centerImage: View {
	
	@Binding var connected: Bool
	@State var showOtherImage : Bool = false
	
	 @Binding var profile_image_url: String?
	
	 var size: CGFloat = CGFloat(80)
	
	var profileImageSize: CGFloat = CGFloat(150)
	
	@State private var condition: Bool = false
	
	var animation: Animation =
	Animation.easeInOut(duration: 1)
	   .repeatForever(autoreverses: true)
	
	
	
	@Binding var animationSpeed: SpeedOfAnimation
	
	@State var speed = 1.0
	
	var body: some View {
		
		//Location image
		
		ZStack{
	
				Image(systemName: "location.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: size, height: size)
					.foregroundColor(.white)
					.opacity(showOtherImage ? 0: 1 )
					
					//.animation(animation)
					
			
			ProfileImageView(profile_image_url: $profile_image_url, size: profileImageSize)
				.opacity(showOtherImage ? 1: 0 )
			
			//BROKEN .. Originally was going to use this to get the coordinate of the upper right corner but GeometryReader fucks things up
			/*
			VStack {
				
				HStack{
					Spacer()
					Group {
						GeometryReader{ geo in
							
							ProfileImageView(profile_image_url: $profile_image_url)
						}
					}
					
					
				}
				Spacer()
			} */
			
			
		}
		.scaleEffect(condition ? 0.9 : 1.0)
		.onChange(of: animationSpeed, perform: { newValue in
			
			condition = false
			var speed = 0.0
	
			switch newValue {
			case .slow:
				speed = 2
			case .normal:
				speed = 1
			case .medium:
				speed = 0.5
			case .fast:
				speed = 0.1
			}
		
			
			DispatchQueue.main.async {
				
				print("Setting speed to ... \(speed) ")
				withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
					condition = true
				}
			}
			
		})
		.onAppear {
			
			
			
		
			DispatchQueue.main.async {
				
				withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
					condition = true
				}
			}
			
		}
	
		.onChange(of: connected) { isConnected in
			
			
			withAnimation {
				showOtherImage = connected
			}
		}
	
	}
}







struct FindNearbyUserView_Previews: PreviewProvider {
	
	 
	
	
    static var previews: some View {
		
		var helper = NearbyInteractionHelper()
		
		let example = AmareUser.random() //AmareUser(id: "3432", name: "Micheal")
		FindNearbyUserView(user: .constant(example), blindMode: false).onAppear {
			helper.connected = true
			helper.isFacing = true
			helper.direction = 0
		}
		.environmentObject(helper)
		
		
    }
}


import MultipeerConnectivity
import FirebaseAuth

/// Class to help us interact with nearby users using the chip in iPhone to see how far they are
class NearbyInteractionHelper: NSObject, ObservableObject, NISessionDelegate{
	
	var testing: Bool = true
	
	// MARK: - Distance and direction state.
	// A threshold, in meters, the app uses to update its display.
	let nearbyDistanceThreshold: Float = 0.01 //0.1
	//TODO: - This threshold should depend on how far you are away; should be computed
	let facingAngleThreshold: Float = 5
	let thresholdForIsThere: Float = 0.001
	var firstDistanceReading: Float?
	enum DistanceDirectionState {
		case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
	}
	
	/// If 70%  there --> almost there,  if 50% there - halfway there,
	enum DistanceState{
		case farAway, halfwayThere, almostThere
	}
	///  How far away user is relatively speaking.
	 var distanceState: DistanceState? /* {
		
		 guard self.firstDistanceReading != nil else  { return nil }
		 var currentDistanceAway = self.trueDistance
		 guard currentDistanceAway != nil else { return nil }
		 
		 var fractionTraveled = 1 - (currentDistanceAway! / self.firstDistanceReading!)
		 
		 if fractionTraveled >= 0.5 && fractionTraveled < 0.7 { return DistanceState.halfwayThere}
		 
		 if fractionTraveled >= 0.7  && fractionTraveled < 1 { return DistanceState.almostThere}
		 
		 return DistanceState.farAway
		 
		 return nil
	} */

	// MARK: - Class variables
	/// Current user's discovery token
	 private var discoveryTokenData: Data? {
		 
		
		guard let token = sessionNI?.discoveryToken,
		   let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
			   

			   removeToken()
			
			   return nil
		}
		return data
	  }
	
	var sessionNI: NISession? {
		if testing {
			return nil
		} else {
			return NISession()
		}
	}
	
	@Published var peersDiscoveryToken: DiscoveryTokenDocument? {
		didSet{
			if peersDiscoveryToken != nil {
				self.run()
			}
		}
	}
	
	/// Nearby objects connected to, will always contain most recent positional data regardless of whether or not we moved in/out threshold
	@Published var nearbyObject: NINearbyObject?
	
	/// Can be a `NearbyUserError` or a `NIError`or an error from Firestore
	@Published var someErrorHappened: Error? {
		
		didSet{
			if someErrorHappened == nil {
				didAnErrorHappen = false
			} else {
				// only disconnect if the error is NOT wrongOrientation
				if let _someErrorHappened = someErrorHappened as? NearbyUserError {
					if _someErrorHappened != NearbyUserError.wrongOrientation { connected = false  }
					
					
				} else { connected = false }
				connected = false
				didAnErrorHappen = true
			}
		}
	}
	
	@Published var didAnErrorHappen: Bool = false
	
	
	@Published var trueDistance: Float?
	
	/// This distance only updates when the user moves within `threshold` amount. See `trueDistanceAway` for a realtime measure
	@Published var distanceAway: Float? {
		
		didSet{
			
			guard let previousDistanceReading = oldValue, let currentReading = distanceAway else {
				
				return
				
				
			}
			
			if previousDistanceReading > currentReading {
				// Moving towards because current reading is less
				
			
				isMovingTowards = true
			}
			
			else {
				
				// Moving away
				isMovingTowards = false
				
			}
			
			
			
			guard self.firstDistanceReading != nil else  { return self.distanceState = nil/*= DistanceState.farAway */}
			 var currentDistanceAway = self.trueDistance
			
			guard currentDistanceAway != nil else { return self.distanceState =  nil/*DistanceState.farAway*/ }
			 
			 var fractionTraveled = abs(1 - (currentDistanceAway! / self.firstDistanceReading!))
			 
			print("The fraction traveled ... \(fractionTraveled) ")
			if fractionTraveled >= 0.5 && fractionTraveled < 0.7 { self.distanceState =  DistanceState.halfwayThere}
			 
			if fractionTraveled >= 0.7  && fractionTraveled < 1 { self.distanceState =  DistanceState.almostThere}
			 
			if fractionTraveled < 0.5 { self.distanceState = DistanceState.farAway }
			
			 
			 
		}
	}
	
	/// In Radians. Azimuth angle
	@Published var direction: Float? {
		
		didSet{
			
			guard let direction = direction else { isFacing = false ; return }
			if abs(direction).isLessThanOrEqualTo(facingAngleThreshold) {
				isFacing = true
			} else {
				isFacing = false
			}
		}
	}
	
	/// In Radians. Polar angle 
	@Published var altitude: Float?
	
	/// Whether or not user is connected to another peer for nearby interaction
	@Published var connected: Bool = false//false
	
	
	
	private var mytoken: DiscoveryTokenDocument?
	
	@Published var currentDistanceDirectionState: DistanceDirectionState = .unknown
	
	
	/// Whether or not user is moving towards the other use. Only updates whenever the user moves at least an amount by `threshold` otherwise this will just be nil
	@Published var isMovingTowards: Bool?
	
	/// Whether or not user is facing the user. If cannot determine, this is nil.
	@Published var isFacing: Bool?
	
	// Whether or not the user has reached the other user
	 var isThere: Bool {
		
		 if let distanceAway = self.distanceAway, let isFacing = self.isFacing {
			
			 return distanceAway.isLessThanOrEqualTo(thresholdForIsThere) && isFacing
		}
		 
		 return false
	}

	//MARK: - Device Orientation
	
	@Published var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation {
		didSet{
			self.properOrientation = deviceOrientation == UIDeviceOrientation.portrait
		}
	}
	
	@Published var properOrientation: Bool = UIDevice.current.orientation == .portrait {
		didSet{
			if self.properOrientation == false {
				someErrorHappened = NearbyUserError.wrongOrientation
			} else {
				if let someErrorHappened = someErrorHappened as? NearbyUserError {
					
					// Delete the error if the device is in proper orientation
					if someErrorHappened == .wrongOrientation { self.someErrorHappened = nil }
				
				}
			}
		}
	}
	//MARK: - Constructor
	override init() {
		super.init()

		guard NISession.isSupported else {
			someErrorHappened = NIError(.unsupportedPlatform)
			
			// Let the other user know it's unsupported
			return
		}
		
		guard let sessionNI = sessionNI else { return }
	
		sessionNI.delegate = self
		
		
		NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)

		UIDevice.current.beginGeneratingDeviceOrientationNotifications()

		
		listenForPeerToken()
		
		
		
		
	}
	
	//MARK: - Life Cycle for Nearby Interaction Session
	
	/// Adds the discovery token in the database so that the other use can read it
	///   /discoveryTokens/{THEM - document containing token info with ID of `THEM`}/
	///   - Parameters:
	///   	- userID: The user id of the user that you are sending the discovery token to
	///   - Warning: Possible security weakness since this requires any signed in user to be able to read/write to this path
	 func sendToken(them userId: String){
		
		// guard NISession.isSupported else { self.someErrorHappened = NIError(.unsupportedPlatform); return  }
		 
		 // Make sure I have a token to even send
		 
		 

		 let token = DiscoveryTokenDocument(userId: userId, token: discoveryTokenData, deviceSupport: NISession.isSupported)
		 self.mytoken = token
		
		token.set { error in
			self.someErrorHappened = error
		}
	}
	
	
	/// This runs the session for nearby interaction and should run after the peer discovery token is received
	private func run(){
		
		// Make sure the peer's device is supported
		
		guard peersDiscoveryToken?.deviceSupportsNI == true else {
			self.someErrorHappened = NearbyUserError.theirDeviceIsntSupported
			return
		}
		
		// Ensure we have a discovery token
		guard let theirDiscoveryToken = peersDiscoveryToken?.token else {
			self.someErrorHappened = NearbyUserError.noDiscoveryToken
			return
		}
		
		
		// Ensure we can decode the token
		guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: theirDiscoveryToken) else {
			self.someErrorHappened = NearbyUserError.cantDecodeTheirDiscoveryToken
			return
			}
		
		let config = NINearbyPeerConfiguration(peerToken: token)
		sessionNI?.run(config)
		
		
	}
	
	/// Listen for tokens that peers sent to me. This document id should equal the id of the current signed in user.
	private func listenForPeerToken()  {
		
		
		guard let me = Auth.auth().currentUser?.uid else { self.someErrorHappened = AccountError.notSignedIn; return  }
		
		EasyFirestore.Listening.listen(to: me, ofType: DiscoveryTokenDocument.self, key: "discoveryToken") { token in
			
			
			self.peersDiscoveryToken = token
		}
		
		
		
		
	}
	
	func stopListeningForPeerToken()  {
		sessionNI?.invalidate()
		EasyFirestore.Listening.stop("discoveryToken")
		removeToken()
		stopListeningForOrientationChange()
		
	}
	
	/// Removes the token I sent to them (the current signed in user)
	private func removeToken() {
		
		guard let doc = mytoken else { return }
		
		
		EasyFirestore.Removal.remove(doc) { error in
			self.someErrorHappened = error
		}
		mytoken = nil
	}
	
	
	//MARK: - Listening to Nearby Object
	func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
		
		
		
		

		guard let nearbyObjectUpdate = nearbyObjects.first else { return }
		
		print("azimuth: \(nearbyObjectUpdate.direction) ")
		
		
		self.connected = true
		self.trueDistance =  nearbyObjectUpdate.distance
		
		
		//MARK: - Reading old positional data
		
		if self.firstDistanceReading == nil  { self.firstDistanceReading = nearbyObjectUpdate.distance }
		
		// Before update (old distance and old direction state)
		let old_distance = self.distanceAway
		let old_direction_state = getDistanceDirectionState(from: self.nearbyObject)
		
		//MARK: - Reading the new positional data
		let new_distance = nearbyObjectUpdate.distance
		let new_direction_state = getDistanceDirectionState(from: nearbyObjectUpdate)
		
		
		 
		
		
		// Check if device is moving towards or away
		//MARK: - Check if first reading
		
		guard old_distance != nil && new_distance != nil else {
			
			//MARK: - First reading
			print("First reading")
			self.nearbyObject = nearbyObjects.first
			self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
			self.distanceAway = nearbyObjects.first?.distance
			
			
		
			
			// Angle at which peer is located
			let azimuth = nearbyObjectUpdate.direction.map(azimuth(from:))
			
			self.direction = azimuth
			
			
			//TODO: - If trueDistance is within the threshold, we should now just check
			return
			
			
		}
		
		// Update nearby object regardless to get most recent reading
		//MARK: - Detect if moving towards/backwards
		
		// Make sure we're at least `threshold` distance away from previous reading before updating
		
		let distance_moved = abs(new_distance! - old_distance!)
		
		guard distance_moved >= nearbyDistanceThreshold else {
			// No need to update distance because we haven't moved but we can update the direction
			self.direction = nearbyObjectUpdate.direction.map(azimuth(from:))
			self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
			return
		}
		
		
		//MARK: - Updating distance and direction
		self.distanceAway = new_distance
		self.direction = nearbyObjectUpdate.direction.map(azimuth(from:))
		self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
		
		
	}
	
	func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
		session.invalidate()
		self.connected = false
		
		/*
		if reason ==  NINearbyObject.RemovalReason.peerEnded {
			self.someErrorHappened = NearbyUserError.outOfRange
		}
		
		if reason == NINearbyObject.RemovalReason.timeout{
			self.someErrorHappened = NearbyUserError.timeout
		}
		
		*/
	}

	func sessionWasSuspended(_ session: NISession) {
		
		self.connected = false
		self.someErrorHappened = NearbyUserError.disconnected
	    removeToken()
	}
	
	func session(_ session: NISession, didInvalidateWith error: Error) {
		self.someErrorHappened = error
		self.connected = false
		removeToken()
	}
	
	
	
	//MARK: - Device Orientation
	
	/// We need to observe the device orientation to make sure it's upright for NI to work right
	@objc private func orientationChanged()  {
		
		self.deviceOrientation = UIDevice.current.orientation
		
	}
	
	
	private func stopListeningForOrientationChange(){
		UIDevice.current.endGeneratingDeviceOrientationNotifications()
		
	}
	
	
	// MARK: - Visualizations
	
	
	func isNearby(_ distance: Float) -> Bool {
		return distance < nearbyDistanceThreshold
	}
	
	/*
	
	func isPointingAt(_ angleRad: Float) -> Bool {
		// Consider the range -15 to +15 to be "pointing at".
		return abs(angleRad.radiansToDegrees) <= 15
	}
	
	*/
	func getDistanceDirectionState(from nearbyObject: NINearbyObject?) -> DistanceDirectionState {
		
		guard let nearbyObject = nearbyObject else { return .unknown}
		if nearbyObject.distance == nil && nearbyObject.direction == nil {
			return .unknown
		}

		let isNearby = nearbyObject.distance.map(isNearby(_:)) ?? false
		let directionAvailable = nearbyObject.direction != nil

		if isNearby && directionAvailable {
			return .closeUpInFOV
		}

		if !isNearby && directionAvailable {
			return .notCloseUpInFOV
		}

		return .outOfFOV
	}

}



class DiscoveryTokenDocument: Document{
	
	// These properties are inherited from Document
	/// The user id of the user that this token is being sent TO
	  var id: String
	  var dateCreated: Date = Date()
	
	  var token: Data?
	  var deviceSupportsNI: Bool
	
	init(userId: String, token: Data?, deviceSupport: Bool ) {
		self.id = userId
		self.token = token
		self.deviceSupportsNI = deviceSupport
	}
}


enum NearbyUserError: Error {
	/// Cannot decode discovery token
	case cantDecodeTheirDiscoveryToken
	case cantDecodeMyDiscoveryToken
	
	case timeout
	case outOfRange
	/// Our peer didn't send us a discovery token
	case noDiscoveryToken
	case theirDeviceIsntSupported
	
	///  The user disconnected, more likely it's the other user but it could be the current user
	case disconnected
	
	/// The user's device is in the wrong orientation, should be portrait up
	case wrongOrientation
}

*/
