//
//  CometView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/5/23.
//

import SwiftUI






import SwiftUI

struct CometView: View {
    @State private var cometPosition = CGPoint(x: -100, y: -100)
    @State private var isAnimating = false
    
    let trailLength: CGFloat = 600
    let cometSize: CGFloat = 20

    // Randomize the starting and ending positions of the comet
    private func randomizeCometPosition(in size: CGSize) -> (start: CGPoint, end: CGPoint) {
        let startX = CGFloat.random(in: -cometSize...size.width + cometSize)
        let startY = CGFloat.random(in: -cometSize...size.height + cometSize)
        let endX = CGFloat.random(in: -cometSize...size.width + cometSize)
        let endY = CGFloat.random(in: -cometSize...size.height + cometSize)
        
        return (start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Trail
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .white]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: trailLength, height: cometSize / 2)
                    .offset(x: cometPosition.x - trailLength / 2 + cometSize / 2, y: cometPosition.y)
                    .opacity(isAnimating ? 1 : 0) // Appear and disappear with the comet

                // Comet
                Circle()
                    .fill(Color.white)
                    .frame(width: cometSize, height: cometSize)
                    .offset(x: cometPosition.x, y: cometPosition.y)
            }
            .onAppear {
                let positions = randomizeCometPosition(in: geometry.size)
                cometPosition = positions.start
                
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                    cometPosition = positions.end
                    isAnimating = true
                }
            }
        }
    }
}






#Preview {
    ZStack{
        CometView().background(Color.black.edgesIgnoringSafeArea(.all))
        CometView().background(Color.black.edgesIgnoringSafeArea(.all))
        CometView().background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
}
