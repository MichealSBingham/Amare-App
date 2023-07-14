//
//  SearchAndFriendsViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 7/13/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class SearchAndFriendsViewModel: ObservableObject {
    
    
    
    @Published var friendRequests: [FriendRequest] =  []
    @Published var error: Error?
    
    
    // Whether we are displaying this data in preview or not
    var inPreview: Bool = false
    
    
    private var friendRequestsListener: ListenerRegistration?
    
    
    init(inPreview: Bool = false) {
            // Retrieve the current signed-in user's ID from Firebase Authentication
            
        if let id = Auth.auth().currentUser?.uid {
            self.error = nil
            fetchFriendRequests(for: id, inPreview: inPreview)
        } else {
            self.error = AccountError.notSignedIn
        }
       
        
        }
    
    
    deinit {
            friendRequestsListener?.remove()
        }
    
    
    func fetchFriendRequests(for userId: String, inPreview: Bool = false) {
         FirestoreService.shared.getAllFriendRequests(for: userId, inPreview: inPreview) {  result in
                switch result {
                case .success(let friendRequests):
                    self.error = nil
                    DispatchQueue.main.async {
                        self.friendRequests = friendRequests
                    }
                case .failure(let error):
                    self.error = error
                    print("Failed to fetch friend requests: \(error)")
                }
            }
        }
    
    
    
    
   
    /*
    func searchUsers(matching prefix: String) {
        FirestoreService.shared.searchUsers(matching: prefix) { result in
            switch result {
            case .success(let (users, notables)):
                self.error = nil
                DispatchQueue.main.async {
                                withAnimation {
                                    self.users = users
                                    self.notables = notables
                                }
                            }
            case .failure(let error):
                print("Failed to search users: \(error.localizedDescription)")
                self.error = error
                DispatchQueue.main.async {
                                withAnimation {
                                    self.users = []
                                    self.notables = []
                                }
                            }
            }
        }
    }
     */
}
