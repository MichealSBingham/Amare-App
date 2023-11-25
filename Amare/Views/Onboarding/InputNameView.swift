//
//  InputNameView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/4/23.
//

import SwiftUI
import MapKit
import EffectsLibrary
enum FirstResponders: Int {
        case name
        case city
    }

enum Field: Int, Hashable{
    case enterName
    case enterCity
}

struct InputNameView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
	
	/// If this is true, it will adjust the content of the view so that it's for creating another custom profile instead of onboarding the sign up user. i.e. instead of `Enter your name` it'll say `Enter their name`
	var customAccount: Bool = false

    
    @State   var name: String = ""
    
    
   
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    @State private var beginAnimation: Bool = false
    @State private var beginAnimation2: Bool = false
    
    @State private var buttonIsDisabled: Bool = false

	@FocusState private var isFieldFocused: Bool
   
   
    @State var firstResponder: FirstResponders? = .name
    
    @State private var isExpanded =  true
    @Namespace private var namespace
    
   
    
    @State var changeText: Bool = false
    
    @FocusState var focusField: Field?
    
    var config = SnowConfig( intensity: Intensity.low, lifetime: Lifetime.long, initialVelocity: InitialVelocity.fast, spreadRadius: SpreadRadius.high)
    
    
    
    var body: some View {
       

        
        ZStack{
          //  MovingImageView(speed: 1.5)
            SnowView(config: config)
                .colorMultiply(.pink)
                //.opacity(0.5)
                .offset(y: -100)
            
           
            VStack{
                
                
                
                
                
                if isExpanded {
                    Spacer()
                }
                
                title().padding()
               
                
                
                
                
                
                
                ZStack{
                    
                    enterNameField().padding()
                        .padding(.bottom)
                        .onAppear{
                            firstResponder = .name
                            focusField = .enterName
                        }
                    
                        .opacity(isExpanded ? 1: 0)
                    
                    CitySearchView( firstResponder: $firstResponder)
                        .opacity(!isExpanded ? 1: 0)
                    
                    
                }
                
                
                
                
                NextButtonView {
                    
                    if !isExpanded{
                        
                       // Should go to next view now
                        withAnimation{
                            model.currentPage = .birthday
                        }
                    }
                    
                    guard !(name.isEmpty) else{
                        // User entered an empty name
                        /// - TODO: Do something to tell the user to enter a name
                        return
                    }
                    
                    name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Set the name in the OnboardingModel
                    model.name = name
                    
                    withAnimation() {
                        
                        isExpanded.toggle()
                        firstResponder = .city
                        model.currentPage = .hometown
                        
                        withAnimation {
                            changeText.toggle()
                        }
                    }
                    
                }
                    .disabled(isExpanded && name.isEmpty)
                    .opacity(isExpanded && name.isEmpty ? 0.5: 1.0)
                    .disabled(!isExpanded && model.homeCity == nil )
                    .opacity(!isExpanded && model.homeCity == nil  ? 0.5: 1.0)
                
                
                
                
               
                    KeyboardPlaceholder()
              
                
                      
                      
                    
         
                        
                    }
                .matchedGeometryEffect(id: "animation", in: namespace, isSource: isExpanded)
            
           
            .alert(isPresented: $someErrorOccured, content: {  Alert(title: Text(alertMessage)) })
    
            .onAppear { withAnimation {beginAnimation = true}
            }
            

            
            
        }
        
               
                
                        
                    
         
               
            
    }
            
          
            
  
            

    
    /// Creates the logo for the view
    func createLogo() -> some View {
        
        /// The molecule (center) part of the logo (image)
         func moleculeImage() -> some View {
            
            return Image("branding/molecule")
                 .resizable()
                .scaledToFit()
                .frame(width: 35, height: 29.5)
               
        }
        
        /// The ring part of the logo (Image)
         func ringImage() -> some View {
            
            return Image("branding/ring")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
               
        }
        
        ///The horizontal  part of the cross that's a part of the logo
         func horizontalCrossImage() -> some View {
            
            return Image("branding/cross-h")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 3)
                .offset(y: 44)
        }
        
        /// The verticle part of the cross that's a part of the logo
         func verticleCrossImage() -> some View {
            
            return Image("branding/cross-v")
                .resizable()
                .scaledToFit()
                .frame(width: 3.5, height: 28)
                .offset(x: 0, y: 38)  // was -8
                
                
        }
        
        
        return Group{
            ZStack{ ringImage() ; moleculeImage()  }
            ZStack{ verticleCrossImage() ; horizontalCrossImage() }
        }
            .offset(y: beginAnimation ? 30: 0 )
            .animation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true), value: beginAnimation)
            .onAppear(perform: {  withAnimation{beginAnimation = true}})

    }
    
    func enterNameField() -> some View {
        
        return    TextField("What's your name?", text: $name, onCommit:  {
            
            if !isExpanded{
                
               // Should go to next view now
                withAnimation{
                    model.currentPage = .birthday
                }
            }
            
            guard !(name.isEmpty) else{
                // User entered an empty name
                /// - TODO: Do something to tell the user to enter a name
                return
            }
            
            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Set the name in the OnboardingModel
            model.name = name
            
            withAnimation() {
                
                isExpanded.toggle()
                firstResponder = .city
                model.currentPage = .hometown
                
                withAnimation {
                    changeText.toggle()
                }
            }
            
          
            
        })
        .focused($focusField, equals: .enterName)
		
	/*	.firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .none) */
        
        .font(.largeTitle)
        .autocorrectionDisabled()
        
      

    }
    
    /// Title of the view text .
    @ViewBuilder
    func title() -> some View {
        
        if customAccount{
            
            Text(!changeText ?  "Their Cosmic Identity" : "Where Did They Spawn On Earth?")
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 50))
                .lineLimit(3)
                .padding(.bottom, !changeText ? -40 :0)
                .padding(.top, changeText ?  30: 0)
                .minimumScaleFactor(0.7)
                .padding(.horizontal)
               
        } else {
            
            Text(!changeText ?  "Your Cosmic Identity" : "Where Did You Spawn On Earth?")
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 50))
                .lineLimit(3)
                .padding(.bottom, !changeText ? -40 :0)
                .padding(.top, changeText ?  30: 0)
                .minimumScaleFactor(0.7)
            
                
        }
        
		
    }
    
 
    }
    

    /*
    func handle(_ error: Error)  {
        
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
        someErrorOccured = true
    }
    */
    

    
    
struct CitySearchView: View {
    
    @EnvironmentObject var model: OnboardingViewModel
    
    
    @State private var searchText = ""
    @State private var selectedCity: String?
    @StateObject private var searchCompleter = SearchCompleter(completer: MKLocalSearchCompleter(), maxResults: 5)
    
    @State var showTimeZoneErrorAlert: Bool = false
    
    
    @Binding var firstResponder: FirstResponders?
    
     var isCustomAccount: Bool = false
    
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField(!isCustomAccount ? "Enter your place of birth, **not** your current city." : "Enter their place of birth, **not** their current city.", text: $searchText, onCommit: {
                
                guard model.homeCity != nil else { return }
                
                
                //firstResponder = .none
                withAnimation{
                    model.currentPage = .birthday
                }
                
                
                
            })
                .firstResponder(id: FirstResponders.city, firstResponder: $firstResponder, resignableUserOperations: .none)
            
                .padding()
                .onChange(of: searchText) { newValue in
                    searchCompleter.completer.queryFragment = newValue
                }
                .alert(isPresented: $showTimeZoneErrorAlert) {
                                Alert(
                                    title: Text("Can't Quite Find Your City"),
                                    message: Text("There was an error finding the timezone. Please try the closest city nearby."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
            
            ScrollView {
                LazyVStack {
                    ForEach(searchCompleter.results, id: \.title) { result in
                        HStack {
                            Text(result.title)
                            
                            Spacer()
                            
                            if selectedCity == result.title {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCity = result.title
                            setTimezoneFromCity(city: result.title)
                        }
                        .padding()
                        .background(Color(.gray))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
            }
            .frame(height: 125)
            .padding()
        }.onAppear{
            //firstResponder = .city
        }
        
        
    }
    func setTimezoneFromCity(city: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = city
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for item in response.mapItems {
                
                if let timeZone = item.timeZone, let _ = item.placemark.city {
                    print("the selected time zone is ... \(timeZone)")
                    model.homeCity = item.placemark
                    model.homeCityTimeZone = timeZone
                } else{
                    // something went wrong selecting the timezone
                    selectedCity = nil
                    showTimeZoneErrorAlert = true
                }
            }
        }
    }
}



struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            
            InputNameView()
            .offset(y: 100)
                .environmentObject(OnboardingViewModel())
            
        }
           
        
       
    }
}

 
