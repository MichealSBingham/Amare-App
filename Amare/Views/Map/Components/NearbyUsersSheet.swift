//
//  NearbyUsersSheet.swift
//  Amare
//
//  Created by Micheal Bingham on 11/27/23.
//

import SwiftUI

struct NearbyUsersSheet: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var showUserSheet: Bool
    @Binding var presentationDetent: PresentationDetent
    @StateObject var userDataModel: UserProfileModel = UserProfileModel()
    
    @EnvironmentObject var signedInUserDataModel: UserProfileModel
    
    @EnvironmentObject var viewRouter: ViewRouter 
    
    private let thresholdHeight = UIScreen.main.bounds.size.height * 0.45
  

    let mockUsers : [AppUser] = AppUser.generateMockData(of: 24)
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationStack {
             userCountTitle
                    .onAppear(perform: {
                    
                        viewRouter.showBottomTabBar = true
                    })
                    .padding()
                ZStack{
                    VStack{
                        nearbyUsersScrollView
                            .opacity(geometry.size.height >= thresholdHeight ? 0 : 1)
                            .frame(height: 100)
                        Spacer()
                    }
                    
                    ScrollView {
                        VStack {
                            

                                ForEach(mapViewModel.nearbyUsers, id: \.id) { user in
                                    
                                    NavigationLink {
                                        
                                        userView
                                            .onAppear(perform: {
                                                withAnimation{
                                                    // change this becasue instead of doing .onAppear, wwe want this to run when the navigationLink is tapped
                                                    presentationDetent = .medium
                                                    viewRouter.showBottomTabBar = false
                                                }
                                                userDataModel.loadUser(userId: user.id ?? "" )
                                            })
                                        
                                    } label: {
                                        
                                        NearbyUserRowView(profileImageUrl: user.profileImageUrl, name: user.name, distance: "3 km away")
                                          
                                    }
                                    .buttonStyle(.plain)

                                    
                            }
                               

                            
                        
                        .padding()
                            
                        }
                        
                       
                    }
                    .padding()
                    .padding(.vertical, 10)
                   
                    .opacity(geometry.size.height >= thresholdHeight ? 1 : 0)
                }
               
               
              
            }
            .background(ClearBackgroundView())
        }
        

        
    }
    
    private var userCountTitle: some View {
        HStack {
            Text("\(mapViewModel.nearbyUsers.count) \(mapViewModel.nearbyUsers.count == 1 ? "Person" : "People") Near You")
                .font(.title3.bold())
            Spacer()
        }
    }
    
    private var nearbyUsersVerticalView: some View{
        
        List(AppUser.generateMockData(of: 24)){ user in
            NearbyUserRowView(profileImageUrl: user.profileImageUrl, name: user.name, distance: "3 km away")
               
            
        }
        
       
        
    }

    private var nearbyUsersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mapViewModel.nearbyUsers) { user in
                    
                    NavigationLink {
                        
                        userView
                            .onAppear(perform: {
                                withAnimation{
                                    // change this becasue instead of doing .onAppear, wwe want this to run when the navigationLink is tapped
                                    presentationDetent = .medium
                                    viewRouter.showBottomTabBar = false
                                }
                                userDataModel.loadUser(userId: user.id ?? "" )
                            })
                        
                    } label: {
                        
                        CircularProfileImageView(profileImageUrl: user.profileImageUrl, isNotable: false, showShadow: false)
                            .frame(width: 80)
                            .padding()
                            .buttonStyle(.plain)
                    }

                    
                   
                }
            }
            .frame(minHeight: 90)
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
    
    
    private var userView: some View {
       UserProfileView2(model: userDataModel, hideCustomNavBar: false)
            .environmentObject(signedInUserDataModel)
            .environmentObject(AuthService.shared)
            .onAppear(perform: {
                withAnimation{
                    viewRouter.showBottomTabBar = false
                }
            })
            
    }
}

struct ClearBackgroundView: View {
    var body: some View {
        // Custom implementation for a clear background
        Color.clear
    }
}

// CircularProfileImageView should be defined here, or if it's defined elsewhere, ensure it's imported correctly.

#Preview {
    NearbyUsersSheet_Previews()
}


struct NearbyUsersSheet_Previews:  View {
    @StateObject var  helper = MapViewModel()
     var body: some View {
        
        NavigationView{
            
            NearbyUsersSheet( showUserSheet: .constant(true), presentationDetent: .constant(.medium))
                .environmentObject(helper)
                .onAppear {
                   
                }
        }
    }
}
