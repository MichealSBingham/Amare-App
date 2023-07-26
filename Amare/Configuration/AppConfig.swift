//
//  AppConfig.swift
//  Amare
//
//  Created by Micheal Bingham on 6/22/23.
//

import Foundation

/// Enum to switch between `production`, `development`, and `testing` environments 
enum AppEnvironment {
    case production
    case development
    case testing
    case preview 
}

struct AppConfig {
    static var environment: AppEnvironment = .testing // default to production
    // You can add more properties as per your need
}


