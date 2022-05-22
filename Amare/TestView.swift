//
//  TestView.swift
//  Amare
//
//  Created by Micheal Bingham on 1/19/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import PushNotifications
import MultipeerKit
import SPIndicator
class TestViewModel: ObservableObject{
    
    
    
    //@Published var userData: AmareUser?
    
    @Published var selectedUser: AmareUser? {
        didSet{
            if let _ = self.selectedUser {
                errorLoadingUser = nil
            }
            
            if let _ = self.selectedUser?.natal_chart {
                errorLoadingChart = nil
            }
            
            if let areFriends = self.selectedUser?.areFriends {
                errorLoadingFriendship = nil
                
                if oldValue?.areFriends == false && areFriends {
                    self.unsubscribeToNatalChart()

                    self.subscribeToNatalChart(for: self.selectedUser?.id)
                }
            }
            
        }
    }
    
    
    
    /// See    `AccountErrors` and `GlobalErrors`. If not authorized, usually because they are not friends
    @Published var errorLoadingUser: Error? {
        didSet {
            if let _ = self.errorLoadingUser{
                
                errorLoadingUserHappened = true
                selectedUser = nil
            }
            
        }
    }
    
    /// See    `AccountErrors` and `GlobalErrors`. If not authorized, usually because they are not friends
    @Published var errorLoadingChart: Error? {
        didSet {
            if let _ = self.errorLoadingChart {
                
                errorLoadingChartHappened = true
                selectedUser?.natal_chart = nil
            }
        }
    }
    
//TODO: Document errors here
    /// See    `AccountErrors` and `GlobalErrors`. If not authorized, usually because they are not friends
    /// TODO: Document errors
    @Published var errorLoadingFriendship: Error? {
        
        didSet{
            if let _ = self.errorLoadingFriendship {
                errorLoadingFriendshipHappened = true
                self.selectedUser?.areFriends = nil
            }
        }
        
    }
    
    
    //TODO: Document errors here
        /// See    `AccountErrors` and `GlobalErrors`. If not authorized, usually because they are not friends
        /// TODO: Document errors
        @Published var errorLoadingWinkedAtStatus: Error? {
            
            didSet{
                if let _ = self.errorLoadingWinkedAtStatus {
                    errorLoadingWinkingHappened = true
                    self.selectedUser?.winkedAtMe = nil
                }
            }
            
        }
    
    //TODO: Document errors here
        /// See    `AccountErrors` and `GlobalErrors`. If not authorized, usually because they are not friends
        /// TODO: Document errors
        @Published var errorLoadingWinkedToStatus: Error? {
            
            didSet{
                if let _ = self.errorLoadingWinkedToStatus {
                    errorLoadingWinkingHappened = true
                    self.selectedUser?.winkedTo = nil
                }
            }
            
        }
    
    
    @Published var errorLoadingUserHappened: Bool = false
    @Published var errorLoadingChartHappened: Bool = false
    @Published var errorLoadingFriendshipHappened: Bool = false
    @Published var errorLoadingWinkingHappened: Bool = false
    @Published var errorSearchingHappened: Bool = false
    
    @Published var nearbyUsersByMultipeer =  Set<AmareUser>()
    @Published var searchedUsers : [AmareUser] = []
    
    @Published var customUsers: [AmareUser] = []
    
    
    // @Published computed variables are unreliable so we do this to so that the `allNearbyUsers` array has the proper value
   // private var subscriptions = Set<AnyCancellable>()


    
    public var allNearbyUsers: [AmareUser] {
       Array( nearbyUsersByMultipeer)
    }

    
    
    /// Will be true if the user has incomplete data in the database so some error happened during account creation/signup process so sign the user out if this happens so they can resign up.
   // @Published var inCompleteData: Bool = false
    
    private var db = Firestore.firestore()
    
    
    private var userDataSnapshotListener: ListenerRegistration?
    
    private var natalChartListener: ListenerRegistration?
    
    private var myFriendsListener: ListenerRegistration?

    private var requestsListener: ListenerRegistration?
    
    private var openFriendRequestsListener: ListenerRegistration?
    

    private var winkStatusListener: ListenerRegistration?
    
    private var winkStatusAtMeListener: ListenerRegistration?
    
    private var usernameQuery : ListenerRegistration?
    
    @Published var searchError: Error? {
        
        didSet{
            
            if let _ = searchError {
                errorSearchingHappened = true
            }
            
        }
    }
    
    
    /*
    init() {
        
        subscribeToUserDataChanges()
    }
    */
    
    
    // Query users by //
    func search(for username: String)  {
        
        db.collection("usernames")
            .whereField("username", isGreaterThanOrEqualTo: username)
            .addSnapshotListener { snapshot, error in
                
                guard error == nil else {
                    self.searchError = error!
                    return 
                }
                
               
                var users: [AmareUser] = []
                for document in snapshot!.documents{
             
                    let result = Result {
                        try document.data(as: AmareUser.self)
                    }
                    
                    switch result {
                    
                    
                    case .success(var user):
                        
                        if  user != nil{
                            user.id = document.data()["userId"] as? String
                            
                            
                            if user.id != Auth.auth().currentUser?.uid {
                                users.append(user)
                            }
                            
                            self.searchedUsers = users

                            
                            
                        } else{
                            
                            // Could not retreive the data for some reason
                            self.searchError = GlobalError.unknown
                            return
                        }
                        
                    
                    case .failure(let error):
                        // Handle errors
                        self.searchError = error
                        continue
                      //  return
                  
                    }

                    
                }
             
                
                
                
            }
    }
    
    
    /// Subscribes to real-time data for user of this user // their natal chart, user data infromation, wink/friendship status
    func load(user id: String)   {
        
        self.subscribeToUserDataChanges(for: id)
        self.subscribeToNatalChart(for: id)
        self.subscribeToFriendshipStatus(them: id)
        self.subscribeToWinkStatus(them: id)
        
    }
   
    /// Subscribes to changes to the given user with `id`
    private func subscribeToUserDataChanges(for id: String? )  {
        
        if let id = id{
            
       
            
            userDataSnapshotListener  =  db.collection("users").document(id).addSnapshotListener { snapshot, error in
                
              
                
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    self.errorLoadingUser = AccountError.doesNotExist
                  //  self.selectedUser = nil
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: AmareUser.self)
                }
                
                switch result {
                case .success(let success):
                  
                    
                    
                    if var data = success { data.id = id ; self.selectedUser = data }
                    
                    
                    // check if the user data is complete
                    if let isComplete = success?.isComplete() {
                       // complete data
                        self.errorLoadingUser = nil
                    }  else {
                        self.errorLoadingUser = AccountError.doesNotExist
                       // self.selectedUser = nil
                    }
                    
                   
                    
                case .failure(let failure):
					
					if let error = FirestoreErrorCode(rawValue: failure._code){
                        
                        
                        
                        switch error {
                        case .permissionDenied:
                            self.errorLoadingUser = AccountError.notAuthorized
                        case .unauthenticated:
                            self.errorLoadingUser = AccountError.notAuthorized
                    
                        default:
                            self.errorLoadingUser = GlobalError.unknown
                        }
                        
                        
                    } else {
                        self.errorLoadingUser = GlobalError.unknown
                    }
                  
                    
                }
                
            }
            
        }
       
        
    }
    
    
    

    /// Subscribes to changes to the given user with `id`
    /// - Parameters:
    ///   - id: Id of the user
    ///   - isOuterChart: Default `false`. Set to `true` if this user should be the outer chart when doing synastry
    ///   - completion: Passing the error and the natal chart in this completion block. Will also be publisehd to the view model
     private func subscribeToNatalChart(for id: String?, isOuterChart: Bool = false, completion: ( (_ err: Error?, _ natalChart: NatalChart?) -> Void)?  = nil )  {
        
        // // \\ \\ // \\ // \\ // \\ // \\ // \\
        if let id = id{
            
            natalChartListener  =  db.collection("users").document(id).collection("public").document("natal_chart")
                .addSnapshotListener {   snapshot, error in
                
                    print("$Trying to get natal chart with error \(error) and data \(snapshot?.data())")
                
                    guard error == nil else{
                        // Handle these errors....
                        
                        if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                            
                            switch error {
                                
                                // Handle Global Errors
                            case .networkError:
                                self.errorLoadingChart = GlobalError.networkError
                                completion?(GlobalError.networkError, nil )
                            case .tooManyRequests:
                                self.errorLoadingChart = GlobalError.tooManyRequests
                                completion?(GlobalError.tooManyRequests, nil )
                            case .captchaCheckFailed:
                                self.errorLoadingChart = GlobalError.captchaCheckFailed
                                completion?(GlobalError.captchaCheckFailed, nil )
                            case .quotaExceeded:
                                self.errorLoadingChart = GlobalError.quotaExceeded
                                completion?(GlobalError.quotaExceeded, nil )
                            case .operationNotAllowed:
                                self.errorLoadingChart = AccountError.notAuthorized
                                completion?(GlobalError.notAllowed, nil )
                            case .internalError:
                                self.errorLoadingChart = GlobalError.internalError
                                completion?(GlobalError.internalError, nil )
                                
                                // Handle Account Errors
                            case .expiredActionCode:
                                self.errorLoadingChart = AccountError.expiredActionCode
                                completion?(AccountError.expiredActionCode, nil )
                            case .sessionExpired:
                                self.errorLoadingChart = AccountError.sessionExpired
                                completion?(AccountError.sessionExpired, nil )
                            case .userTokenExpired:
                                self.errorLoadingChart = AccountError.userTokenExpired
                                completion?(AccountError.userTokenExpired, nil )
                            case .userDisabled:
                                self.errorLoadingChart = AccountError.disabledUser
                                completion?(AccountError.disabledUser, nil )
                            case .wrongPassword:
                                self.errorLoadingChart = AccountError.wrong
                                completion?(AccountError.wrong, nil )
                            default:
                                self.errorLoadingChart = GlobalError.unknown
                                completion?(GlobalError.unknown, nil )
                            }
                            
                           return
                            
                        } else{
                            
                            self.errorLoadingChart = GlobalError.unknown
                            completion?(GlobalError.unknown, nil )
                            return
                        }
                    
                        
                        
                        
                    }
                    
                    
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    self.errorLoadingChart = AccountError.doesNotExist
                    completion?(AccountError.doesNotExist, nil)
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: NatalChart.self)
                }
                
                switch result {
                case .success(let success):
                    
                    
                    print("SOME SUCCESS WITH THE NATAL CHART")
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
                        
                        self.selectedUser?.natal_chart = data
                      //  not needed  self.errorLoadingChart = nil
                        
                        
     
                        
                        // /// / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / /// / // /
                        
                        
                        
                        
                        completion?(nil, data)
                        
                        
                    } else{
                        
                        // Could not retreive the data for some reason
                        self.errorLoadingChart = AccountError.doesNotExist
                        completion?(AccountError.doesNotExist, nil )
                    }
                    
                case .failure(let failure):
                    
                    
                    
					if let error = FirestoreErrorCode(rawValue: failure._code){
                        
                        
                        
                        switch error {
                        case .permissionDenied:
                            self.errorLoadingChart = AccountError.notAuthorized
                        case .unauthenticated:
                            self.errorLoadingChart = AccountError.notAuthorized
                    
                        default:
                            self.errorLoadingChart = GlobalError.unknown
                        }
                        
                        
                        
                    } else {
                        self.errorLoadingChart = GlobalError.unknown
                    }
                   
                    completion?(failure, nil)
                    
                }
                
            }
            
        }
       
        
    }
    
    // Unsubscribes to the natal chart listener. We unsubscribe whenever the friendship status changes because we need to reattach this listener whenever the friendship status changes otherwise it won't instantly be called when the data updates, I guess security rules don't always work in realtime. 
    private func unsubscribeToNatalChart()  {
        print("%just unsubscribed to natal chart")
        natalChartListener?.remove()
    }
    
/*

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
    
    */
    /// Subscribes to updates to the friendship status; i.e. this is called to see if the user  `userData.id` is friends with the current signed in user. Will also check if there is an open friend request.
    //TODO: Error handling for subscribing to friendship status
    private func subscribeToFriendshipStatus(them: String)  {
        
        if let me = Auth.auth().currentUser?.uid {
            
            myFriendsListener =  db.collection("friends").document(me).collection("myFriends").document(them)
                .addSnapshotListener({ snapshot, error in
                    
                    guard error == nil else {
                        self.errorLoadingFriendship = error
                        return
                    }
                    
                    if snapshot?.exists ?? false {
                        // friends already
                        self.selectedUser?.areFriends = true
                    
                    } else {
                        
                        self.selectedUser?.areFriends = false
                        
                       
                    }
                })

           requestsListener = db.collection("friends").document(them).collection("requests").document(me).addSnapshotListener({ snapshot, error in
               
               print("!Subscribing to requests : \(snapshot) with error \(error)")

               guard error == nil else {
                   self.errorLoadingFriendship = error
                   return
               }
               
                if snapshot?.exists ?? false {
                    // There is a friend request there that I sent to this user
                    let didAccept: Bool  = snapshot?.data()?["accepted"] as? Bool ?? false
                   
                    self.selectedUser?.requested = !didAccept
  
                    
                }  else {
                    // there is most definitely no friend pending
                    self.selectedUser?.requested = false

                }
            })
            
            
            openFriendRequestsListener = db.collection("friends").document(me).collection("requests").document(them).addSnapshotListener({ snapshot, error in
                    
                print("!Subscribing to requests2 : \(snapshot) with error \(error)")

                    if snapshot?.exists ?? false {
                        // They sent me (current signed in user) a friend request
                       
                      
                        self.selectedUser?.openFriendRequest = true
                        
                        
                        
                    }  else {
                        // They did not send me a freind request
                      
                        self.selectedUser?.openFriendRequest = false
                        
                       
                    }
                })
            
            
        }
        
        else {
            self.errorLoadingFriendship = AccountError.notSignedIn
        }
    }
    
    
    /// Subscribes to updates to whether or not we've winked at each other
    private func subscribeToWinkStatus(them: String)   {
        
        guard  let me = Auth.auth().currentUser?.uid else {return }
        
        winkStatusListener = db.collection("winks").document(them).collection("people_who_winked").document(me).addSnapshotListener({ snapshot, error in
            
            guard error == nil else{
                // Handle these errors....
                
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        self.errorLoadingWinkedToStatus = GlobalError.networkError
                    case .tooManyRequests:
                        self.errorLoadingWinkedToStatus = GlobalError.tooManyRequests
                    case .captchaCheckFailed:
                        self.errorLoadingWinkedToStatus = GlobalError.captchaCheckFailed
                    case .quotaExceeded:
                        self.errorLoadingWinkedToStatus = GlobalError.quotaExceeded
                    case .operationNotAllowed:
                        self.errorLoadingWinkedToStatus = AccountError.notAuthorized
                    case .internalError:
                        self.errorLoadingWinkedToStatus = GlobalError.internalError
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        self.errorLoadingWinkedToStatus = AccountError.expiredActionCode
                    case .sessionExpired:
                        self.errorLoadingWinkedToStatus = AccountError.sessionExpired
                    case .userTokenExpired:
                        self.errorLoadingWinkedToStatus = AccountError.userTokenExpired
                    case .userDisabled:
                        self.errorLoadingWinkedToStatus = AccountError.disabledUser
                    case .wrongPassword:
                        self.errorLoadingWinkedToStatus = AccountError.wrong
                    default:
                        self.errorLoadingWinkedToStatus = GlobalError.unknown
                    }
                    
                   return
                    
                } else{
                    
                    self.errorLoadingWinkedToStatus = GlobalError.unknown
                    return
                }
            
                
                
                
            }
            
           
            
            if snapshot?.exists ?? false {
                
                    
                self.selectedUser?.winkedTo = true
                
               
            } else {
                self.selectedUser?.winkedTo = false
            }
        })
        
        
        winkStatusAtMeListener = db.collection("winks").document(me).collection("people_who_winked").document(them).addSnapshotListener({ snapshot, error in
            
            guard error == nil else{
                // Handle these errors....
				
				
				
                if let error = AuthErrorCode(rawValue: error?._code ?? 17999){
                    
                    switch error {
                        
                        // Handle Global Errors
                    case .networkError:
                        self.errorLoadingWinkedAtStatus = GlobalError.networkError
                    case .tooManyRequests:
                        self.errorLoadingWinkedAtStatus = GlobalError.tooManyRequests
                    case .captchaCheckFailed:
                        self.errorLoadingWinkedAtStatus = GlobalError.captchaCheckFailed
                    case .quotaExceeded:
                        self.errorLoadingWinkedAtStatus = GlobalError.quotaExceeded
                    case .operationNotAllowed:
                        self.errorLoadingWinkedAtStatus = AccountError.notAuthorized
                    case .internalError:
                        self.errorLoadingWinkedAtStatus = GlobalError.internalError
                        
                        // Handle Account Errors
                    case .expiredActionCode:
                        self.errorLoadingWinkedAtStatus = AccountError.expiredActionCode
                    case .sessionExpired:
                        self.errorLoadingWinkedAtStatus = AccountError.sessionExpired
                    case .userTokenExpired:
                        self.errorLoadingWinkedAtStatus = AccountError.userTokenExpired
                    case .userDisabled:
                        self.errorLoadingWinkedAtStatus = AccountError.disabledUser
                    case .wrongPassword:
                        self.errorLoadingWinkedAtStatus = AccountError.wrong
                    default:
                        self.errorLoadingWinkedAtStatus = GlobalError.unknown
                    }
                    
                   return
                    
                } else{
                    
                    self.errorLoadingWinkedAtStatus = GlobalError.unknown
                    return
                }
            
                
                
                
            }
            if snapshot?.exists ?? false {
                
                    
                self.selectedUser?.winkedAtMe = true
                
               
            } else {
                self.selectedUser?.winkedAtMe = false
            }
        })
    
    

    }
    
    
    
    

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
    
    
    func getAllCustomUsers()  {
        
        db.collection("users")
            .whereField("isReal", isEqualTo: false)
            .getDocuments { snapshot, error in
                
                guard error == nil else {
                    self.searchError = error!
                    return
                }
                
               
                var users: [AmareUser] = []
                for document in snapshot!.documents{
             
                    let result = Result {
                        try document.data(as: AmareUser.self)
                    }
                    
                    switch result {
                    
                    
                    case .success(var user):
                        
                        if  user != nil {
                            user.id = document.documentID
                            
                      
                            if user.id != Auth.auth().currentUser?.uid {
                                users.append(user)
                            }
                            
                            self.customUsers = users

                            
                            
                        } else{
                            
                            // Could not retreive the data for some reason
                            self.searchError = GlobalError.unknown
                            return
                        }
                        
                    
                    case .failure(let error):
                        // Handle errors
                        self.searchError = error
                        continue
                      //  return
                  
                    }

                    
                }
             
                
                
                
            }
    }

    
    
    
}



struct TestView: View {
    

    /// View model for the current signed in user's realtime data.
    @EnvironmentObject var mainViewModel: UserDataModel
    
    /// View model for nearby users and other data that populates this view
    @StateObject var viewModel: TestViewModel = TestViewModel()
    
    
    
    
    let beamsClient = PushNotifications.shared
    
    

    @State var showingPopup = true
   
    /// For detecting nearby users
    @EnvironmentObject var multipeerDataSource: MultipeerDataSource

    
    @State var showProfile: Bool = false
    // Consider Adding elsewhere
    
 
    // For the searching other users part
    
    // Search string to use in the search bar
        @State var searchString = ""
        
        // Search action. Called when search key pressed on keyboard
        func search() {
            
            viewModel.search(for: searchString)
        }
        
        // Cancel action. Called when cancel button of search bar pressed
        func cancel() {
        
            AmareApp().dismissKeyboard {
                
            }
        }
    
    
    let testUsers = ["u4uS1JxH2ZO8re6mchQUJ1q18Km2", "hcrmKaxcEcc8CqY4B6Uh5VGG7Yc2"]
  
    

    
    
    var body: some View {
        
        
        
       
        
        
        
        ZStack{
            
            
     
                
              
    
                    
                    VStack{
                        
                        
                      
              
                        // Nearby users testing out
                        SearchNavigation(text: $searchString, search: search, cancel: cancel) {
                            
                            List{
                                
                                Section(header: Text("Nearby Users")){
                                    
                                    ForEach(viewModel.allNearbyUsers){ person in
                                        
                                        
                                        
                                        Button {
                                            
                                            
                                        withAnimation {
                                                viewModel.selectedUser = person
                                            showProfile = true
                                            }
                                            
                                          
                                            
                                            
                                            
                                        } label: {
                                            
                                            Text(person.name ?? "No name")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                       .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        /*  .onTapGesture {
                                            viewModel.selectedUser = person
                                        showProfile = true
                                        }
                                        */
                                    }
                                }
                                
                                
                                
                                Section(header: Text("Searched Users")){
                                    
                                    ForEach(viewModel.searchedUsers, id: \.self) {  user in
                                        
                                        Button {
                                            
                                            withAnimation {
                                                   
                                                viewModel.load(user: user.id ?? "")
                                                cancel()
                                                showProfile = true
                                                }
                                            
                                        } label: {
                                            
                                            Text("\(user.username ?? "No Name")")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                       .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                }
                                
                                Section(header: Text("Custom Users")){
                                    
                                    ForEach(viewModel.customUsers, id: \.self) {  user in
                                        
                                        Button {
                                            
                                            withAnimation {
                                                   
                                                viewModel.load(user: user.id ?? "")
                                                cancel()
                                                showProfile = true
                                                }
                                            
                                        } label: {
                                            
                                            Text("\(user.name ?? "No Name")")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                       .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
                                }

                            }
                        }
                        .onChange(of: searchString) { words in
                            viewModel.search(for: words)
                        }
                        
                        
                    }
                   
                    
                    
                   
                   
                   

                  
                    /*
            ProfilePopup(user: Binding<AmareUser>($viewModel.selectedUser) ?? .constant(AmareUser()))
                .opacity(showProfile ? 1: 0)
                */
           
            

           
            
            
            

        }
        
        
        /*
        .SPIndicator(isPresent: $viewModel.errorLoadingChartHappened, title: "Chart Error", message: "\(viewModel.errorLoadingChart)", duration: 2.0, presentSide: .top, dismissByDrag: true, preset: .error, haptic: .error, layout: SPIndicatorLayout.init(iconSize: CGSize(width: 15, height: 15), margins: UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(30), bottom: CGFloat(0), right: CGFloat(0))))
        
        .SPIndicator(isPresent: $viewModel.errorLoadingUserHappened, title: "Loading User Error"/*, message: "\(viewModel.errorLoadingUser)"*/, duration: 2.0, presentSide: .top, dismissByDrag: true, preset: .error, haptic: .error, layout: .init())
        
        .SPIndicator(isPresent: $viewModel.errorLoadingWinkingHappened, title: "Wink Error"/*, message: "\(viewModel.errorLoadingWinkedAtStatus)"*/, duration: 2.0, presentSide: .top, dismissByDrag: true, preset: .error, haptic: .error, layout: .init())
        
        .SPIndicator(isPresent: $viewModel.errorLoadingFriendshipHappened, title: "Friendship Error"/*, message: "\(viewModel.errorLoadingFriendship)"*/, duration: 2.0, presentSide: .top, dismissByDrag: true, preset: .error, haptic: .error, layout: .init())
        
        */
        
        
        
        
        /*
        .sheet(isPresented: $showProfile, content: {
            
            
    ProfilePopup(user: Binding<AmareUser>($viewModel.selectedUser) ?? .constant(AmareUser()))
        .opacity(showProfile ? 1: 0)
        
        })
        
        */
        
        
       
        /*
         
         I would much rather have this; however, it causes a bug in the UI when I use a popup view for Profilepopup
        */
        .popup(isPresented: $showProfile , closeOnTap: false, closeOnTapOutside: false, dismissCallback: {
            
            withAnimation {
                //viewModel.selectedUser = nil
            }
            
        }, view: {
            
      
              
                ProfilePopup(user: Binding<AmareUser>($viewModel.selectedUser) ?? .constant(AmareUser()))
                    .opacity(showProfile ? 1: 0)
                  
                    
            
        })
        
        
        /*
        .sheet(isPresented: $showProfile, content: {
            
         
                ProfilePopup(user: Binding<AmareUser>($viewModel.selectedUser) ?? .constant(AmareUser()))
                    .opacity(showProfile ? 1: 0)
                    
            
            
            
        })
        */
        
        
        
        .onAppear {
            
            //viewModel.getAllCustomUsers()
            
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
            
            
            
            multipeerDataSource.transceiver.peerRemoved = { peer in
                 
                
                
                for user in viewModel.nearbyUsersByMultipeer{
                    
                    print("!Looping through nearbyusers on \(user.deviceID)")
                   
                    if user.deviceID == peer.name{
                        print("!removing .. \(peer.name)")
                        viewModel.nearbyUsersByMultipeer.remove(user)
                        
                        /*
                        let content = UNMutableNotificationContent()
                        content.body = "\(user.name) removed"
                        let request = UNNotificationRequest(identifier: "lesspeer", content: content, trigger: nil)
                                UNUserNotificationCenter.current().add(request) { _ in

                                }
                        
                        */

                        
                    }
                }
                
            
            }
             
            
            
            multipeerDataSource.transceiver.receive(UserDataToSend.self) { payload, sender in
                
                //payload.userData.id = payload.id
                var data =   payload.userData
                data.id = payload.id
                data.natal_chart = payload.chart
                data.deviceID = payload.deviceID
                data.image = payload.profileImage
                data.isNearby = true 
                
         
            
                viewModel.nearbyUsersByMultipeer.insert(data)
                
                
            
                //print("<!!the array is ... \(viewModel.nearbyUsersByMultipeer)")
                
                /*
                let content = UNMutableNotificationContent()
                content.body = "\(payload.userData.name ?? "no name") is near you"
                let request = UNNotificationRequest(identifier: "newpeer", content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(request) { _ in

                        }
                
                */
                
                
            }
            
            
            
         broadcastToNearByUsers()
        
            
            
    }
        
        
        .onChange(of: mainViewModel.userData, perform: { newData in
            
           
            broadcastToNearByUsers()
        })
        
        
        
        // Optimize later .. would much rather not broadcast every time this changes but no other solutions at the current moment. 
        .onChange(of: multipeerDataSource.availablePeers) { peers in
            
            print("new peer in array")
            // send notification when received
            /*
            let content = UNMutableNotificationContent()
            content.body = "Available peers did change"
            let request = UNNotificationRequest(identifier: "newpeer", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request) { _ in

                    }
            */
            
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
        

    
    /// Will broadcast our user data to nearby users by multipeer. We do this so that other nearby users know that we are around
    func broadcastToNearByUsers()  {
        
        print("broadcasting to nearby users")
        guard mainViewModel.userData.isComplete() else { print("!No need to broadcast to all ... incomplete data"); return }
    
        //print("!!! Broadcasting this data .. \(mainViewModel.userData)")

        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else { return }
                
        var data = UserDataToSend(userData: mainViewModel.userData, id: mainViewModel.userData.id!, chart: mainViewModel.userData.natal_chart, deviceID: deviceID, profileImage: nil)
        
        
        
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
            .environmentObject(UserDataModel())
            .environmentObject(MultipeerDataSource(transceiver: MultipeerTransceiver()))
    }
}



struct UserDataToSend: Codable{
    var userData: AmareUser
    var id: String
    var chart: NatalChart?
    var deviceID: String
    var profileImage: Data?
   /* enum CodingKeys: String, CodingKey{
        case userData
        case id
        case chart 
    }*/
}


struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}












// For Search Navigation

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>, searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
    
}
