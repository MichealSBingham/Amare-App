//
//  PositiveActionOnUserMenu.swift
//  Amare
//
//  Created by Micheal Bingham on 10/11/21.
//

import SwiftUI

/// This should be changed to a floating button soon one day this is just a rough draft of actions a user can each other
struct PositiveActionOnUserMenu: View {
    
    var user: AmareUser?
    
    /*@State*/ var winkstatus: Bool? = nil
    
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
                                 
                                 Text((!(winkstatus ?? false)) ? "😉 Wink": "😉 Wink Back" )
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
        
    }
}

/*
struct PositiveActionOnUserMenu_Previews: PreviewProvider {
    static var previews: some View {
     //   PositiveActionOnUserMenu().preferredColorScheme(.dark)
    }
}
 */
