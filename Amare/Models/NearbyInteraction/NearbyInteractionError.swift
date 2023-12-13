//
//  NearbyInteractionError.swift
//  Amare
//
//  Created by Micheal Bingham on 10/13/23.
//

import Foundation

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


