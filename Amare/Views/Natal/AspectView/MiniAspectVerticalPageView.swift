//
//  MiniAspectVerticalPageView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/10/23.
//

import SwiftUI



struct MiniAspectVerticalPageView: View {
    var interpretations: [String: String] = [:]
    var aspects: [Aspect] = []
    var user_id: String

    @State  var selectedAspect: Aspect // Use a UUID or any unique identifier for planets

    var body: some View {
        TabView(selection: $selectedAspect) {
            
            ForEach(aspects) { aspect in
                
                MiniAspectView(interpretation: interpretations[aspect.name.replacingOccurrences(of: " ", with: "")], firstBody:aspect.first , secondBody: aspect.second, orb: aspect.orb, name: aspect.name, aspectType: aspect.type, belongsToUserID: user_id)
            
                    .tag(aspect)
                .buttonStyle(PlainButtonStyle())
            }
        }
      
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
    }
}

/*
#Preview {
    MiniAspectVerticalPageView()
}
*/
