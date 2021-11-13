//
//  SettingsView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import NavigationStack

struct SettingsView: View {
    @EnvironmentObject private var account: Account
    //@EnvironmentObject private var navigationStack: NavigationStack

    
    var body: some View {
        
        VStack{
        
            Spacer()
            
            Text("You will find some settings here; well, it will actually likely be in a menu up top but this is a placeholder. Sometimes the sign out button will not pop back to the home menu. [Known Issue]. Quit the app if this happens.")
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            Button("Sign Out") {
                account.signOut { error in /* goBackToSignInRootView()*/ }
            }/*.onReceive(NotificationCenter.default.publisher(for: NSNotification.logout)) { _ in
            
                goBackToSignInRootView()
            }*/
            
            Spacer()
            
        }
        
        
    }
    
    
   /* func goBackToSignInRootView()  {
        navigationStack.pop(to: .root)
    } */
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Account())
            .preferredColorScheme(.dark)
    }
}
