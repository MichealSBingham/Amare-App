//
//  PickAttractivePeopleView.swift
//  Love
//
//  Created by Micheal Bingham on 7/6/21.
//

import SwiftUI
import NavigationStack

struct PickAttractivePeopleView: View {
    
    /// To manage navigation
    @EnvironmentObject var navigation: NavigationModel
    
    /// id of view
    static let id = String(describing: Self.self)
    
    @State private var someErrorOccured: Bool = false
    @State private var alertMessage: String  = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/) 
    }
}

struct PickAttractivePeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PickAttractivePeopleView()
    }
}
