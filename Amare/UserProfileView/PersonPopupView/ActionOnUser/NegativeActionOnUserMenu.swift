//
//  NegativeActionOnUserMenu.swift
//  Amare
//
//  Created by Micheal Bingham on 12/25/21.
//

import SwiftUI

struct NegativeActionOnUserMenu: View {
    
    var user: AmareUser?
    var account: Account
    
    var body: some View {
        ZStack{
            
            VStack{
                
                Button {
                    print("Delete Profile")
                    Account().deleteCustomProfile(id: user?.id ?? "")
                } label: {
                    
                    HStack{
                        Image(systemName: "trash.fill")
                        
                        Text("Delete Profile")
                          //  .font(.largeTitle)
                             .bold()
                            // .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                    }.padding()
                }

            }
        }
        .background(.ultraThinMaterial)
        .foregroundColor(.pink)
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
    }
}

struct NegativeActionOnUserMenu_Previews: PreviewProvider {
    static var previews: some View {
        NegativeActionOnUserMenu(user: AmareUser(), account: Account())
    }
}
