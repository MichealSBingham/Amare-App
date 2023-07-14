//
//  SettingsView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import NavigationStack

struct SettingsView: View {
    
    //@EnvironmentObject private var account: Account
    //@EnvironmentObject private var //navigationStack: NavigationStack
    var defaultImage: String = testImages[0]
    
    @State private var date = Date()
    //public var timezone: TimeZone? =  nil
    
    
    // DMs
    @State var fromEveryone: Bool = false
    
    // Settings
    // Opt Into Datenight
    @State var optIntoDatenight: Bool = false
    
    var body: some View {
        
        NavigationView{
            
            Form{
                
                //MARK: - Profile
                                Section(header: Text("Profile")) {
                                    
                                    VStack {
                                    
                                        /*
                                        Image("superMario")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                         */
                                        
                                        HStack{
                                            
                                            Spacer()
                                            
                                            ImageFromUrl( defaultImage)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .shadow(radius: 10)
                                                .aspectRatio(contentMode: .fit)
                                            
                                            Spacer()
                                        }
                                        
                                        Text("Micheal S. Bingham")
                                            .lineLimit(1)
                                            .font(.title)
                                            .minimumScaleFactor(0.01)
                                            .padding()
                                        
                                        
                                        
                                        /*
                                        VStack(alignment: .leading) {
                                            
                                            Text("\(account.data?.name ?? "Ethan Baker")")
                                                .lineLimit(1)
                                                .font(.largeTitle.bold())
                                                .minimumScaleFactor(0.01)
                                            
                                           
                                        }
                                        
                                        */
                                    }
                                }
                
                
                //MARK: - Birthday
                Section(header: Text("Birthday")){
                
                    
                    DatePicker(selection: $date, in :...Date().dateFor(years: -13) , displayedComponents: [.date, .hourAndMinute], label: { Text("Birthday") })
                        //.datePickerStyle(.graphical)
                    
                    //.environment(\.timeZone, self.timezone)
                     
                }
                
                //MARK: - Date Night
                Section(header: Text("Date Night")){
                  
                        Toggle("Opt into DateNight®", isOn: $optIntoDatenight)
            
                }
                
                //MARK: - Gender Identity
                Section(header: Text("Gender Identity")){
                    
                    /*
                    Menu {
                        Button {
                           // style = 0
                        } label: {
                            Text("Linear")
                            Image(systemName: "arrow.down.right.circle")
                        }
                        Button {
                           // style = 1
                        } label: {
                            Text("Radial")
                            Image(systemName: "arrow.up.and.down.circle")
                        }
                    } label: {
                         Text("Style")
                         Image(systemName: "tag.circle")
                    }
                    */
                    
                   
            
        }
                
                //MARK: - Private Messaging settings
                Section(header: Text("DMs")){
                    Toggle("Allow direct messaging", isOn: $fromEveryone)
        }
                
                Button("Sign Out") {
                  //  account.signOut { error in /* goBackToSignInRootView()*/ }
                }.onReceive(NotificationCenter.default.publisher(for: NSNotification.logout)) { _ in
                
                  //  goBackToSignInRootView()
                }
                
                
                
                
            }
        }
        /*
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
        */
        
    }
    
    
   /* func goBackToSignInRootView()  {
        //navigationStack.pop(to: .root)
    } */
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        SettingsView( )
            .environmentObject(Account())
            .preferredColorScheme(.dark)
    }
}
