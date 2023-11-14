//
//  CometView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/5/23.
//

import SwiftUI


import EffectsLibrary

 

struct MovingImageView: View {
  //  let imageName: String
    let speed: Double
    
    @State private var startPosition: CGPoint = .zero
    @State private var endPosition: CGPoint = .zero
    @State private var isAnimating: Bool = false
    @State private var rotationAngle: SwiftUI.Angle = .zero

    var body: some View {
        GeometryReader { geometry in
           // Image(systemName: imageName) // Replace with your image name
           comet()
             //   .resizable()
              //  .scaledToFit()
             //   .frame(width: 50, height: 50) // Adjust the size as needed
                .rotationEffect(rotationAngle)
                .position(isAnimating ? endPosition : startPosition)
                .onAppear {
                    // Define the off-screen start and end positions
                    startPosition = CGPoint(x: -100, y: Double.random(in: 0...geometry.size.height))
                    endPosition = CGPoint(x: geometry.size.width + 300, y: Double.random(in: 0...geometry.size.height))
                    
                    // Calculate the rotation angle
                    rotationAngle = SwiftUI.Angle(radians: atan2(endPosition.y - startPosition.y, endPosition.x - startPosition.x) - .pi / 2)
                    
                    // Start the animation
                    withAnimation(.linear(duration: speed)) {
                        isAnimating = true
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make GeometryReader fill the space
    }
    
    func comet() -> some View {
        
        ZStack{
            FireView()
                .colorInvert()
            Text("🪨") // Your emoji here
                        .font(.system(size: 100))
                        .rotation3DEffect(
                                        .degrees(180),
                                        axis: (x: 1.0, y: 0.0, z: 0.0)
                                    )
            
        }
        
    }
}

 
 

 





#Preview {
    ZStack{
        MovingImageView(speed: 1.5)
            
    }
    
}
