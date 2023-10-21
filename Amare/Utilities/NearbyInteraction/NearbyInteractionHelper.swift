// Configuration
import Foundation
import SwiftUI
import NearbyInteraction
import Firebase
import FirebaseFirestore

struct NearbyInteractionConfig {
    static let nearbyDistanceThreshold: Float = 0.01
    static let facingAngleThreshold: Float = 5
    static let thresholdForIsThere: Float = 0.001
}





class NearbyInteractionHelper: NSObject, ObservableObject, NISessionDelegate{
    
    var testing: Bool = false
    
    // MARK: - @Published variables
    @Published var peersDiscoveryToken: DiscoveryTokenDocument? {
        didSet{
            if peersDiscoveryToken != nil {
                self.run()
            }
        }
    }
    
    /// Nearby objects connected to, will always contain most recent positional data regardless of whether or not we moved in/out threshold
    @Published var nearbyObject: NINearbyObject?
    
    /// Can be a `NearbyUserError` or a `NIError`or an error from Firestore
    @Published var someErrorHappened: Error? {
        
        didSet{
            if someErrorHappened == nil {
                didAnErrorHappen = false
            } else {
                // only disconnect if the error is NOT wrongOrientation
                if let _someErrorHappened = someErrorHappened as? NearbyUserError {
                    if _someErrorHappened != NearbyUserError.wrongOrientation { connected = false  }
                    
                    
                } else { connected = false }
                connected = false
                didAnErrorHappen = true
            }
        }
    }
    
    @Published var didAnErrorHappen: Bool = false
    
    
    @Published var trueDistance: Float?
    
    /// This distance only updates when the user moves within `threshold` amount. See `trueDistanceAway` for a realtime measure
    @Published var distanceAway: Float? {
        
        didSet{
            
            guard let previousDistanceReading = oldValue, let currentReading = distanceAway else {
                
                return
                
                
            }
            
            if previousDistanceReading > currentReading {
                // Moving towards because current reading is less
                
            
                isMovingTowards = true
            }
            
            else {
                
                // Moving away
                isMovingTowards = false
                
            }
            
            
            
            guard self.firstDistanceReading != nil else  { return self.distanceState = nil/*= DistanceState.farAway */}
             var currentDistanceAway = self.trueDistance
            
            guard currentDistanceAway != nil else { return self.distanceState =  nil/*DistanceState.farAway*/ }
             
             var fractionTraveled = abs(1 - (currentDistanceAway! / self.firstDistanceReading!))
             
            print("The fraction traveled ... \(fractionTraveled) ")
            if fractionTraveled >= 0.5 && fractionTraveled < 0.7 { self.distanceState =  DistanceState.halfwayThere}
             
            if fractionTraveled >= 0.7  && fractionTraveled < 1 { self.distanceState =  DistanceState.almostThere}
             
            if fractionTraveled < 0.5 { self.distanceState = DistanceState.farAway }
            
             
             
        }
    }
    
    /// In Radians. Azimuth angle
    @Published var direction: Float? {
        
        didSet{
            
            guard let direction = direction else { isFacing = false ; return }
            if abs(direction).isLessThanOrEqualTo(facingAngleThreshold) {
                isFacing = true
            } else {
                isFacing = false
            }
        }
    }
    
    /// In Radians. Polar angle
    @Published var altitude: Float?
    
    /// Whether or not user is connected to another peer for nearby interaction
    @Published var connected: Bool = false
    
    @Published var currentDistanceDirectionState: DistanceDirectionState = .unknown
    
    
    /// Whether or not user is moving towards the other use. Only updates whenever the user moves at least an amount by `threshold` otherwise this will just be nil
    @Published var isMovingTowards: Bool?
    
    /// Whether or not user is facing the user. If cannot determine, this is nil.
    @Published var isFacing: Bool?
    
    //MARK: - Device Orientation
    
    @Published var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation {
        didSet{
            self.properOrientation = deviceOrientation == UIDeviceOrientation.portrait
        }
    }
    
    @Published var properOrientation: Bool = UIDevice.current.orientation == .portrait {
        didSet{
            if self.properOrientation == false {
                someErrorHappened = NearbyUserError.wrongOrientation
            } else {
                if let someErrorHappened = someErrorHappened as? NearbyUserError {
                    
                    // Delete the error if the device is in proper orientation
                    if someErrorHappened == .wrongOrientation { self.someErrorHappened = nil }
                
                }
            }
        }
    }
    
    // MARK: - Distance and direction state.
    // A threshold, in meters, the app uses to update its display.
    private let nearbyDistanceThreshold: Float = 0.01 //0.1
    //TODO: - This threshold should depend on how far you are away; should be computed
    private let facingAngleThreshold: Float = 5
    private let thresholdForIsThere: Float = 0.001
    private var firstDistanceReading: Float?
    
    ///  How far away user is relatively speaking.
    public var distanceState: DistanceState? /* {
    
        guard self.firstDistanceReading != nil else  { return nil }
        var currentDistanceAway = self.trueDistance
        guard currentDistanceAway != nil else { return nil }
        
        var fractionTraveled = 1 - (currentDistanceAway! / self.firstDistanceReading!)
        
        if fractionTraveled >= 0.5 && fractionTraveled < 0.7 { return DistanceState.halfwayThere}
        
        if fractionTraveled >= 0.7  && fractionTraveled < 1 { return DistanceState.almostThere}
        
        return DistanceState.farAway
        
        return nil
} */
    


    // MARK: - Class variables
    /// Current user's discovery token
    private var discoveryTokenData: Data? {
        
    
    guard let token = sessionNI?.discoveryToken,
        let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            

            removeToken()
        
            return nil
    }
    return data
    }
    
    private var sessionNI: NISession? {
        if testing {
            return nil
        } else {
            return NISession()
        }
    }
    
    
    
    private var tokenListener: ListenerRegistration?  // Add this property to your class
    private var mytoken: DiscoveryTokenDocument?
    
    
    
    // Whether or not the user has reached the other user
     var isThere: Bool {
        
         if let distanceAway = self.distanceAway, let isFacing = self.isFacing {
            
             return distanceAway.isLessThanOrEqualTo(thresholdForIsThere) && isFacing
        }
         
         return false
    }


    //MARK: - Constructor
    override init() {
        super.init()
        
        setup()
    }
    
    private func setup(){
        guard NISession.isSupported else {
            someErrorHappened = NIError(.unsupportedPlatform)
            
            // TODO: Let the other user know it's unsupported
            return
        }
        
        // TODO: You might need to add an error to `someErrorHappened` here. Not sure yet.
        guard let sessionNI = sessionNI else { return }
    
        sessionNI.delegate = self
        
        //TODO: Would an @Published work better for this?
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        
        listenForPeerToken()
        
    }
    
    //MARK: - Life Cycle for Nearby Interaction Session
    
    /// Adds the discovery token in the database so that the other use can read it
    ///   /discoveryTokens/{THEM - document containing token info with ID of `THEM`}/
    ///   - Parameters:
    ///       - userID: The user id of the user that you are sending the discovery token to
    ///   - Warning: Possible security weakness since this requires any signed in user to be able to read/write to this path
    

    func sendToken(them userId: String) {
        guard NISession.isSupported else {
            self.someErrorHappened = NIError(.unsupportedPlatform)
            return
        }
       
        // Create the token document
        let token = DiscoveryTokenDocument(id: userId, dateCreated: Timestamp(date: Date()), token: discoveryTokenData, deviceSupportsNI: NISession.isSupported)
        self.mytoken = token
        
        // Get Firestore instance and specify the collection and document
        let db = Firestore.firestore()
        let docRef = db.collection("discoveryTokens").document(userId)
        
        // Set the data
        do {
            try docRef.setData(from: token) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("NI Token Error writing document: \(error)")
                    self.someErrorHappened = error
                } else {
                    print("NI Token Document successfully written!")
                }
            }
        } catch {
            print("Error setting data: \(error)")
            self.someErrorHappened = error
        }
    }

    
    
    /// This runs the session for nearby interaction and should run after the peer discovery token is received
    private func run(){
        
        
        // Make sure the peer's device is supported
        
        guard peersDiscoveryToken?.deviceSupportsNI == true else {
            self.someErrorHappened = NearbyUserError.theirDeviceIsntSupported
            return
        }
        
        // Ensure we have a discovery token
        guard let theirDiscoveryToken = peersDiscoveryToken?.token else {
            self.someErrorHappened = NearbyUserError.noDiscoveryToken
            return
        }
        
        
        // Ensure we can decode the token
        guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: theirDiscoveryToken) else {
            self.someErrorHappened = NearbyUserError.cantDecodeTheirDiscoveryToken
            return
            }
        
        let config = NINearbyPeerConfiguration(peerToken: token)
        print("making config for it with token \(token)")
        sessionNI?.run(config)
        
        
    }
    
    /// Listen for tokens that peers sent to me. This document id should equal the id of the current signed in user.
    private func listenForPeerToken() {
        print("listen for peer token")
        guard let me = Auth.auth().currentUser?.uid else {
            self.someErrorHappened = AccountError.notSignedIn
            return
        }

        let db = FirestoreService.shared.db
        let docRef = db.collection("discoveryTokens").document(me)
        print("listening at ... discoveryTokens/\(me)")
        // Listen for changes
        tokenListener = docRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            
            // Check for network errors
            if let error = error {
                print("Error fetching document: \(error)")
                self.someErrorHappened = NearbyUserError.noDiscoveryToken
                return
            }
            
            // Check if document actually exists
            if !documentSnapshot!.exists {
                print("Document does not exist") // can still be waiting for token... listening
                //self.someErrorHappened = NearbyUserError.noDiscoveryToken
                return
            }

            do {
                let tokenDoc = try documentSnapshot!.data(as: DiscoveryTokenDocument.self)
                print("Listening for peer token.. got \(String(describing: tokenDoc))")
                self.peersDiscoveryToken = tokenDoc
            } catch {
                print("Error decoding token: \(error)")
                self.someErrorHappened = NearbyUserError.cantDecodeTheirDiscoveryToken
            }
        }

    }
    
    func stopListeningForPeerToken()  {
        sessionNI?.invalidate()
        tokenListener?.remove()
        removeToken()
        stopListeningForOrientationChange()
        
    }
    
 

    private func removeToken() {
        guard let doc = mytoken, let docID = doc.id else { return }
        
        let db = Firestore.firestore()
        db.collection("discoveryTokens").document(docID).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                self.someErrorHappened = error
            } else {
                print("Document successfully removed!")
            }
        }
        
        mytoken = nil
    }


    
    //MARK: - Listening to Nearby Object
  
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        
        print("calling session (_ session: ")
        
        

        guard let nearbyObjectUpdate = nearbyObjects.first else { return }
        
        print("azimuth: \(nearbyObjectUpdate.direction) ")
        
        
        self.connected = true
        self.trueDistance =  nearbyObjectUpdate.distance
        
        
        //MARK: - Reading old positional data
        
        if self.firstDistanceReading == nil  { self.firstDistanceReading = nearbyObjectUpdate.distance }
        
        // Before update (old distance and old direction state)
        let old_distance = self.distanceAway
        let old_direction_state = getDistanceDirectionState(from: self.nearbyObject)
        
        //MARK: - Reading the new positional data
        let new_distance = nearbyObjectUpdate.distance
        let new_direction_state = getDistanceDirectionState(from: nearbyObjectUpdate)
        
        
         
        
        
        // Check if device is moving towards or away
        //MARK: - Check if first reading
        
        guard old_distance != nil && new_distance != nil else {
            
            //MARK: - First reading
            print("First reading")
            self.nearbyObject = nearbyObjects.first
            self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
            self.distanceAway = nearbyObjects.first?.distance
            
            
        
            
            // Angle at which peer is located
            let azimuth = nearbyObjectUpdate.direction.map(azimuth(from:))
            
            self.direction = azimuth
            
            
            //TODO: - If trueDistance is within the threshold, we should now just check
            return
            
            
        }
        
        // Update nearby object regardless to get most recent reading
        //MARK: - Detect if moving towards/backwards
        
        // Make sure we're at least `threshold` distance away from previous reading before updating
        
        let distance_moved = abs(new_distance! - old_distance!)
        
        guard distance_moved >= nearbyDistanceThreshold else {
            // No need to update distance because we haven't moved but we can update the direction
            self.direction = nearbyObjectUpdate.direction.map(azimuth(from:))
            self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
            return
        }
        
        
        //MARK: - Updating distance and direction
        self.distanceAway = new_distance
        self.direction = nearbyObjectUpdate.direction.map(azimuth(from:))
        self.currentDistanceDirectionState = getDistanceDirectionState(from: nearbyObjectUpdate)
        
        
    }
    
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        session.invalidate()
        self.connected = false
        
        //TODO: Need ot understand why i had this commented o ut before so if it's not working maybe look at this
        if reason ==  NINearbyObject.RemovalReason.peerEnded {
            self.someErrorHappened = NearbyUserError.outOfRange
        }
        
        if reason == NINearbyObject.RemovalReason.timeout{
            self.someErrorHappened = NearbyUserError.timeout
        }
        
        
    }

    func sessionWasSuspended(_ session: NISession) {
        
        self.connected = false
        self.someErrorHappened = NearbyUserError.disconnected
        removeToken()
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        self.someErrorHappened = error
        self.connected = false
        removeToken()
    }
    
    
    
    //MARK: - Device Orientation
    
    /// We need to observe the device orientation to make sure it's upright for NI to work right
    @objc private func orientationChanged()  {
        
        self.deviceOrientation = UIDevice.current.orientation
        
    }
    
    
    private func stopListeningForOrientationChange(){
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
    }
    
    
    // MARK: - Visualizations
    
    
    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }
    
    /*
    
    func isPointingAt(_ angleRad: Float) -> Bool {
        // Consider the range -15 to +15 to be "pointing at".
        return abs(angleRad.radiansToDegrees) <= 15
    }
    
    */
    func getDistanceDirectionState(from nearbyObject: NINearbyObject?) -> DistanceDirectionState {
        
        guard let nearbyObject = nearbyObject else { return .unknown}
        if nearbyObject.distance == nil && nearbyObject.direction == nil {
            return .unknown
        }

        let isNearby = nearbyObject.distance.map(isNearby(_:)) ?? false
        let directionAvailable = nearbyObject.direction != nil

        if isNearby && directionAvailable {
            return .closeUpInFOV
        }

        if !isNearby && directionAvailable {
            return .notCloseUpInFOV
        }

        return .outOfFOV
    }

}

