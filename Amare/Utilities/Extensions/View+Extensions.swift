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
