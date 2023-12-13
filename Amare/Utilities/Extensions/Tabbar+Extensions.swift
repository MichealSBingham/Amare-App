//
//  Tabbar+Extensions.swift
//  Amare
//
//  Created by Micheal Bingham on 10/22/23.
//

import Foundation
import SwiftUI

struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) -> UIViewController {
        TabBarAccessorViewController(callback)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {}
}

class TabBarAccessorViewController: UIViewController {
    var callback: (UITabBar) -> Void

    init(_ callback: @escaping (UITabBar) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBar = self.tabBarController?.tabBar {
            self.callback(tabBar)
        }
    }
}
