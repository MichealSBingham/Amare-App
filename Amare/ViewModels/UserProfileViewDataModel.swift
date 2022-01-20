//
//  UserProfileViewDataModel.swift
//  Amare
//
//  Created by Micheal Bingham on 1/17/22.
//

import Foundation
import Firebase


/// Class for view model of  a user shown on screen
class UserDataModel: ObservableObject{
    
    @Published var userData: AmareUser?
    
    @Published var natalChart: NatalChart?
    

    
    /// Will be true if the user has incomplete data in the database so some error happened during account creation/signup process so sign the user out if this happens so they can resign up.
    @Published var inCompleteData: Bool = false
    
    private var db = Firestore.firestore()
    
    private var userDataSnapshotListener: ListenerRegistration?
    
    private var natalChartListener: ListenerRegistration?

    
    /*
    init() {
        
        subscribeToUserDataChanges()
    }
    */
    
    
   
    /// Subscribes to changes to the given user with `id`
    func subscribeToUserDataChanges(for id: String? )  {
        
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
                    print("***There was success grabbing user \(success) is complete: \(success?.isComplete())")
                    self.userData = success
                    
                    // check if the user data is complete
                    if let isComplete = success?.isComplete() {
                        
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
    
    
    /// Subscribes to changes to the given user with `id`
    /// - Parameters:
    ///   - id: Id of the user
    ///   - isOuterChart: Default `false`. Set to `true` if this user should be the outer chart when doing synastry
    ///   - completion: Passing the error and the natal chart in this completion block. Will also be publisehd to the view model
    func subscribeToNatalChart(for id: String?, isOuterChart: Bool = false, completion: ( (_ err: Error?, _ natalChart: NatalChart?) -> Void)?  = nil )  {
        
        // // \\ \\ // \\ // \\ // \\ // \\ // \\ 
        print("***Subscribing to user data changes \(id)")
        if let id = id{
            
            natalChartListener  =  db.collection("users").document(id).collection("public").document("natal_chart")
                .addSnapshotListener { snapshot, error in
                
                
                
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
                        
                        self.natalChart = data
                        
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
    
    
}
