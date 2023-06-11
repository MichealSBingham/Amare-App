//
//  AnswerView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/23.
//

import SwiftUI

struct AnswerView: View {
    
    @EnvironmentObject private var quizModel: RGQuizViewModel
    
    var nextPage: (() -> Void)?

    var responses: [RGResponse]
    
    var question: RGQuizQuestion
    
    var body: some View {
        
        VStack{
            
            ForEach(responses) { response in
                
    
                Button {
                    
                    
                    
                    quizModel.submitAnswer(question: question, response: response)
                    
                    AmareApp().delay(0.5) {
                        nextPage?()
                    }
                    
                    
                    
                } label: {
                    
                    AnswerChoiceButtonView(response: response, question: question)
                }
                .buttonStyle(.plain)

                
                    

                
            }
            
        }
    }
    
    
    
    struct AnswerChoiceButtonView: View{
        
        @EnvironmentObject private var quizModel: RGQuizViewModel

        
        var response: RGResponse
        
        var question: RGQuizQuestion
        
        var body: some View{
            
         
                Text(.init(response.rawValue))
                
                    //.foregroundColor(Color.accentColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                            Capsule()
                                .fill(quizModel.userResponses[question] == response ? Color.green : Color.clear)
                                            )
                        
                        .overlay(
                            Capsule()
                                .stroke(Color.primary, lineWidth: 2)
                        )
                    
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1) // Adjust the value as needed
                    .padding(.horizontal, 20)
                   
            
        }
    }
}



struct AnswerView_Previews: PreviewProvider {
    
  

    static var previews: some View {
        
      
        AnswerView(responses: RGQuizQuestion.allCases.randomElement()!.responses, question: RGQuizQuestion.allCases.randomElement()!)
    }
}
