//
//  Background.swift
//  Amare
//
//  Created by Micheal Bingham on 7/1/23.
//

import SwiftUI

struct Background: View {
	@EnvironmentObject var viewModel: BackgroundViewModel
	
	/// Style of gradient animation rotation
	var style: Style = .normal
	@State var start = UnitPoint.leading
	@State var end = UnitPoint.trailing

	var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

	var body: some View {
		Group {
			if viewModel.isSolidColor {
				viewModel.solidColor.opacity(viewModel.opacity)
			} else {
				LinearGradient(gradient: Gradient(colors: viewModel.colors), startPoint: start, endPoint: end)
					.opacity(viewModel.opacity)
			}
		}
		.animation(Animation.easeInOut(duration: 2), value: start) /// don't forget the `value`!
		.onReceive(timer) { _ in
			self.start = nextPointFrom(self.start)
			self.end = nextPointFrom(self.end)
		}
		.edgesIgnoringSafeArea(.all)
	}

	/// cycle to the next point
	func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
		switch currentPoint {
		case .top:
			return .topTrailing
		case .topLeading:
			return .top
		case .leading:
			return .topLeading
		case .bottomLeading:
			return .leading
		case .bottom:
			return .bottomLeading
		case .bottomTrailing:
			return .bottom
		case .trailing:
			return .bottomTrailing
		case .topTrailing:
			return .trailing
		default:
			print("Unknown point")
			return .top
		}
	}
}
 

/*
/// Sets the background of the view with a moving gradient of set colors.
/// - Parameters
///    - style: The style of the gradient's animation. By default, `.normal` swirls the colors in one direction
struct Background: View {
	
	
	
	/// Style of gradient animation rotation
	var style: Style = .normal
	@State var start = UnitPoint.leading
	@State var end = UnitPoint.trailing

	var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
	
	@State var colors = [ Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
				   Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00)) ]
	
	@State var colorsExtended = [ Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
		 
									.blue]
	
	
	var body: some View {
		LinearGradient(gradient: Gradient(colors: colors /*!(style == .creative) ? colors: colorsExtended*/), startPoint: start, endPoint: end)
			.animation(Animation.easeInOut(duration: 2), value: start) /// don't forget the `value`!
			.onReceive(timer) { _ in
				/*
				self.start = nextPointFrom(style == .normal ? self.start : self.end)
				self.end = nextPointFrom(style == .normal ? self.end: self.start)
				 */
				
				self.start = nextPointFrom(self.start)
				self.end = nextPointFrom(self.end)

			}
			.edgesIgnoringSafeArea(.all)
	}
	
	/// cycle to the next point
	func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
		switch currentPoint {
		case .top:
			return .topTrailing
		case .topLeading:
			return .top
		case .leading:
			return .topLeading
		case .bottomLeading:
			return .leading
		case .bottom:
			return .bottomLeading
		case .bottomTrailing:
			return .bottom
		case .trailing:
			return .bottomTrailing
		case .topTrailing:
			return .trailing
		default:
			print("Unknown point")
			return .top
		}
	}
	
	
}
*/


/// Style of gradient view animating
enum Style {
	/// Color gradient swirls quickly and the point of rotation swifts
	case fast
	/// Color graident swirls in one clockwise direction
	case normal
	
	case creative
}


struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}

