//
//  ChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject private var account: Account
    
    var body: some View {
        Text("Your natal chart will be here.")
            .foregroundColor(.white)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView().environmentObject(Account()).preferredColorScheme(.dark)
    }
}
