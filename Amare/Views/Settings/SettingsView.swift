//
//  SettingsView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/21/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDataModel: UserProfileModel
    
    @EnvironmentObject var authService: AuthService
    
    @EnvironmentObject var viewRouter: ViewRouter
    

    var body: some View {
        Form {
            Section(header: Text("User Information")) {
                Text("Name: \(userDataModel.user?.name ?? "" )")
                Text("Username: \(userDataModel.user?.username ?? "" )")
                Text("Phone Number: \(userDataModel.user?.phoneNumber ?? "" )")
            }
            
            Section {
                Button("Sign Out", action: {
                    authService.signOut { result in
                        switch result{
                        case .success(_):
                            print("Signed out ")
                            withAnimation{ viewRouter.screenToShow = .signInOrUp}
                        case .failure(let error):
                            print("Could not sign out with error \(error)")
                        }
                    }
                })
                                .foregroundColor(.red)
                        }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserProfileModel())
}
