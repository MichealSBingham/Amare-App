//
//  EnterBirthdayView.swift
//  Love
//
//  Created by Micheal Bingham on 6/18/21.
//

import SwiftUI
import Firebase


struct EnterBirthdayView: View {
    
    @EnvironmentObject private var account: Account
    
    @State private var goToNext: Bool = false 
    
    @State private var date = Date()
    
    @Binding public var timezone: TimeZone?
    
    var body: some View {
        
     
            
            ZStack{
                
                // Background Image
                Image("backgrounds/background1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .navigationTitle("When Is Your Birthday?")
                    .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
                // ******* ======  Transitions -- Navigation Links =======
                
                // Goes to the Profile
                NavigationLink(
                    destination: LiveWhereView().environmentObject(account),
                    isActive: $goToNext,
                    label: {  EmptyView()  }
                )
                
                // ******* ================================ **********
                
                
                
                
                VStack{
                    
                    Spacer()
                    
                    DatePicker(selection: $date, in :...Date() , displayedComponents: [.date, .hourAndMinute], label: { Text("Birthday") }).datePickerStyle(.graphical).environment(\.timeZone, timezone!)
                    
                    
                    
                    Spacer()
                    
                    Button("Done") {
                        
                        
                        // Corrects the time zone of the date
                        
                              
                        
                        
                        let bday = Birthday(timestamp: Timestamp(date: date), month: date.month(), day: date.day(), year: date.year())
                        
                        
                        let userData = UserData(id: account.user?.uid ?? "", birthday: bday)
                         
                        print("The user data inside button is .. \(userData)")
                        
                        goToNext = true
                        account.set(data: userData) { error in
                            
                            if let error = error {
                                goToNext = false // an error occured so come back
                            }
                            
                        }
                        
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()

                }
                
                
                
                
            } .onAppear {
                doneWithSignUp(state: false)
            }
            
           
       
            
     
        
    }
}

struct EnterBirthdayView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView{
            EnterBirthdayView(timezone: .constant(TimeZone.current)).environmentObject(Account())
                .preferredColorScheme(.dark)
        }
        
    }
}
