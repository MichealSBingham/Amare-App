//
//  PersonalityStatement.swift
//  Amare
//
//  Created by Micheal Bingham on 11/8/23.
//

import Foundation
import LoremSwiftum
struct PersonalityStatement {
    let description: String
    let judgement: TraitCategory?
    
}



extension PersonalityStatement {
    static func random() -> PersonalityStatement {
        
        return PersonalityStatement(
            description: Lorem.sentences(1), judgement: nil
        )
    }
    
    static func random(n: Int) -> [PersonalityStatement] {
        var p: [PersonalityStatement] = []
        
        for i in 0..<n {
            p.append(PersonalityStatement.random())
            
        }
       return p
    }
    
    
}

