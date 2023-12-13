//
//  QuestionView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//

import SwiftUI

struct QuestionView: View {
    
    var question: RGQuizQuestion
    
    var body: some View {
        
        VStack{
			
            Text(.init(question.rawValue))
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            
           
            
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(question: RGQuizQuestion.allCases.randomElement()!)
    }
}






