//
//  MainEntry.swift
//  Amare
//
//  Created by Micheal Bingham on 12/28/22.
//

import SwiftUI

struct MainEntry: View {
    
    @State var menuSelection  = 2
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                FloatingTabbar(selected: $menuSelection)
                   
            }
            .sheet(isPresented: .constant(true)) {
                if #available(iOS 16.1, *) {
                    /*
                     NavigationView {
                        Text("People Nearby")
                            .navigationTitle(Text("Discover")
                                .padding(.vertical, -10))
                    }*/
                    VStack{
                        
                        HStack{
                            
                            Text("People")
                                .font(.largeTitle)
                               // .fontDesign(.rounded)
                                .padding()
                            Spacer()
                        }
                    
                        Spacer()
                    }
                    
                    
                        .presentationDetents([.fraction(CGFloat(0.10)), .medium])
                    
                } else {
                    // Fallback on earlier versions
                }
                    
            }
        }
    }
}

struct MainEntry_Previews: PreviewProvider {
    static var previews: some View {
        MainEntry()
    }
}
