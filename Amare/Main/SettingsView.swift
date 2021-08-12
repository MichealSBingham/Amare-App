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
    @EnvironmentObject private var navigationStack: NavigationStack

    
    var body: some View {
        
        Button("Sign Out") {
            account.signOut { error in }
        }
    }
    
    
    func goBackToSignInRootView()  {
        navigationStack.pop(to: .root)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Account())
    }
}
