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
   // var account: Account
    
    /// Whether or not THIS user winked at the user or not
        // @State var winkstatus: Bool? = nil
    
    /// If other user winked at THIS user (self account user)
    //@Binding var canWinkBack: Bool
    
    
    /// Whether or not THis user sent a friend request
    //@State var sentFriendRequest: Bool? = nil
    
    //@State var shouldRespondToFriendRequest: Bool? = nil
    
    //Whether or not these are already friends
   // @State var friendsAlready: Bool? = nil
    
    
    var body: some View {
        
        ZStack{
            
            
            VStack{
                
                HStack{
                    
                    ZStack{
                        
                        // Only show this when you should respond to a friend request otherwise show the other view
                        TabView(selection: $user.openFriendRequest){
                            
                        
                           
                            Button {
                                
                               acceptFriendRequest()
                               
                                    
                            } label: {
                                
                                
                                    
                                   
                          
                                        Image(systemName: "person.fill.checkmark")
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
                                        
                                    }
                                   
                                    
                                    Text("Decline Friend Request")
                                         .bold()
                                         .foregroundColor(.red)
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
                            
                            addFriend()
                           
                                
                        } label: {
                            
                            
                                
                                ZStack{
                                    
                                    Image(systemName: "nosign").opacity(user.requested ?? false ? 1: 0)
                                    Image(systemName: "person.fill.badge.plus").opacity(user.requested ?? false ? 0: 1)
                                    
                                }
                               
                                
                            Text(user.requested ?? false ? "Cancel Friend Request" : "Add Friend")
                                     .bold()
                                    .foregroundColor(Color.primary.opacity(0.4))
                            
                        }
                        .opacity((user.openFriendRequest ?? false) ? 0: 1)
                        .opacity(user.areFriends ?? false ? 0: 1)
                    
                        
                        
                        // If they are already friends only show them options to remove friend
                        TabView(selection: $user.areFriends ){
                            
                        
                           
                            Button {
                                
                               print("Friends Already ")
                               
                                    
                            } label: {
                                
                                
                                    
                                   
                                        
                                      
                                Image(systemName: "checkmark.shield.fill")
                                   .foregroundColor(.green)
                                
                                        
                                        
                            
                                   
                                    
                                    Text("Friends")
                                         .bold()
                                         .foregroundColor(Color.primary.opacity(0.4))
                                       
                                
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
                                        
                                    }
                                   
                                    
                                    Text("Remove Friend")
                                         .bold()
                                         .foregroundColor(.red)
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
                                 
                              
                                 if let id = user.id{
                                     print("Winking at ... \(id)")
                                     
                                     if user.winkedTo ?? false  {
                                         // unwink
                                         Account().unwink(at: id)
                                     } else {
                                         
                                         Account().wink(at: id )
                                     }
                                    
                                 }
                                
                                 
                             } label: {
                                 
                                 ZStack{
                                     
                                     Text((!(user.winkedTo ?? false)) ? "😉 Wink": "😬 Unwink" )
                                          .bold() // NEW BLUE
                                         //.foregroundColor(Color.primary.opacity(0.4))
                                          .foregroundColor(!(user.winkedTo ?? false) ? .blue.opacity(0.7) : .red.opacity(0.7))
                                          .opacity(!(user.winkedAtMe ?? false) ? 1: 0)
                                     
                                     Text((!(user.winkedTo ?? false)) ? "😉 Wink Back": "😬 Unwink" )
                                         .bold() // NEW BLUE
                                        // .foregroundColor(Color.primary.opacity(0.4))
                                         .foregroundColor(!(user.winkedTo ?? false) ? .blue.opacity(0.7) : .red.opacity(0.7))
                                         .opacity(user.winkedAtMe ?? false ? 1: 0)
                                 }
                               
                                 
                                 
                                 
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
    /* .onChange(of: user, perform: { user_selected in
            
            guard let me = Auth.auth().currentUser?.uid , let them = user_selected?.id else  {
                
                print("Could not get me: \(Auth.auth().currentUser?.uid) or them: \(user_selected?.id) ")
                
                return
            }
         
         
            //Checking If we are already friends
         
         print("Checking if we are already friends")
         account.db?.collection("friends").document(me).collection("myFriends").document(them).addSnapshotListener({ snapshot, error in
             
             if snapshot?.exists ?? false {
                 // friends already
                 
                 withAnimation {
                     friendsAlready = true
                 }
             } else {
                 
                 withAnimation {
                     friendsAlready = false
                 }
                
             }
         })
         
         
         // Listener at this user's friend requests, check if I sent a friend to this user
        print("Listening for friend requests")
         account.db?.collection("friends").document(them).collection("requests").document(me).addSnapshotListener({ snapshot, error in
             
             if snapshot?.exists ?? false {
                 // There is a friend request there that I sent to this user
                 let didAccept: Bool  = snapshot?.data()?["accepted"] as? Bool ?? false
                 withAnimation {
                     sentFriendRequest = !didAccept
                 }
                 
                 
             }  else {
                 // there is most definitely no friend pending
                 withAnimation {
                     sentFriendRequest = false
                 }
                
             }
         })
         
         // Checking if friend requests were sent to me
         print("Listening for friend requests that i hsould respond to")
          account.db?.collection("friends").document(me).collection("requests").document(them).addSnapshotListener({ snapshot, error in
              
              if snapshot?.exists ?? false {
                  // They sent me (current signed in user) a friend request
                 
                  withAnimation {
                      shouldRespondToFriendRequest = true
                  }
                  
                  
              }  else {
                  // They did not send me a freind request
                  withAnimation {
                      shouldRespondToFriendRequest = false
                  }
                 
              }
          })
         
         
         
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
         
         
         // See if the other user winked back
         account.db?.collection("winks").document(me).collection("people_who_winked").document(them).addSnapshotListener({ snapshot, error in
             
             print("*** THe snapshot is \(snapshot) with error \(error)")
             
             if snapshot?.exists ?? false {
                 withAnimation {
                     
                     canWinkBack = true
                 }
                
             } else {
                 canWinkBack = false
             }
         })
        }) */
        
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

 
