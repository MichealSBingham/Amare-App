//
//  PulsingView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/22.
//

import SwiftUI

/// Shows a pulsing animation much like the pulse bubble that surrounds your location on a map / radar
struct PulsingView: View {
	
	//MARK: - For pulse animation
	@State private var animatePulse = false
	@State private var pulseColors: [Color] = [ .purple, .red, .orange, .yellow, .green, .blue]
	@State private var pulseColor: Color = .blue
	//TODO: this is 2 s on device
	let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
	@State private var counter = 0
	
	var size: CGFloat = 300
	
    var body: some View {
		
		
		Circle()
			.frame(width: size, height: size)
			.foregroundColor(pulseColor)
			.opacity(animatePulse ? 0: 0.5)
			.scaleEffect(animatePulse ? 1.4 : 0)
			.onReceive(timer) { time in
				
				if counter >= pulseColors.count {
					counter = 0
				}
				
		
				pulseColor = pulseColors[counter]
				counter = counter+1
			}
			.onAppear {
				DispatchQueue.main.async {
					withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)){
						animatePulse.toggle()
					}
				}
			}
    }
}

struct PulsingView_Previews: PreviewProvider {
    static var previews: some View {
        PulsingView()
			//.preferredColorScheme(.dark)
    }
}
