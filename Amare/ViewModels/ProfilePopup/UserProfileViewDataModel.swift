//
//  UserProfileViewDataModel.swift
//  Amare
//
//  Created by Micheal Bingham on 1/17/22.
//

import Foundation
import Firebase
import UIKit


/// Class for view model of  a user shown on screen
class UserDataModel: ObservableObject{
    
    @Published var userData: AmareUser = AmareUser()
    


    
    /// Will be true if the user has incomplete data in the database so some error happened during account creation/signup process so sign the user out if this happens so they can resign up.
    @Published var inCompleteData: Bool = false
    
    private var db = Firestore.firestore()
    
    private var userDataSnapshotListener: ListenerRegistration?
    
    private var natalChartListener: ListenerRegistration?
    
    private var myFriendsListener: ListenerRegistration?

    private var requestsListener: ListenerRegistration?
    
    private var openFriendRequestsListener: ListenerRegistration?
    

    private var winkStatusListener: ListenerRegistration?
    
    private var winkStatusAtMeListener: ListenerRegistration?
    
    /*
    init() {
        
        subscribeToUserDataChanges()
    }
    */
    
    /// Subscribes to real-time data for user of this user // their natal chart, user data infromation, wink/friendship status
    func load(user id: String)   {
        
        self.subscribeToUserDataChanges(for: id)
        self.subscribeToNatalChart(for: id)
        self.subscribeToFriendshipStatus(them: id)
        self.subscribeToWinkStatus(them: id)
        
    }
    
    /// Loads the current user // their natal chart, user data infromation, wink/friendship status
    func load()  {

        if let id = Auth.auth().currentUser?.uid {
            self.subscribeToUserDataChanges(for: id)
            self.subscribeToNatalChart(for: id)
            self.subscribeToFriendshipStatus(them: id)
            self.subscribeToWinkStatus(them: id)
        }
    }
   
    /// Subscribes to changes to the given user with `id`
    private func subscribeToUserDataChanges(for id: String? )  {
        
        print("***Subscribing to user data changes \(id)")
        if let id = id{
            
       
            
            userDataSnapshotListener  =  db.collection("users").document(id).addSnapshotListener { snapshot, error in
                
                print("The id is ... \(id)")
                
                print("The snapshot is \(snapshot) does it exist? \(snapshot?.exists) and error is \(error)")
                
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    self.inCompleteData = true
                    print("Snapshot doesn't exist ")
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: AmareUser.self)
                }
                
                switch result {
                case .success(let success):
                    print("|***There was success grabbing user \(success) is complete: \(success?.isComplete())")
                    
                    
                    if var data = success {
                        
                        data.id = id 
                        
                        print("!!!After setting data id is \(data.id)")
                     
                        // if we're loading the current user, download their profile image and save to cache
                        if id == Auth.auth().currentUser?.uid {
                            
                            var image_ = data.downloadProfileImage()
                            data.image = image_
                            
                            print("!!! image is \(data.image)")
                            
                            // Add device id to this
                            if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
                                data.deviceID = deviceID
                                print("!!! device id is \(data.deviceID)")
                            }
                        }
                        self.userData = data
                        
                        print("!!!now, self.userdata is .. \(self.userData)")
                        
                        
                    }
                    
                    
                    // check if the user data is complete
                    if let isComplete = success?.isComplete() {
                        
                        print("It is complete data")
                        self.inCompleteData = !isComplete
                    }  else {
                        self.inCompleteData = true
                    }
                    
                   
                    
                case .failure(let failure):
                    
                    print("**The enrror grabbing user data is .. \(failure)")
                    
                }
                
            }
            
        }
       
        
    }
    
    
    //TODO: Make private
    /// Subscribes to changes to the given user with `id`
    /// - Parameters:
    ///   - id: Id of the user
    ///   - isOuterChart: Default `false`. Set to `true` if this user should be the outer chart when doing synastry
    ///   - completion: Passing the error and the natal chart in this completion block. Will also be publisehd to the view model
    private func subscribeToNatalChart(for id: String?, isOuterChart: Bool = false, completion: ( (_ err: Error?, _ natalChart: NatalChart?) -> Void)?  = nil )  {
        
        // // \\ \\ // \\ // \\ // \\ // \\ // \\ 
        print("***Subscribing to user data changes in natal \(id)")
        if let id = id{
            
            natalChartListener  =  db.collection("users").document(id).collection("public").document("natal_chart")
                .addSnapshotListener {   snapshot, error in
                
                
                
                    guard error == nil else{
                        // Handle these errors....
                        
                        if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                            
                            switch error {
                                
                                // Handle Global Errors
                            case .networkError:
                                completion?(GlobalError.networkError, nil )
                            case .tooManyRequests:
                                completion?(GlobalError.tooManyRequests, nil )
                            case .captchaCheckFailed:
                                completion?(GlobalError.captchaCheckFailed, nil )
                            case .quotaExceeded:
                                completion?(GlobalError.quotaExceeded, nil )
                            case .operationNotAllowed:
                                completion?(GlobalError.notAllowed, nil )
                            case .internalError:
                                print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                                completion?(GlobalError.internalError, nil )
                                
                                // Handle Account Errors
                            case .expiredActionCode:
                                completion?(AccountError.expiredActionCode, nil )
                            case .sessionExpired:
                                completion?(AccountError.sessionExpired, nil )
                            case .userTokenExpired:
                                completion?(AccountError.userTokenExpired, nil )
                            case .userDisabled:
                                completion?(AccountError.disabledUser, nil )
                            case .wrongPassword:
                                completion?(AccountError.wrong, nil )
                            default:
                                print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                                completion?(GlobalError.unknown, nil )
                            }
                            
                           return
                            
                        } else{
                            
                            print("\n\nSome error happened, likely an unhandled error from firebase : \(error). This happened inside Account.getUserData()")
                            completion?(GlobalError.unknown, nil )
                            return
                        }
                    
                        
                        
                    }
                    
                    
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    
                    completion?(AccountError.doesNotExist, nil)
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: NatalChart.self)
                }
                
                switch result {
                case .success(let success):
                    
                    if var data = success{
                        
                        // Data object contains all of the natal chart's data
                        
                        // Mark all of the planets and angles as being used for synastry...
                        //TODO: Can optimize this later
                        for (index, _) in data.planets.enumerated() {
                            data.planets[index].forSynastry = isOuterChart
                        }
                        
                        for (index, _) in data.angles.enumerated() {
                            data.angles[index].forSynastry = isOuterChart
                        }
                        
                        self.userData.natal_chart = data
                        
                        
                        
     
                        
                        // /// / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / /// / // /
                        
                        
                        
                        
                        completion?(nil, data)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        completion?(AccountError.doesNotExist, nil )
                    }
                    
                case .failure(let failure):
                    
                    print("**The error grabbing user data is .. \(failure)")
                    completion?(failure, nil)
                    
                }
                
            }
            
        }
       
        
    }
    

    /// Unsubscribes to changes to the current signed in user's data
    func unsubscribeToUserDataChanges()  {
       
        if let listener = userDataSnapshotListener {
            listener.remove()
        }
    }
    
    /// Unsubscribes to changes to the natal chart
    func unsubscribeToNatalChart()  {
       
        if let listener = natalChartListener {
            listener.remove()
        }
    }
    
    
    /// Subscribes to updates to the friendship status; i.e. this is called to see if the user  `userData.id` is friends with the current signed in user. Will also check if there is an open friend request.
    private func subscribeToFriendshipStatus(them: String)  {
        
        if let me = Auth.auth().currentUser?.uid {
            
            myFriendsListener =  db.collection("friends").document(me).collection("myFriends").document(them)
                .addSnapshotListener({ snapshot, error in
                    
                    if snapshot?.exists ?? false {
                        // friends already
                        
                       
                        self.userData.areFriends = true
                    
                    } else {
                        
                     
                        self.userData.areFriends = false
                        
                       
                    }
                })

           requestsListener = db.collection("friends").document(them).collection("requests").document(me).addSnapshotListener({ snapshot, error in
                
                if snapshot?.exists ?? false {
                    // There is a friend request there that I sent to this user
                    let didAccept: Bool  = snapshot?.data()?["accepted"] as? Bool ?? false
                   
                    self.userData.requested = !didAccept
  
                    
                }  else {
                    // there is most definitely no friend pending
                    self.userData.requested = false

                }
            })
            
            
            openFriendRequestsListener = db.collection("friends").document(me).collection("requests").document(them).addSnapshotListener({ snapshot, error in
                    
                    if snapshot?.exists ?? false {
                        // They sent me (current signed in user) a friend request
                       
                      
                        self.userData.openFriendRequest = true
                        
                        
                        
                    }  else {
                        // They did not send me a freind request
                      
                        self.userData.openFriendRequest = false
                        
                       
                    }
                })
            
            
        }
        
    }
    
    /// Subscribes to updates to whether or not we've winked at each other
    private func subscribeToWinkStatus(them: String)   {
        
        guard  let me = Auth.auth().currentUser?.uid else {return }
        
        winkStatusListener = db.collection("winks").document(them).collection("people_who_winked").document(me).addSnapshotListener({ snapshot, error in
            
            print("*** THe snapshot is \(snapshot) with error \(error)")
            
            if snapshot?.exists ?? false {
                
                    
                self.userData.winkedTo = true
                
               
            } else {
                self.userData.winkedTo = false
            }
        })
        
        
        winkStatusAtMeListener = db.collection("winks").document(me).collection("people_who_winked").document(them).addSnapshotListener({ snapshot, error in
            
            print("*** THe snapshot is \(snapshot) with error \(error)")
            
            if snapshot?.exists ?? false {
                
                    
                self.userData.winkedAtMe = true
                
               
            } else {
                self.userData.winkedAtMe = false
            }
        })
    
    

    }
    
    

    
}
