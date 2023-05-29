//
//  RGQuizViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/23.
//

import Foundation
import SwiftUI
import Combine

class RGQuizViewModel: ObservableObject {
    
    @Published var userResponses: [RGQuizQuestion: RGResponse] = [:]
    @Published var currentQuestion: RGQuizQuestion? = nil 

    // Add other properties and methods as needed
    
    func submitAnswer(question: RGQuizQuestion, response: RGResponse) {
        userResponses[question] = response
    }

}
