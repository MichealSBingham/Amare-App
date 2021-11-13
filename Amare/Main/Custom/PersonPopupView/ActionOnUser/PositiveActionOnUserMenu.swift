//
//  PositiveActionOnUserMenu.swift
//  Amare
//
//  Created by Micheal Bingham on 10/11/21.
//

import SwiftUI
import Firebase
/// This should be changed to a floating button soon one day this is just a rough draft of actions a user can each other
struct PositiveActionOnUserMenu: View {
    
    var user: AmareUser?
    var account: Account
    
    /// Whether or not self user winked at the user or not
   @State var winkstatus: Bool? = nil
    
    /// If user winked at self (self account user)
    @Binding var canWinkBack: Bool
    
    var body: some View {
        
        ZStack{
            
            
            VStack{
                
                Button {
                    print("Add friend")
                } label: {
                    
                    HStack{
                        Image(systemName: "person.fill.badge.plus")
                        
                        Text("Add Friend")
                          //  .font(.largeTitle)
                             .bold()
                            // .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                    }.padding()
                }

                
                
               Divider()
                
                Button {
                    print("Message")
                } label: {
                    
                    HStack{
                        Image(systemName: "message.circle.fill")
                        
                        Text("Message")
                          //  .font(.largeTitle)
                             .bold()
                            // .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                    }.padding()
                }

                
                Divider()
                 
                 HStack{
                     
                     ZStack{
                         
                         
                        
                         
                         
                         TabView{
                             
                             Button {
                                 print("trying to wink at interest")
                                 
                              
                                 if let id = user?.id{
                                     print("Winking at ... \(id)")
                                     Account().wink(at: id )
                                     print("winking at .. \(user?.name)")
                                 }
                                
                                 
                             } label: {
                                 
                                 Text((!(winkstatus ?? false)) ? "😉 Wink": "😬 Unwink" )
                                   //  .font(.largeTitle)
                                      .bold()
                                     // .frame(maxWidth : .infinity, alignment: .center)
                                     //.padding(.top)
                                     .foregroundColor(Color.primary.opacity(0.4))
                             }.padding()
                             
                             Button {
                                 print("Approach?")
                             } label: {
                                 
                                 Text("👀 Approach")
                                   //  .font(.largeTitle)
                                      .bold()
                                     // .frame(maxWidth : .infinity, alignment: .center)
                                     //.padding(.top)
                                     .foregroundColor(Color.primary.opacity(0.4))
                                     
                             }.padding()
                             
                             Button {
                                 print("Ask For Consent?")
                             } label: {
                                 
                                 Text("😏 Consent")
                                   //  .font(.largeTitle)
                                      .bold()
                                     // .frame(maxWidth : .infinity, alignment: .center)
                                     //.padding(.top)
                                     .foregroundColor(Color.primary.opacity(0.4))
                                     
                             }.padding()
                             
                             
                             
                         }
                         //TODO: might need to adjust this
                         .frame(width: .infinity, height: 50)
                             .tabViewStyle(.page(indexDisplayMode: .never))
                             
                              
                         HStack{
                             Spacer()
                             
                             Button {
                                 print("What does show interest mean")
                             } label: {
                                 
                                 Image(systemName: "questionmark.circle.fill")
                                     .colorMultiply(.white)
                                     .padding()
                             }

                             
                           
                         }
                         
                         }
                     
                     
                     }
                    

                
                
                
            }
           
            
            
        }
        //.padding()
        .background(.ultraThinMaterial)
        .foregroundColor(.pink)
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
     .onChange(of: user, perform: { user_selected in
            
            guard let me = Auth.auth().currentUser?.uid , let them = user_selected?.id else  {
                
                print("Could not get me: \(Auth.auth().currentUser?.uid) or them: \(user_selected?.id) ")
                
                return
            }
            print("LISTENING FOR WINKS")
            account.db?.collection("winks").document(them).collection("people_who_winked").document(me).addSnapshotListener({ snapshot, error in
                
                print("*** THe snapshot is \(snapshot) with error \(error)")
                
                if snapshot?.exists ?? false {
                    withAnimation {
                        
                        winkstatus = true
                    }
                   
                } else {
                    winkstatus = false
                }
            })
        })
        
    }
}

/*
struct PositiveActionOnUserMenu_Previews: PreviewProvider {
    
    @State var canWinkBack: Bool = true
    static var previews: some View {
        PositiveActionOnUserMenu( account: Account(), canWinkBack: $canWinkBack).preferredColorScheme(.dark)
    }
}
*/
 
