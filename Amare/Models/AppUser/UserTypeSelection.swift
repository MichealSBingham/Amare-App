//
//  UserTypeSelection.swift
//  Amare
//
//  Created by Micheal Bingham on 7/13/23.
//

import Foundation

enum UserTypeSection : String, CaseIterable {
    case all = "All"
    case friends = "Friends"
    case requests = "Requests"
    case historicals = "Historicals"
    case suggestions = "Suggestions" // perhaps show this up top like you do for 'nearby' users instead of a segment control
    case custom = "Custom"
}
