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
}
