//
//  MainView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import NavigationStack

struct MainView: View {
    
    /// id of view
    static let id = String(describing: Self.self)
    @ObservedObject var settings = Settings.shared
    
    @EnvironmentObject private var account: Account
    @EnvironmentObject private var navigationStack: NavigationStack

    
    
    var body: some View {
        
       
    

            TabView{
                
                
                NatalChart()
                Scanner()
                Map()
                Chats()
                Perferences()
                
                
            }
            .onAppear(perform: { thingsToDoWhenMainViewLoads()})
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.logout), perform: { _ in
            
                goBackToSignInRootView()
        
        })
                        
            
            
            
        
       
    }
    
    
    func Scanner() ->  some View  {
        
        return ScannerView()
                .tabItem { Label("Scanner", systemImage: "iphone.rear.camera") }
                .environmentObject(account)
        
    }
    
    func NatalChart() ->  some View  {
        
        return ChartView()
                .tabItem { Label("Chart", systemImage: "calendar.circle") }
                .environmentObject(account)
        
    }
    
    func Chats() ->  some View  {
        
        return MessagesView()
                .tabItem { Label("Chats", systemImage: "message.circle") }
                .environmentObject(account)
        
    }
    
    func Perferences() ->  some View  {
        
        return SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .environmentObject(account)
        
    }
    
    func Map() ->  some View  {
        
        return MapView()
                .tabItem { Label("Map", systemImage: "map.circle") }
                .environmentObject(account)
        
    }
    
    
    func goBackToSignInRootView()  {
        navigationStack.pop(to: .root)
    }
    
    
    
    
    
    /// Listen for user data updates
    /// Listen for a sign out change in the auth
    ///  Save this view so that app delgate knows that they finished the sign up process
    func thingsToDoWhenMainViewLoads()  {
        
        print("Things to do when view loads... ")
        account.listen_for_user_data_updates()
        account.listenOnlyForSignOut()
        settings.viewType = .main
    }
    
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Account())
    }
}
