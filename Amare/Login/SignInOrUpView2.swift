//
//  SignInOrUpView2.swift
//  Amare
//
//  Created by Micheal Bingham on 8/19/21.
//

import SwiftUI

struct SignInOrUpView2: View {
    var body: some View {
        
        ZStack{
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
            Background(timer: timer)//.opacity(0.80)
            
            
            VStack{
                
                EnterYour()
                PhoneNumber()
                StandardMessagingRatesMayApply().padding()
                
            }
        }
        
    }
    
    
    func EnterYour() -> some View  {
        return Text("Enter Your")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
            
    }
    
    func PhoneNumber() -> some View  {
        
        return Text("Phone Number")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
    }
    
    func StandardMessagingRatesMayApply() -> some View  {
        
        return Text("Standard messaging rates may apply.")
            .font(.system(size: 20))
            .foregroundColor(.white)
    }
    
    
}

struct SignInOrUpView2_Previews: PreviewProvider {
    static var previews: some View {
        SignInOrUpView2().onAppear(perform: {
            print("will show")
            UIApplication.shared.showKeyboard()
        })
    }
}
