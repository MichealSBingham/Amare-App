//
//  TabViewUI.swift
//  Amare
//
//  Created by Micheal Bingham on 12/28/22.
//

import SwiftUI

struct TabViewUI: View {
    
    @State var menu: Int = 0
    var body: some View {
        
        FloatingTabbar(selected: $menu)
    
    }
}

struct TabViewUI_Previews: PreviewProvider {
    static var previews: some View {
        TabViewUI()
    }
}


struct FloatingTabbar : View {
    
    @Binding var selected : Int
    @State var expand = false
    
    var body : some View{
        
     
            
            HStack{
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if !self.expand{
                        
                        Button(action: {
                            
                            self.expand.toggle()
                            
                        }) {
                            
                            Image(systemName: "arrow.left").foregroundColor(.black).padding()
                        }
                    }
                    
                    else{
                        
                        // Search Icon
                        Button(action: {
                            
                            withAnimation{
                                self.selected = 0
                            }
                           
                            
                        }) {

                            Image(self.selected == 0 ? "TabView/search2" : "TabView/search")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                                
                        }
                        Spacer()
                        
                        // MAP Icon
                        Button(action: {
                            
                            self.selected = 1
                            
                        }) {
                            
                            Image(self.selected == 1 ? "TabView/maps2" : "TabView/maps")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        
                        Button(action: {
                            
                            self.selected = 2
                            
                        }) {
                            
                            Image(self.selected == 2 ? "TabView/HomeIcon2" : "TabView/HomeIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        
                        Button(action: {
                            
                            self.selected = 3
                            
                        }) {
                            
                            Image(self.selected == 3 ? "TabView/messagesIcon2" : "TabView/messagesIcon")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        Spacer()
                        Button(action: {
                            
                            self.selected = 4
                            
                        }) {
                            
                            Image("TabView/maps2")
                                .resizable()
                                .frame(width: 25, height: 25)
                                //.foregroundColor(self.selected == 2 ? .black : .gray)//.padding(.horizontal)
                        }
                        
                        
                    }
                    
                    
                }.padding(.vertical,self.expand ? 20 : 8)
                .padding(.horizontal,self.expand ? 35 : 8)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(22)
                .onLongPressGesture {
                        
                        self.expand.toggle()
                }
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
            }
            
           
        
       
        

    }
}
