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
	
	
	

	
	
    var body: some View {
        Text("Waiting to hear from them...")
			.onAppear {
				
			}
    }
}

struct FindNearbyUser_Previews: PreviewProvider {
    static var previews: some View {
        FindNearbyUser()
    }
}


import MultipeerConnectivity

/// Class to help us interact with nearby users using the chip in iPhone to see how far they are
class NearbyInteractionHelper: NSObject, ObservableObject, NISessionDelegate{
	
	let session = NISession()

	
	/// Nearby objects connected to 
	@Published var nearbyObjects: [NINearbyObject] = []
	
	
	override init() {
		super.init()
		session.delegate = self
		
		let myDiscoveryToken = session.discoveryToken
		
		
		
	}
	
	func sendToken(){
		
	}
	
	
	func run(){
		
		//let config = NINearbyPeerConfiguration(peerToken: <#T##NIDiscoveryToken#>)
		//session.run(config)
		
		
	}
	
	
	
	func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
		self.nearbyObjects = nearbyObjects
	}
}

