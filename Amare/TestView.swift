//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI
import Firebase
import PushNotifications
import MultipeerKit

class TestViewModel: ObservableObject{
    
    @Published var userData: AmareUser = AmareUser()
    
    @Published var nearbyUsersByMultipeer =  Set<AmareUser>()
    
    @Published var nearby: [AmareUser] = []
    
    public var allNearbyUsers: [AmareUser] {
       Array( nearbyUsersByMultipeer)
    }

    
    /// Will be true if the user has incomplete data in the database so some error happened during account creation/signup process so sign the user out if this happens so they can resign up.
   // @Published var inCompleteData: Bool = false
    
    private var db = Firestore.firestore()
    
    /*
    private var userDataSnapshotListener: ListenerRegistration?
    
    private var natalChartListener: ListenerRegistration?
    
    private var myFriendsListener: ListenerRegistration?

    private var requestsListener: ListenerRegistration?
    
    private var openFriendRequestsListener: ListenerRegistration?
    

    private var winkStatusListener: ListenerRegistration?
    
    private var winkStatusAtMeListener: ListenerRegistration?
    
    */
    /*
    init() {
        
        subscribeToUserDataChanges()
    }
    */
    
    
    /*
    /// Subscribes to real-time data for user of this user // their natal chart, user data infromation, wink/friendship status
    func load(user id: String)   {
        
        self.subscribeToUserDataChanges(for: id)
        self.subscribeToNatalChart(for: id)
        self.subscribeToFriendshipStatus(them: id)
        self.subscribeToWinkStatus(them: id)
        
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
                    
                    
                    if var data = success { data.id = id ; self.userData = data }
                    
                    
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
        print("***Subscribing to user data changes \(id)")
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
    
    */
    
    /*

    /// Gets the user data for the nearby peers detected, tries to get from cache first when loading user data
    /// TODO: Change to cache AND watch for  !
    func fetchDataOfNearbyMultipeers(userIds: [String])  {
        
        let idsWeAlreadyHave = NSCountedSet(array: (nearbyUsersByMultipeer).map { $0.id }).allObjects as? [String] ?? []
        
        guard userIds != idsWeAlreadyHave else {
            print("**No need to get data because user ids == nearbyusers")
            return
        }
        
        for id in userIds{
            
            db.collection("users").document(id).getDocument(source: .server) { [self] snapshot, error in
            
                
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: AmareUser.self)
                }
                
                switch result {
                case .success(let success):
                 
                    
                    
                    if var amareUserData = success {
                        
                        guard amareUserData.isComplete() else { return }
                        
                        amareUserData.id = snapshot!.documentID
                        // Make sure it's not already in the array
                        guard !idsWeAlreadyHave.contains(amareUserData.id!) else {return}
                        
                    }
                    
                    
                   
                    
                case .failure(let failure):
                    
                    print("**The error grabbing user data is .. \(failure)")
                    
                }
            }
        }
    
    }
    
    */
    
}



struct TestView: View {
    

    /// View model for the current signed in user's realtime data.
    @EnvironmentObject var mainViewModel: UserDataModel
    
    /// View model for nearby users and other data that populates this view
    @ObservedObject var viewModel: TestViewModel = TestViewModel()
    
    
    let beamsClient = PushNotifications.shared
    
    
    /*
    @ObservedObject var multipeerDataSource: MultipeerDataSource =
    MultipeerDataSource(transceiver: MultipeerTransceiver(configuration: MultipeerConfiguration(serviceType: "Amare", peerName: Auth.auth().currentUser?.uid ?? "id", defaults: UserDefaults.standard, security: .default, invitation: .automatic)))
*/
    @State var showingPopup = true
   
    @EnvironmentObject var multipeerDataSource: MultipeerDataSource

    
    // Consider Adding elsewhere
    
 
  
    

    
    
    var body: some View {
        
        
        
       
        
        
        
        ZStack{
            
            
            VStack{
                
                List($viewModel.nearby){ $person in
                    
                    Text(person.name ?? "No name")
                    
                }
            }
            
            

            /*
            VStack{
                
                ForEach(viewModel.nearbyUsersByMultipeer, id: \.id) { person in
                    
                    Text("\(person.name ?? "No name")")
                }
                
                
                    .onChange(of: multipeerDataSource.availablePeers) { peers in
                        
                        let idSet = NSCountedSet(array: (peers).map { $0.name }).allObjects as? [String] ?? []
                        
                        viewModel.fetchDataOfNearbyMultipeers(userIds: idSet)

                        
                    }
            }
                
            
           */
            
            
            

        }.onAppear {
            
            if  let me = Auth.auth().currentUser?.uid{
               try? beamsClient.addDeviceInterest(interest: me)
                
            }
         
            
            // Add the user to nearby whenever you receive a broadcast of a new user
            
            /*
            multipeerDataSource.transceiver.peerAdded = { peer in
                print("!Peer added ")
                broadcast(to: peer)
            }
             */
            
            // remove the user whenever he detaches
            
            
            /*
            multipeerDataSource.transceiver.peerRemoved = { peer in
                 
                print("!\(peer.name) removed")
                
                /*
                for user in viewModel.nearbyUsersByMultipeer{
                    
                    print("!Looping through nearbyusers on \(user.deviceID)")
                   
                    if user.deviceID == peer.name{
                        print("!removing .. \(peer.name)")
                        viewModel.nearbyUsersByMultipeer.remove(user)
                    }
                }
                */
            
            }
             */
            
            
            multipeerDataSource.transceiver.receive(UserDataToSend.self) { payload, sender in
                
                print("@Received data: \(payload) ")
                viewModel.nearbyUsersByMultipeer.insert(payload.userData)
                viewModel.nearby.append(payload.userData)
                
            
                //print("<!!the array is ... \(viewModel.nearbyUsersByMultipeer)")
                let content = UNMutableNotificationContent()
                content.body = "\(payload.id) is near you"
                let request = UNNotificationRequest(identifier: "newpeer", content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(request) { _ in

                        }
                
                
            }
            
            
            
        // broadcastToNearByUsers()
        
            
            
    }
        /*
        .onChange(of: mainViewModel.userData, perform: { newData in
            
           
            broadcastToNearByUsers()
        })
        */
        // Optimize later .. would much rather not broadcast every time this changes but no other solutions at the current moment. 
        .onChange(of: multipeerDataSource.availablePeers) { peers in
            
            print("new peer in array")
            // send notification when received
            let content = UNMutableNotificationContent()
            content.body = "Available peers did change"
            let request = UNNotificationRequest(identifier: "newpeer", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request) { _ in

                    }
            
            broadcastToNearByUsers()
          
        
        }
        
        
        /*
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { output in
            
            
            // broadcast user data
            
            AmareApp().delay(2) {
                
                broadcastToNearByUsers()
            }
            
           
        }
        */
      
        
       
        
       

    }
    
    /*
    func exampleUsageOfProfilePopup(<#parameters#>) -> <#return type#> {
        
        /*
         EXAMPLE USAGE OF PROFILE POPUP
        Button {
            print("subscribed to : \(Auth.auth().currentUser?.uid) ")
            
            let me = Auth.auth().currentUser?.uid
            
            /*
            viewModel.subscribeToUserDataChanges(for: Auth.auth().currentUser?.uid ?? "U214TAvtCsVUSxecjeoPl7cs8PW2")
            
            viewModel.subscribeToNatalChart(for: Auth.auth().currentUser?.uid ?? "U214TAvtCsVUSxecjeoPl7cs8PW2")
            */
            
            let will = "hcrmKaxcEcc8CqY4B6Uh5VGG7Yc2"
            let micheal = "u4uS1JxH2ZO8re6mchQUJ1q18Km2"
            
            let personWhoIsntMe = (me != will) ? will: micheal
            
            viewModel.load(user: personWhoIsntMe)
           
            
            AmareApp().delay(5) {
                print("Changing color..")
                
                viewModel.userData._synastryScore = 0.94
                
                
            
                
                
                
                
                
                
              
                
              
                
                withAnimation(.easeIn(duration: 3)){
                    // change color of aspect
                    viewModel.userData.natal_chart?.planets[0]._aspectThatExists = .trine
                }
                
                
                
                
            }
            
            
        } label: {
            Text("Subscribe")
        }
        
        ProfilePopup(user: $viewModel.userData)
             .opacity(viewModel.userData.isComplete() ? 1 : 0 )
            .hoverEffect()
        
        
        
        Button {
            
                
            viewModel.userData._synastryScore = Double.random(in: 0...1)
            
            viewModel.userData._chemistryScore = Double.random(in: 0...1)
            
            viewModel.userData._loveScore = Double.random(in: 0...1)
            
            viewModel.userData._sexScore = Double.random(in: 0...1)
            

        } label: {
            Text("Regenerate")
        }
        .opacity(0)
        .offset(x: 10, y: 20)
        
        */
    }
     
     */
    
    /// Will broadcast our user data to nearby users by multipeer. We do this so that other nearby users know that we are around
    func broadcastToNearByUsers()  {
        
        print("broadcasting to nearby users")
        guard mainViewModel.userData.isComplete() else { print("!No need to broadcast to all ... incomplete data"); return }
    
        //print("!!! Broadcasting this data .. \(mainViewModel.userData)")

        var data = UserDataToSend(userData: mainViewModel.userData, id: mainViewModel.userData.id!, chart: mainViewModel.userData.natal_chart)
        
        multipeerDataSource.transceiver.broadcast(data)
    }
    
    /// Broadcasts the signed in person's user data to a specific peer
    func broadcast(to: Peer)   {
        
        
        guard mainViewModel.userData.isComplete() else { print("!No need to broadcast // my data is incomplete"); return }
        
        print("!!! Broadcasting this data .. \(mainViewModel.userData)")
        multipeerDataSource.transceiver.send(mainViewModel.userData, to: [to])
    }
    
    
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}



struct UserDataToSend: Codable{
    var userData: AmareUser
    var id: String
    var chart: NatalChart?
    
   /* enum CodingKeys: String, CodingKey{
        case userData
        case id
        case chart 
    }*/
}
