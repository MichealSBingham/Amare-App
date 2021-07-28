//
//  FromWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit
import NavigationStack

@available(iOS 15.0, *)
struct FromWhereView: View {
    
    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel

    
    /// id of view
    static let id = String(describing: Self.self)
    
    @EnvironmentObject private var account: Account
    
    @State private var searchedLocation: String = ""
    
    /// Returned locations from when the user attempted to search for their location (Using natural language)
    @State private var citiesSearchResult: [MKMapItem] = []
    
    @State private var goToNext: Bool = false 
    
    
    @State var timezone: TimeZone?
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    
    @State private var beginAnimation: Bool = false
    @State private var go: Bool = false


    
    var body: some View {
        
      
            
        NavigationStackView(FromWhereView.id) {
            ZStack{
                    
                    
                
                    
                    
                    let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
                    
                    
                    MapViewUIKit(region: region, mapType: .hybridFlyover)
                                    .edgesIgnoringSafeArea(.all)
                                    .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text("Some Error Occured")) })
                                    .onReceive(timer) { _ in  withAnimation { beginAnimation.toggle() }; timer.upstream.connect().cancel()}
                    
                                
                  

                 
                       
        
                    
                    VStack(alignment: .center){
                     
                       
                        HStack(alignment: .top){
                            
                            backButton()
                            title()
                            Spacer()
                        }.offset(y: 45)
                        
                        ZStack{
                            searchField().offset(y: 45)
                            
                           
                            
                              
                            HStack{
                                Spacer()
                                nextButton()
                              
                            }
                           
                        }
                        
                        
                    
                        Spacer()
                           
                    }
                    
                
                 
                    
                    
                    
                    
                }
                .onAppear {
                    doneWithSignUp(state: false)
            }
        }
            
          
       
       
    }
    
    
    
    
    
    /// Title of the view text .
    func title() -> some View {
        
    
        
        return Text("Where were you born?")
            .foregroundColor(.white)
            .font(.largeTitle)
            .bold()
            .offset(x: 12)
    }
    
    
    
    
    func searchField() -> some View {
        
     
        
        return TextField("New York, NY", text: $searchedLocation)
            
            .foregroundColor(.clear)
            .frame(width: 300, height: 50)
            .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.3)
                    ))
            .onSubmit {
                
                searchForCities { cities in
                    
                    let  loc = cities.first?.placemark // first result in the array
                
                    print("The searched location is .. \(loc)")
                    // Change the region
                    guard let coordinates = loc?.coordinate else { return }
                    
                    withAnimation {
                        
                        region =  MKCoordinateRegion(center: coordinates,
                                           span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
                    }
                    
                    
                    
                }
                
            }
           
            

        
        
        
    /*    return
        
            Image("RootView/rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 50, alignment: .center)
        */
    }
    
    
    

    
    
    
    func MakeButtonForSelectingCity() -> some View {
        
        print("Making button for selecting city ... ")
        
        let cityNameAndState = "\(citiesSearchResult.first?.placemark.city ?? ""), \(citiesSearchResult.first?.placemark.state ?? "")"
        
        let city = citiesSearchResult.first
        
        return Button(cityNameAndState) {
            
          
            guard city != nil else {
                
                return
            }
            
            didSelectCityAction(city: city!)
            
           
            
        }
    }
    
   

    
    
    /// Call this to get a list of cities that are nearby that the user searched for in the searchedLocation binding string
    func searchForCities(_ completion: @escaping ([MKMapItem]) -> () )  {
        
        // ******************** // Search for city /// ******************** // ********//

        // Search for city
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchedLocation
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
            }

            let cities = response.mapItems
            completion(cities)
            return
        }
        

    }
    
    
    
    func didSelectCityAction(city: MKMapItem)  {
        
        // Pass the time zone to the next view
        self.timezone = city.timeZone
        
        
        goToNext = true
         
         account.data?.hometown = Place(latitude: city.placemark.coordinate.latitude, longitude: city.placemark.coordinate.longitude, city: city.placemark.city, state: city.placemark.state, country: city.placemark.country, geohash: city.placemark.geohash)
         
        
        do{
            
            try account.save()
            
        } catch (let error){
            
            goToNext = false
            handle(error)
            
        }
        
        
         
        
    }
    

    /// Goes back to the login screen
    func goBack()   {
        
        navigation.hideViewWithReverseAnimation(EnterOrientationView.id)
        
    }
    
    /// Left Back Button
    func backButton() -> some View {
        
       return Button {
            
            goBack()
            
        } label: {
            
             Image("RootView/right-arrow")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
                .frame(width: 33, height: 66)
                .offset(x: beginAnimation ? 7: 0, y: -10)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
                .onAppear { withAnimation { beginAnimation = true } }
                
            
              
        }

       
            
            
            
    }
    
    /// Comes back to this view since an error occured.
    func comeBackToView()  {
        
        navigation.hideViewWithReverseAnimation(FromWhereView.id)
        
    }
    
    /// Goes to the next screen / view,. Verification Code Screen
    func goToNextView()  {
        
        
        let animation = NavigationAnimation(
            animation: .easeInOut(duration: 0.8),
            defaultViewTransition: .static,
            alternativeViewTransition: .opacity
        )
        
        navigation.showView(EnterBirthdayView.id, animation: animation) { FromWhereView().environmentObject(navigation)
                            .environmentObject(account)
                        
            

            
        }
        
    }
    
    func nextButton() -> some View {
        
        return  Button {
            // Goes to next screen
          
            guard  let city = citiesSearchResult.first else {
                return
            }
            
            // Go to next
            goToNextView()
            
            
            account.data?.hometown = Place(latitude: city.placemark.coordinate.latitude, longitude: city.placemark.coordinate.longitude, city: city.placemark.city, state: city.placemark.state, country: city.placemark.country, geohash: city.placemark.geohash)
            
            do {
                
                try account.save()
                
            } catch (let error) {
                print("Got an error from where ... \(error)")
               comeBackToView()
                handle(error)
            }
            
            
        } label: {
            
           
                
            
            Image("RootView/right-arrow")
               .resizable()
               .scaledToFit()
               .frame(width: 33, height: 66)
               .offset(x: beginAnimation ? -15: 0, y: 0)
               .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: beginAnimation)
               .onAppear { withAnimation { beginAnimation = true } }
            
          
            
               
        }//.opacity( (likesMen == false  && likesWomen == false ) ? 0.5 : 1.0 )
    }
    
    
    func handle(_ error: Error)  {
        someErrorOccured = true
        // Handle Error
        if let error = error as? AccountError{
            
            switch error {
            case .doesNotExist:
                alertMessage = "You do not exist."
            case .disabledUser:
                alertMessage = "Sorry, your account is disabled."
            case .expiredVerificationCode:
                alertMessage = "Your verification code has expired."
            case .wrong:
                alertMessage = "You entered the wrong code"
            case .notSignedIn:
                alertMessage = "You are not signed in."
            case .uploadError:
                alertMessage = "There was some upload Error"
            case .notAuthorized:
                alertMessage = "You are not authorized to do this."
            case .expiredActionCode:
                alertMessage = "The action code has expired"
            case .sessionExpired:
                alertMessage = "The session has expired"
            case .userTokenExpired:
                alertMessage = "The user token has expired"
            }
        }
        
        if let error = error as? GlobalError{
            
            switch error {
            case .networkError:
                alertMessage = "There is a network error. Lost internet connection"
            case .tooManyRequests:
                alertMessage = "You're trying too many times to ping our servers. Wait a bit."
            case .captchaCheckFailed:
                alertMessage = "You might be a robot because you failed the captcha check and that's quite rare. Goodbye."
            case .invalidInput:
                alertMessage = "You entered something wrong with the wrong format."
            case .quotaExceeded:
                alertMessage = "This isn't your fault. We need to scale to be able to withstand the current quota. Just try again in a bit."
            case .notAllowed:
                alertMessage = "You are not allowed to do that."
            case .internalError:
                alertMessage = "There was some internal error with us. Not your fault."
            case .cantGetVerificationID:
                alertMessage = "This isn't an end-user error and you honestly should not be seeing this. If you did, something is broken. Report it to us because your verification ID is not being saved."
            case .unknown:
                alertMessage = "I'm not sure what this error is, lol."
            }
        }
        
        
        // Handle Error
        
    }
    
}

@available(iOS 15.0, *)
struct FromWhereView_Previews: PreviewProvider {
    static var previews: some View {
        
            FromWhereView().environmentObject(Account())
                .preferredColorScheme(.dark)
                .environmentObject(NavigationModel())
        
        
    }
}



struct MapViewUIKit: UIViewRepresentable {
    // 1.
    let region: MKCoordinateRegion
    let mapType : MKMapType
    
    // 2.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.mapType = mapType
        return mapView
    }
    
    // 3.
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = mapType
    }
}
extension MKMapView
{
    public func animatedZoom(to zoomRegion:MKCoordinateRegion,for duration:TimeInterval) -> Void
    {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations:
            { self.setRegion(zoomRegion, animated: true) }, completion: nil)
    }
}
