//
//  LocationPrivacySettings.swift
//  Amare
//
//  Created by Micheal Bingham on 11/30/23.
//

import Foundation

enum LocationPrivacySettings: String, Codable{
    case on = "ON"
    case off = "OFF"
    case approximate = "ON*"

    var description: String {
        switch self {
        case .approximate:
            return "Only Your Approximate Location Shown"
        case .off:
            return "No One Can See You"
        case .on:
            return "Those Near You Can See You"
        }
    }
}
