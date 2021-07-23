//
//  Animations.swift
//  Amare
//
//  Created by Micheal Bingham on 7/20/21.
//

import Foundation
import SwiftUI
import UIKit

/// Shake's a view
struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}
    
/// Animation modifier  to have text fade when it changes
struct FadeModifier: AnimatableModifier {
    // To trigger the animation as well as to hold its final state
    private let control: Bool

    // SwiftUI gradually varies it from old value to the new value
    var animatableData: Double = 0.0

    // Re-created every time the control argument changes
    init(control: Bool) {
        // Set control to the new value
        self.control = control

        // Set animatableData to the new value. But SwiftUI again directly
        // and gradually varies it from 0 to 1 or 1 to 0, while the body
        // is being called to animate. Following line serves the purpose of
        // associating the extenal control argument with the animatableData.
        self.animatableData = control ? 1.0 : 0.0
    }

    // Called after each gradual change in animatableData to allow the
    // modifier to animate
    func body(content: Content) -> some View {
        // content is the view on which .modifier is applied
        content
            // Map each "0 to 1" and "1 to 0" change to a "0 to 1" change
            .opacity(control ? animatableData : 1.0 - animatableData)

            // This modifier is animating the opacity by gradually setting
            // incremental values. We don't want the system also to
            // implicitly animate it each time we set it. It will also cancel
            // out other implicit animations now present on the content.
            .animation(nil)
    }
}

/// Sets the background of the view with a moving gradient of set colors.
/// - Parameters
///    - style: The style of the gradient's animation. By default, `.normal` swirls the colors in one direction
struct Background: View {
    /// Style of gradient animation rotation
    var style: Style = .normal
    @State var start = UnitPoint.leading
    @State var end = UnitPoint.trailing

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [ Color(UIColor(red: 1.00, green: 0.01, blue: 0.40, alpha: 1.00)),
                   Color(UIColor(red: 0.94, green: 0.16, blue: 0.77, alpha: 1.00)) ]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 2).repeatForever(), value: start) /// don't forget the `value`!
            .onReceive(timer) { _ in
                
                self.start = nextPointFrom(style == .normal ? self.start : self.end)
                self.end = nextPointFrom(style == .normal ? self.end: self.start)

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

/// Style of gradient view animating
enum Style {
    /// Color gradient swirls quickly and the point of rotation swifts
    case fast
    /// Color graident swirls in one clockwise direction
    case normal
}
