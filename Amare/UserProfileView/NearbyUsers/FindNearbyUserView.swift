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
			
			Text(textToDisplay)
				.opacity(!dataModel.connected ? 1: 0)
				.alert(isPresented: $errorDetected) {
					Alert(title: Text("Error"), message: Text(errorMessage))
				}
				
			
			VStack{
				
				HStack{
					
					//Text("Distance Away: ")
					Text(String(format: "%0.2f m %0.2f degrees", Double(dataModel.distanceAway ?? 0), Double(dataModel.direction ?? 0)))
			
					
					
					//Text("Meters")
				}
				.padding()
					
				if let pos = dataModel.nearbyObject?.direction{
					Text(String("x: \(pos.x)\ny: \(pos.y)\n z: \(pos.z)"))
				}
				
				
				Image(systemName: "arrow.up")
					.resizable()
					.frame(width: 150, height: 200)
					.aspectRatio(contentMode: .fit)
					.rotationEffect(.radians(Double(dataModel.direction ?? 0 )))
					.animation(.easeIn, value: dataModel.direction)
				
				
				
				
			}
			.opacity(!dataModel.connected   ? 0: 1)
		
			
		}
		
		
		
		.onAppear {
			
			// Make sure both devices can even do nearby interaction
			
			
			guard NISession.isSupported && user.supportsNearbyInteraction ?? false else {
				
				if !NISession.isSupported { dataModel.someErrorHappened = NIError(.unsupportedPlatform) } else {
					
					dataModel.someErrorHappened = NearbyUserError.theirDeviceIsntSupported
				}
				
				return
			}
			
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
					}
				}
			}
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
	
	/// Nearby objects connected to 
	@Published var nearbyObject: NINearbyObject?
	
	/// Can be a `NearbyUserError` or a `NIError`or an error from Firestore
	@Published var someErrorHappened: Error? {
		
		didSet{
			if someErrorHappened == nil {
				didAnErrorHappen = false
			} else {
				connected = false
				didAnErrorHappen = true
			}
		}
	}
	
	@Published var didAnErrorHappen: Bool = false
	
	@Published var distanceAway: Float?
	
	/// In Radians. Azimuth angle
	@Published var direction: Float?
	
	/// In Radians. Polar angle 
	@Published var altitude: Float?
	
	/// Whether or not user is connected to another peer for nearby interaction
	@Published var connected: Bool = false
	
	private var mytoken: DiscoveryTokenDocument?
	
	var currentDistanceDirectionState: DistanceDirectionState = .unknown
	
	
	
	//MARK: - Constructor
	override init() {
		super.init()

		guard NISession.isSupported else {
			someErrorHappened = NIError(.unsupportedPlatform)
			
			// Let the other user know it's unsupported
			return
		}
	
		sessionNI.delegate = self
		
		
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
		
		self.nearbyObject = nearbyObjects.first
		distanceAway = nearbyObjects.first?.distance
		
		connected = true
		
		print("The vector is : \(nearbyObjectUpdate.direction)")
		
		// Angle at which peer is located
		let azimuth = nearbyObjectUpdate.direction.map(azimuth(from:))
		self.direction = azimuth
		 
		 /*
		// Update the the state and visualizations.
		let nextState = getDistanceDirectionState(from: nearbyObjectUpdate)
		updateVisualization(from: currentDistanceDirectionState, to: nextState, with: nearbyObjectUpdate)
		currentDistanceDirectionState = nextState
		*/
	}
	
	func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
		session.invalidate()
		connected = false
		
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
	
	
	
	
	
	
	
	// MARK: - Visualizations
	
	/*
	func isNearby(_ distance: Float) -> Bool {
		return distance < nearbyDistanceThreshold
	}
	
	func isPointingAt(_ angleRad: Float) -> Bool {
		// Consider the range -15 to +15 to be "pointing at".
		return abs(angleRad.radiansToDegrees) <= 15
	}
	*/
	/*
	func getDistanceDirectionState(from nearbyObject: NINearbyObject) -> DistanceDirectionState {
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
*/
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
}

