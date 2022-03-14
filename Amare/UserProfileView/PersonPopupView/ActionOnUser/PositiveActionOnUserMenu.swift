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
    
    @Binding var user: AmareUser
   
    
    
    var body: some View {
        
        ZStack{
            
            
            VStack{
                
                HStack{
                    
                    ZStack{
                        
                        // Only show this when you should respond to a friend request otherwise show the other view
                        TabView(/*selection: $user.openFriendRequest*/){
                            
                        
                           
                            Button {
                                
                               acceptFriendRequest()
                               
                                    
                            } label: {
                                
                                
                                    
                                   
                          
                                        Image(systemName: "person.fill.checkmark")
                                    .animation(.easeInOut)
                                    .foregroundColor(.green)
                                        
                                
                                
                               
                                
                                        
                            
                                
                                    
                                    Text("Accept Friend Request")
                                         .bold()
                                         .foregroundColor(.green)
                                       
                                        
                                
                              
                                
                            }
                            .tag(0)
                            
                            // needs to respond to friend request
                            Button {
                                
                                rejectFriendRequest()
                               
                                    
                            } label: {
                                
                                
                                    
                                    ZStack{
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                            .animation(.easeInOut)
                                        
                                    }
                                   
                                    
                                    Text("Decline Friend Request")
                                         .bold()
                                         .foregroundColor(.red)
                                         .animation(.easeInOut)
                                        // .foregroundColor(.red.opacity(0.4))
                                      
                                
                                
                            }
                            .tag(1)
                           
                            
                            
                        }
                        //TODO: might need to adjust this
                        .frame(width: .infinity, height: 50)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .opacity((user.openFriendRequest ?? false) && !(user.areFriends ?? false) ? 1: 0)
                        .opacity(user.areFriends ?? false ? 0: 1)
                        
                        
                        
                        Button {
                            
                            print("Trying to add friend of user with id .. \(user.id)")
                            addFriend()
                           
                                
                        } label: {
                            
                            
                                
                                ZStack{
                                    
                                    Image(systemName: "nosign").opacity(user.requested ?? false ? 1: 0)
                                        .animation(.easeInOut)
                                    Image(systemName: "person.fill.badge.plus").opacity(user.requested ?? false ? 0: 1)
                                        .animation(.easeInOut)
                                    
                                }
                               
                                
                            Text(user.requested ?? false ? "Cancel Friend Request" : "Add Friend")
                                     .bold()
                                    .foregroundColor(Color.primary.opacity(0.4))
                                    .animation(.easeInOut)
                        }
                        .opacity((user.openFriendRequest ?? false) ? 0: 1)
                        .opacity(user.areFriends ?? false ? 0: 1)
                    
                        
                        
                        // If they are already friends only show them options to remove friend
                        TabView(/*selection: $user.areFriends */){
                            
                        
                           
                            Button {
                                
                               print("Friends Already ")
                               
                                    
                            } label: {
                                
                                
                                    
                                   
                                        
                                      
                                Image(systemName: "checkmark.shield.fill")
                                   .foregroundColor(.green)
                                   .animation(.easeInOut)
                                
                                        
                                        
                            
                                   
                                    
                                    Text("Friends")
                                         .bold()
                                         .foregroundColor(Color.primary.opacity(0.4))
                                         .animation(.easeInOut)
                                       
                                
                            }
                            .disabled(true)
                            .tag(0)
                            
                            // needs to respond to friend request
                            Button {
                                
                                removeFriend()
                                    
                            } label: {
                                
                                
                                    
                                    ZStack{
                                        
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                            .animation(.easeInOut)
                                        
                                    }
                                   
                                    
                                    Text("Remove Friend")
                                         .bold()
                                         .foregroundColor(.red)
                                         .animation(.easeInOut)
                                        // .foregroundColor(.red.opacity(0.4))
                                      
                                
                                
                            }
                            .tag(1)
                           
                            
                            
                        }
                        //TODO: might need to adjust this
                        .frame(width: .infinity, height: 50)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .opacity((user.areFriends ?? false) ? 1: 0 )
                        
                        
                        
                        
                        
                    }
                    
                   
                    
                    
                    
                }
                
               

                
            
                
               Divider()
                
                Button {
                    print("Message")
                } label: {
                    
                    HStack{
                        Image(systemName: "message.circle.fill")
                            .animation(.easeInOut)
                        
                        Text("Message")
                          //  .font(.largeTitle)
                             .bold()
                            // .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                    }.padding()
                }
               // .border(.orange)

                
                Divider()
                 
                 HStack{
                     
                     ZStack{
                         
                         
                        
                         
                         
                         TabView{
                             
                             Button {
                                 print("trying to wink at interest")
                                 
                              
                                 if let id = user.id{
                                     print("Winking at ... \(id)")
                                     
                                     if user.winkedTo ?? false  {
                                         // unwink
                                         Account.shared.unwink(at: id)
                                     } else {
                                         
                                         Account.shared.wink(at: id )
                                     }
                                    
                                 }
                                
                                 
                             } label: {
                                 
                                 ZStack{
                                     
                                     
                                     
                                     // If I wink at the user then I need the option to unwink == if i haven't winked at you(wink) otherwise unwink
                                     
                                     Text(!(user.winkedTo ?? false) ?
                                          "😉 Wink": "😬 Unwink")
                                         .bold()
                                         .foregroundColor(!(user.winkedTo ?? false) ? .blue.opacity(0.7) : .red.opacity(0.7))
                                         .opacity(!(user.winkedAtMe ?? false) ? 1: 0)
                                         .animation(.easeInOut)
                                     // only show this label if the other person hasn't winked at me
                                     
                                     
                                     
                                    
                                     // if they winked at me, can wink back
                                     Text(!(user.winkedTo ?? false)  ? "😉 Wink Back": "😬 Unwink" )
                                         .bold() // NEW BLUE
                                        // .foregroundColor(Color.primary.opacity(0.4))
                                         .foregroundColor((user.winkedAtMe ?? false) && !(user.winkedTo ?? false) ? .blue.opacity(0.7) : .red.opacity(0.7))
                                         .opacity((user.winkedAtMe ?? false) ? 1: 0)
                                         .animation(.easeInOut)
                                 }
                               
                                 
                                 
                                 
                             }.padding()
                                // .border(.blue)
                                 
                                
                             
                             Button {
                                 print("Approach?")
                             } label: {
                                 
                                 Text("👀 Approach")
                                   //  .font(.largeTitle)
                                      .bold()
                                     // .frame(maxWidth : .infinity, alignment: .center)
                                     //.padding(.top)
                                     .foregroundColor(Color.primary.opacity(0.4))
                                     .animation(.easeInOut)
                                     
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
                                     .animation(.easeInOut)
                                     
                             }.padding()
                                 
                               
                             
                             
                             
                         }
                         //TODO: might need to adjust this
                         .frame(width: .infinity, height: 50)
                             .tabViewStyle(.page(indexDisplayMode: .never))
                            // .border(.green)
                             
                             
                              
                         HStack{
                             Spacer()
                             
                             Button {
                                 print("What does show interest mean")
                             } label: {
                                 
                                 Image(systemName: "questionmark.circle.fill")
                                     .colorMultiply(.white)
                                     .animation(.easeInOut)
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
        
    }
    
    
    
    /// Sends request to database to add a friend or cancel friend request
    func addFriend()  {
      
        guard !(user.requested ?? false) else {
            
            Account.shared.cancelFriendRequest(to: user.id) { error in
                
                print("The error after cancelling friend request is \(error)")
            }
            
            return
        }
        
        Account.shared.sendFriendRequest(to: user.id) { error in
            
            print("The error after sending friend request is \(error)")
        }
    }
    
    
    func acceptFriendRequest()  {
        
        Account.shared.acceptFriendRequest(from: user.id) { error in
            print("Accepting Friend Request with error \(error)")
        }
    }
    
    
    func rejectFriendRequest()  {
        
        Account.shared.acceptFriendRequest(from: user.id) { error in
            print("Accepting Friend Request with error \(error)")
        }
        
    }
    
    func removeFriend(){
        
        Account.shared.removeFriend(removedUserId: user.id) { error in
            
            print("Removing Friend  with error \(error)")
        }
    }
}



struct PositiveActionOnUserMenu_Previews: PreviewProvider {
    
    @State var canWinkBack: Bool = true
    static var previews: some View {
        PositiveActionOnUserMenu( user: .constant(AmareUser())).preferredColorScheme(.dark)
    }
}

 
