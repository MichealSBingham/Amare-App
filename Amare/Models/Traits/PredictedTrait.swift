//
//  PredictedTrait.swift
//  Amare
//
//  Created by Micheal Bingham on 11/5/23.
//

import Foundation
import SwiftUI

struct PredictedTrait {
    let name: String
    let category: TraitCategory
}

enum TraitCategory: String, CaseIterable {
    case likely, neutral, unlikely
}

extension PredictedTrait {
    static func randomTrait() -> PredictedTrait {
        let traits = ["Creative", "Adventurous", "Logical", "Empathetic", "Curious", "Stoic", "Energetic", "Introverted"]
        let categories: [TraitCategory] = [.likely, .neutral, .unlikely]
        
        return PredictedTrait(
            name: traits.randomElement()!,
            category: categories.randomElement()!
        )
    }
    
    
}

extension PredictedTrait {
    static var uniqueTraits: [PredictedTrait] {
        let traitNames = Set(["Adventurous", "Creative", "Diligent", "Empathetic", "Loyal", "Motivated", "Nurturing", "Optimistic", "Passionate"].shuffled())
        
        return traitNames.map { PredictedTrait(name: $0, category: TraitCategory.allCases.randomElement()!) }
    }
}


extension Array where Element == PredictedTrait {
    func likelyTraitNames() -> [String] {
        return self.filter { $0.category == .likely }
                   .map { $0.name }
    }
}
