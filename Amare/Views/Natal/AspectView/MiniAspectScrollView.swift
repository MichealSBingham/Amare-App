//
//  MiniAspectScrollView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/10/23.
//

import SwiftUI
import Firebase

struct MiniAspectScrollView: View {
    @EnvironmentObject var model: UserProfileModel
    @StateObject var viewedUserModel: UserProfileModel
    
    var interpretations: [String:String] = [:]
    var aspects: [Aspect] = []
    var isHistorical: Bool = false
    
    var belongsToUserID: String = Auth.auth().currentUser?.uid ?? "random"
    
    
    var body: some View {
        ZStack{
            ScrollView{
                
                ForEach(aspects){ aspect in
                    
                    NavigationLink{
                        
                        
                     
                        MiniAspectVerticalPageView(interpretations: interpretations, aspects: aspects, user_id: belongsToUserID, selectedAspect: aspect)
                            
                        

                        
                    } label: {
                        
                        MiniAspectView(interpretation: interpretations[aspect.name.replacingOccurrences(of: " ", with: "")], firstBody:aspect.first , secondBody: aspect.second, orb: aspect.orb, name: aspect.name, aspectType: aspect.type, belongsToUserID: belongsToUserID, numSentences: 2)
                            .padding()
                            .onAppear(perform: {
                                print("the name is .. \(aspect.name)")
                                print("cleaned name is \(aspect.name.replacingOccurrences(of: " ", with: ""))")
                                
                            })
                        
                         
                        
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(model.user?.totalFriendCount ?? 0 < 1 ? true : false )
                    
                }
            }
            .disabled((model.user?.totalFriendCount ?? 0 < 1) || (viewedUserModel.friendshipStatus != .friends && viewedUserModel.user?.id != model.user?.id ) )
            .blur(radius: ((model.user?.totalFriendCount ?? 0 < 1) || (viewedUserModel.friendshipStatus != .friends && viewedUserModel.user?.id != model.user?.id ) ) ? 3.0: 0)
            
            
        
            Text("Add *just one friend* to unlock deeper insights into a story about a journey we call **your life**. It's worth it!")
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.01)
                .opacity(model.user?.totalFriendCount ?? 0 < 1 ? 1: 0)
                .offset(y:-100)
            
            Text("This profile is private, send a friend request.")
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.01)
                .opacity(viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == model.user?.id) ? 0 : 1)
                .offset(y:-100)
            
        }
       
        .onAppear {
            print("\n\n\n\n\n======The interpretations are \(interpretations) ")
        }
    }
}

#Preview {
    MiniAspectScrollView(viewedUserModel: UserProfileModel())
}
