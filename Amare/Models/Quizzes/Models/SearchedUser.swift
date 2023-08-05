//
//  SearchedUser.swift
//  Amare
//
//  Created by Micheal Bingham on 7/20/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct SearchedUser: Identifiable, Codable {
    @DocumentID public var id: String?
    var isNotable: Bool
    var userId: String
    var username: String
    var wikipedia_link: String?
    var profile_image_url: String?
}
