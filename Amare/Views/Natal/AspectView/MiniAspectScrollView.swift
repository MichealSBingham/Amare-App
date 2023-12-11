//
//  MiniAspectScrollView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/10/23.
//

import SwiftUI

struct MiniAspectScrollView: View {
    @EnvironmentObject var model: UserProfileModel
    
    var interpretations: [String:String] = [:]
    var aspects: [Aspect] = []
    var isHistorical: Bool = false
    
    
    var body: some View {
        ZStack{
            ScrollView{
                
                ForEach(aspects){ aspect in
                    
                    NavigationLink{
                        
                        
                     
                        MiniAspectVerticalPageView(interpretations: interpretations, aspects: aspects, selectedAspect: aspect)
                            
                        

                        
                    } label: {
                        
                        MiniAspectView(interpretation: interpretations[aspect.name], firstBody:aspect.first , secondBody: aspect.second, orb: aspect.orb, name: aspect.name, aspectType: aspect.type, numSentences: 2)
                            .padding()
                        
                         
                        
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(model.user?.totalFriendCount ?? 0 < 3 ? true : false )
                    
                }
            }
            
            .blur(radius: model.user?.totalFriendCount ?? 0 < 3 ? 3.0: 0)
            
            
        
            Text("Add *3 friends* to unlock deeper insights into a story about a journey we call **your life**. It's worth it!")
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.01)
                .opacity(model.user?.totalFriendCount ?? 0 < 3 ? 1: 0)
                .offset(y:-100)
        }
       
    }
}

#Preview {
    MiniAspectScrollView()
}
