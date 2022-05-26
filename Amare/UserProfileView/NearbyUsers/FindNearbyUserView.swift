//
//  FindNearbyUser.swift
//  Amare
//
//  Created by Micheal Bingham on 5/20/22.
//

import SwiftUI
import NearbyInteraction
import MultipeerKit
import EasyFirebase



struct FindNearbyUserView: View {
	
	let user: AmareUser
	
	@StateObject  var dataModel: NearbyInteractionHelper = NearbyInteractionHelper()
	
	@State var textToDisplay: String = "Waiting on their response... "
	
	@State var errorMessage: String = ""
	@State var errorDetected: Bool = false
	
	
	
	

    var body: some View {
		
	
			
			ZStack{
				
				//MARK: - Loading Screen for Connecting
				VStack{
					
					Spacer()
					
					ZStack{
						
						PulsingView()
						
						
						Image(systemName: "location.circle.fill")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 80, height: 80)
							.foregroundColor(.white)
							.opacity(!dataModel.connected ? 1: 0)
							.alert(isPresented: $errorDetected) {
								Alert(title: Text("Error"), message: Text(errorMessage))
							}
					}
					
					
					
					Spacer()
					
					Text("Waiting for them...")
						.font(.largeTitle)
						.bold()
						.multilineTextAlignment(.center)
						.padding()
						.colorMultiply(.white)
					
					Text("We're waiting for them to connect so keep breathing. You got this.")
						.colorMultiply(.white)
						.font(.subheadline)
						.multilineTextAlignment(.center)
						.padding()
					
				 
					
				}
				
		
				
				
				
				//MARK: - Connected to another user
		/*		VStack{
					
					HStack {
						Spacer()
						Text("Profile Image here")
					}
					
					
					ZStack{
						// If no direction is detected
						
						
						
						
						// If direcgtion is detected show arrow
					}
					
					/*
					HStack{
						
						//Text("Distance Away: ")
						Text(String(format: "%0.2f m %0.2f degrees", Double(dataModel.trueDistance ?? 0), Double(dataModel.direction ?? 0)))
				
						
						
						//Text("Meters")
					}
					.padding()
						
					
				
					
					
					
					
					
					Image(systemName: "arrow.up")
						.resizable()
						.frame(width: 150, height: 200)
						.aspectRatio(contentMode: .fit)
						.rotationEffect(.radians(Double(dataModel.direction ?? 0 )))
						.animation(.easeIn, value: dataModel.direction)
						//.colorMultiply(dataModel.isMovingTowards != nil  ? (dataModel.isMovingTowards == true ? Color.green: Color.red) : Color.clear )
						//.background(dataModel.isMovingTowards != nil  ? (dataModel.isMovingTowards == true ? Color.green: Color.red) : Color.clear )
					
					
					*/
				}
				.opacity(!dataModel.connected   ? 0: 1)
			//	.opacity(1)
				
			*/
				
			}
			.navigationTitle(Text(dataModel.connected ? "\(user.name ?? "")" : "DateDar®"))
			.preferredColorScheme(.dark)
			.foregroundColor(.gray)
		
		
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
	
	
}

//TODO: - flipping animation (card flip)
/// If awaiting connection, this is the location icon, otherwise this should animate to the other user's profile pic
///  -TODO:
struct centerImage: View {
	
	@Binding var connected: Bool
	@State var showOtherImage : Bool = false
	
	var body: some View {
		
		//Location image
		
		ZStack{
	
				Image(systemName: "location.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 80, height: 80)
					.foregroundColor(.white)
					.opacity(showOtherImage ? 0: 1 )
			
				Image("profile")
				.opacity(showOtherImage ? 1: 0 )
			
			
		}
		.onChange(of: connected) { isConnected in
			
			withAnimation {
				showOtherImage = connected
			}
		}
	
	}
}



/// View for when user is still awaiting a connection
struct AwaitingConnectionView: View{
	
	/// Binding for whether or not the user is connected to the other user via NearbyInteraction or not
	@Binding var isConnected: Bool
	
	
	var body: some View {
		//MARK: - Loading Screen for Connecting
		VStack{
			
			Spacer()
			
			ZStack{
				
				PulsingView()
				
				
				Image(systemName: "location.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 80, height: 80)
					.foregroundColor(.white)
					//.opacity(isConnected ? 1: 0)
					
			}
			
			
			
			Spacer()
			
			Text("Waiting for them...")
				.font(.largeTitle)
				.bold()
				.multilineTextAlignment(.center)
				.padding()
				.colorMultiply(.white)
			
			Text("We're waiting for them to connect so keep breathing. You got this.")
				.colorMultiply(.white)
				.font(.subheadline)
				.multilineTextAlignment(.center)
				.padding()
			
		 
			
		}
	}
}



struct FindNearbyUserView_Previews: PreviewProvider {
    static var previews: some View {
		
		let example = AmareUser(id: "3432", name: "Micheal")
		FindNearbyUserView(user: example)
    }
}


import MultipeerConnectivity
import FirebaseAuth

/// Class to help us interact with nearby users using the chip in iPhone to see how far they are
class NearbyInteractionHelper: NSObject, ObservableObject, NISessionDelegate{
	

	
	// MARK: - Distance and direction state.
	// A threshold, in meters, the app uses to update its display.
	let nearbyDistanceThreshold: Float = 0.3
	let facingAngleThreshold: Float = 0.15
	enum DistanceDirectionState {
		case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
	}

	// MARK: - Class variables
	/// Current user's discovery token
	 private var discoveryTokenData: Data? {
		 
		
		guard let token = sessionNI.discoveryToken,
		   let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
			   

			   removeToken()
			
			   return nil
		}
		return data
	  }
	
	let sessionNI = NISession()
	
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
		sessionNI.run(config)
		
		
	}
	
	/// Listen for tokens that peers sent to me. This document id should equal the id of the current signed in user.
	private func listenForPeerToken()  {
		
		
		guard let me = Auth.auth().currentUser?.uid else { self.someErrorHappened = AccountError.notSignedIn; return  }
		
		EasyFirestore.Listening.listen(to: me, ofType: DiscoveryTokenDocument.self, key: "discoveryToken") { token in
			
			
			self.peersDiscoveryToken = token
		}
		
		
	}
	
	func stopListeningForPeerToken()  {
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
		
		
		
		self.connected = true
		self.trueDistance =  nearbyObjectUpdate.distance
		
		
		//MARK: - Reading old positional data
		
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

