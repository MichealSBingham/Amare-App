//
//  MainView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI

struct MainView: View {
    
    /// id of view
    static let id = String(describing: Self.self)
    @ObservedObject var settings = Settings.shared
    
    @EnvironmentObject private var account: Account
    
    
    var body: some View {
      
        
        TabView{
            EmptyView()
            
        }
        .onAppear(perform: { thingsToDoWhenMainViewLoads()})
    }
    
    
    /// Listen for user data updates
    /// Listen for a sign out change in the auth
    ///  Save this view so that app delgate knows that they finished the sign up process
    func thingsToDoWhenMainViewLoads()  {
        
        account.listen_for_user_data_updates()
        account.listenOnlyForSignOut()
        settings.viewType = .main
    }
    
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
