//
//  PulsingModifier.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import Foundation

import SwiftUI


struct Pulsing: ViewModifier {
	@Binding var isActive: Bool

	func body(content: Content) -> some View {
		if isActive {
			return AnyView(content
				.scaleEffect(1.0)
				.onAppear {
					withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
						isActive = false
					}
				}
				.scaleEffect(1.2))
		} else {
			return AnyView(content
				.scaleEffect(1.2)
				.onAppear {
					withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
						isActive = true
					}
				}
				.scaleEffect(1.0))
		}
	}
}

extension View {
	func pulsing(isActive: Binding<Bool>) -> some View {
		self.modifier(Pulsing(isActive: isActive))
	}
}

