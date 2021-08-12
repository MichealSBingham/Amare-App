//
//  ForNavigation.swift
//  Love
//
//  Created by Micheal Bingham on 6/20/21.
//

import Foundation
import SwiftUI

/// Utility for NavigationView
struct NavigationUtil {
    
    
    /// Pops to Root View `EnterPhoneNumberView`. To be used when user is signing out.
    static func popToRootView() {
      
            findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
                .popToRootViewController(animated: true)
    
  }
    

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}


extension View {
    
    
    /// Change the color of the Navigation Bar Title
    /// - Parameters:
    ///   - backgroundColor: Background color of the bar
    ///   - titleColor: Title color of the bar
    /// - Returns: View
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
        
        
    }
    
}


struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}



/// Checks if the user finished the sign up process .
func isDoneWithSignUp() -> Bool {
   
    switch Settings.shared.viewType{
    case .main:
        return true
    default:
        return false
    }
    
}

/// Call this every time the profile is loaded so system knows  that when the app quits it does not need to restore sign up state . Set to false on screens during sign up flow
///  - **Deprecated** : Don't use this anymore because it doesn't work and it is not needed.
func doneWithSignUp(state: Bool = true )  {
    UserDefaults.standard.set(state, forKey: "isDoneWithSignUp")
}


/// Used to determine what screen the user was on so that we log the user out if the app quits before they finish signing up
class Settings: ObservableObject {
    static let shared = Settings()

    @Published var viewType: ViewType!
}

/// View the user is on
enum ViewType {
    case EnterNameView, EnterGenderView, EnterOrientationView, FromWhereView, EnterBirthdayView, LiveWhereView, ImageUploadView, main
}

