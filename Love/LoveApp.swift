//
//  LoveApp.swift
//  Love
//
//  Created by Micheal Bingham on 6/15/21.
//

import SwiftUI

@main
struct LoveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
