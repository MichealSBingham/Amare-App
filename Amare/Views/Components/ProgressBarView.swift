//
//  ProgressIndicator.swift
//  Amare
//
//  Created by Micheal Bingham on 6/10/23.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var progress: Double

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(DefaultProgressViewStyle()) // Apply the default progress view style
        }
    }
}


struct ProgressBarView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var progress: Double = 0.5
        @State private var model = OnboardingViewModel()
        
        var body: some View {
            VStack {
                ProgressBarView(progress: $model.progress)
                
                Button {
                    withAnimation {
                        model.currentPage = OnboardingScreen.allCases.randomElement()!
                    }
                } label: {
                    Text("Animate Progress ")
                }
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
