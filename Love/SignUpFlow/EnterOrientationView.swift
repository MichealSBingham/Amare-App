//
//  EnterOrientationView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct EnterOrientationView: View {
    
    @EnvironmentObject private var account: Account
    @State private var goToNext: Bool = false
    
    
    var body: some View {
        
        // ******* ======  Transitions -- Navigation Links =======
        //                                                      //
        //                Goes to the Profile                   //
        //                                                      //
     /* || */           NavigationLink(                       /* || */
    /* || */   destination: FromWhereView().environmentObject(account),
    /* || */           isActive: $goToNext,                  /* || */
    /* || */           label: {  EmptyView()  })             /* || */
    /* || */                                                 /* || */
    /* || */                                                 /* || */
        // ******* ================================ **********
        
        
        ZStack{
            
            SetBackground()
            
            
    
            HStack { MenButton(); WomenButton(); MenAndWomenButton(); EverythingButton()}
            
        }.onAppear {  doneWithSignUp(state: false)}
    }
    
    
    
    
    
    func SetBackground() -> some View {
        
        return Image("backgrounds/background1")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("I like ... ")
            .navigationBarColor(backgroundColor: .clear, titleColor: .white)
    }
    
    
    
    func MenButton() -> some View {
        
        return Button("Men") {
            // Selected they like Men
            SelectOrientaionAction(orientaion: "M")
            
        }.padding()
    }
    
    
    func WomenButton() -> some View {
        
        return Button("Women") {
            // Selected they like Women
            
            SelectOrientaionAction(orientaion: "W")
            
        }.padding()
    }
    
    func MenAndWomenButton() -> some View {
        
        return Button("Men and Women") {
            // Selected they like women and men
            SelectOrientaionAction(orientaion: "MW")
            
        }.padding()
    }
    
    func EverythingButton() -> some View {
        
        return Button("(?)ALL(?)") {
            // Selected they like everythong
            SelectOrientaionAction(orientaion: "A")
            
        }.padding()
    }
    
    
    
    
    
    func SelectOrientaionAction(orientaion: String)  {
        goToNext = true
        
        account.data?.orientation = orientaion
        
        account.save { error in
            
            guard error == nil else {
                
                goToNext = false
                return
            }
        }
        
    }


}

@available(iOS 15.0, *)
struct EnterOrientationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{EnterOrientationView().environmentObject(Account()).preferredColorScheme(.dark)}
    }
}
