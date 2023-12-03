//
//  View+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 10/22/23.
//

import Foundation
import SwiftUI

extension View {
    func tabBar(hidden: Bool) -> some View {
        self
            .background(TabBarAccessor { tabBar in
                tabBar.isHidden = hidden
            })
    }
    
    func conditionalColorInvert() -> some View {
        self.modifier(ConditionalColorInvert())
    }
    
}


/// Custom View Modifiers
extension View {
    @ViewBuilder
    func hideNativeTabBar() -> some View {
        self
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func tabSheet<SheetContent: View>( showSheet: Binding<Bool>, initialHeight: CGFloat = 100, sheetCornerRadius: CGFloat = 15, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        self
            .modifier(BottomSheetModifier(showSheet:  showSheet, initialHeight: initialHeight, sheetCornerRadius: sheetCornerRadius, sheetView: content()))
    }
}


/// Custom TabView Modifier
extension TabView {
    @ViewBuilder
    func tabSheet<SheetContent: View>( showSheet: Binding<Bool>, initialHeight: CGFloat = 100, sheetCornerRadius: CGFloat = 15, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        self
            .modifier(BottomSheetModifier(showSheet:  showSheet, initialHeight: initialHeight, sheetCornerRadius: sheetCornerRadius, sheetView: content()))
    }
}

/// Helper View Modifier
fileprivate struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var showSheet: Bool
    var initialHeight: CGFloat
    var sheetCornerRadius: CGFloat
    var sheetView: SheetContent
    /// View Properties
    
    @EnvironmentObject var viewRouter: ViewRouter
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet, content: {
                VStack(spacing: 0) {
                    sheetView
                        .background(.regularMaterial)
                        .zIndex(0)
                    
                    Divider()
                        .hidden()
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 55)
                }
                .presentationDetents([.height(initialHeight), .medium, .fraction(0.99)])
                .addSheetProperties(sheetCornerRadius)
                .interactiveDismissDisabled()
               /* .onChange(of: viewRouter.currentPage, perform: { page in
                    
                    if page == .map{
                        showSheet = true
                    } else {
                        showSheet = false
                    }
                }) */
                .onAppear {
                    
                    print("Current in bottom sheet modifier scene: \(UIApplication.shared.connectedScenes.first)")
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        // Now you have access to your SceneDelegate
                        print("Found the scne in bottom sheet")
                        if let controller = sceneDelegate.windowScene?.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController, #unavailable(iOS 16.4) {
                            sheet.preferredCornerRadius = sheetCornerRadius
                            sheet.largestUndimmedDetentIdentifier = .medium
                            controller.view.backgroundColor = .clear
                        }
                    }

                    
                    
                }
            })
    }
}

extension View {
    @ViewBuilder
    func addSheetProperties(_ cornerRadius: CGFloat) -> some View {
        if #available(iOS 16.4, *) {
            self
                .presentationCornerRadius(cornerRadius)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationBackground(.clear)
        } else {
            self
        }
    }
}

/// Clearing Background's Of View like NavigationStack and TabView
struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

/// Custom View Modifier
extension View {
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color) -> some View {
        self
            .modifier(
                ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
            )
    }
}

fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    /// View Properties
    @State private var particles: [Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .font(font)
                            .foregroundColor(status ? activeTint : inActiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            /// Only Visible When Status is Active
                            .opacity(status ? 1 : 0)
                            /// Making Base Visibility With Zero Animation
                            .animation(.none, value: status)
                    }
                }
                .onAppear {
                    /// Adding Base Particles For Animation
                    if particles.isEmpty {
                        /// Change Count as per your wish
                        for _ in 1...15 {
                            let particle = Particle()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        /// Reset Animation
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        /// Activating Particles
                        for index in particles.indices {
                            /// Random X & Y Calculation Based on Index
                            let total: CGFloat = CGFloat(particles.count)
                            let progress: CGFloat = CGFloat(index) / total
                            
                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 60
                            
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
                            /// Min Scale = 0.35
                            /// Max Scale = 1
                            let randomScale: CGFloat = .random(in: 0.35...1)
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                /// Extra Random Values For Spreading Particles Across the View
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                
                                particles[index].randomX = randomX + extraRandomX
                                particles[index].randomY = -randomY - extraRandomY
                            }
                            
                            /// Scaling With Ease Animation
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            /// Removing Particles Based on Index
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
                                .delay(0.25 + (Double(index) * 0.005))) {
                                    particles[index].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}
