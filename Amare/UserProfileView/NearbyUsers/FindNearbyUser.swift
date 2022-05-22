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



struct FindNearbyUser: View {
	
	let user: AmareUser
	
	@StateObject var dataModel: NearbyInteractionHelper = NearbyInteractionHelper()
	
	@State var textToDisplay: String = "Waiting on their response... "
	
	
    var body: some View {
		
		
		ZStack{
			
			Text(textToDisplay)
				.opacity(dataModel.distanceAway == nil  ? 1: 0)
			
			HStack{
				
				Text("Distance Away: ")
				Text(dataModel.distanceAway?.description)
				Text("Meters")
			}
				.opacity(dataModel.distanceAway == nil  ? 0: 1)
				
			
			
		}
		
		.onAppear {
			
			dataModel.sendToken(them: user.id!)
			
		}
		.onDisappear {
			dataModel.stopListeningForPeerToken()
		}
        
		
	 
    }
}

struct FindNearbyUser_Previews: PreviewProvider {
    static var previews: some View {
		FindNearbyUser(user: AmareUser())
    }
}


import MultipeerConnectivity
import FirebaseAuth

/// Class to help us interact with nearby users using the chip in iPhone to see how far they are
class NearbyInteractionHelper: NSObject, ObservableObject, NISessionDelegate{
	
	let sessionNI = NISession()

	/// Current user's discovery token
	 private var discoveryTokenData: Data? {
		guard let token = sessionNI.discoveryToken,
		   let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
			   

			   removeToken()
			
			   self.someErrorHappened = NearbyUserError.cantDecodeDiscoveryToken
			   return nil
		}
		return data
	  }
	
	@Published var peersDiscoveryToken: DiscoveryTokenDocument? {
		didSet{
			if peersDiscoveryToken != nil {
				self.run()
			}
		}
	}
	
	/// Nearby objects connected to 
	@Published var nearbyObjects: [NINearbyObject] = []
	@Published var someErrorHappened: Error?
	
	@Published var distanceAway: Float?
	
	private var mytoken: DiscoveryTokenDocument?
	
	
	override init() {
		super.init()
		sessionNI.delegate = self
		listenForPeerToken()
		
		
		
		
	}
	
	/// Adds the discovery token in the database so that the other use can read it
	///   /discoveryTokens/{THEM - document containing token info with ID of `THEM`}/
	///   - Parameters:
	///   	- userID: The user id of the user that you are sending the discovery token to
	///   - Warning: Possible security weakness since this requires any signed in user to be able to read/write to this path
	 func sendToken(them userId: String){
		
		 print("#inside sendToken")
		 guard let discoveryTokenData = discoveryTokenData else {
			 return
			 self.someErrorHappened = NearbyUserError.cantDecodeDiscoveryToken
		 }

		let token = DiscoveryTokenDocument(userId: userId, token: discoveryTokenData)
		 self.mytoken = token
		
		token.set { error in
			self.someErrorHappened = error
		}
	}
	
	
	/// This runs the session for nearby interaction and should run after the peer discovery token is received
	private func run(){
		
		// Ensure we have a discovery token
		guard let theirDiscoveryToken = peersDiscoveryToken else {
			return
		}
		
		
		// Ensure we can decode the token
		guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: theirDiscoveryToken.token) else {
			self.someErrorHappened = NearbyUserError.cantDecodeDiscoveryToken
			return
			}
		
		let config = NINearbyPeerConfiguration(peerToken: token)
		sessionNI.run(config)
		
		
	}
	
	/// Listen for tokens that peers sent to me. This document id should equal the id of the current signed in user.
	private func listenForPeerToken()  {
		
		
		guard let me = Auth.auth().currentUser?.uid else { self.someErrorHappened = AccountError.notSignedIn; return  }
		
		EasyFirestore.Listening.listen(to: me, ofType: DiscoveryTokenDocument.self, key: "discoveryToken") { token in
			
			print("#got token: \(token)")
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
	
	
	
	func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
		self.nearbyObjects = nearbyObjects
		distanceAway = nearbyObjects.first?.distance
		
	}
	

	func sessionWasSuspended(_ session: NISession) {
		print("Session was suspended")
		//removeToken()
	}
	
	func session(_ session: NISession, didInvalidateWith error: Error) {
		self.someErrorHappened = error
		removeToken()
	}

}



class DiscoveryTokenDocument: Document{
	
	// These properties are inherited from Document
	/// The user id of the user that this token is being sent TO
	  var id: String
	  var dateCreated: Date = Date()
	
	var token: Data
	
	init(userId: String, token: Data) {
		self.id = userId
		self.token = token 
	}
}


enum NearbyUserError: Error {
	/// Cannot decode discovery token
	case cantDecodeDiscoveryToken
}
