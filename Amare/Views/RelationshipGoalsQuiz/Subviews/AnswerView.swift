//
//  AnswerView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/23.
//

import SwiftUI

struct AnswerView: View {
    
    @EnvironmentObject private var quizModel: RGQuizViewModel

    var responses: [RGResponse]
    
    var body: some View {
        
        VStack{
            
            ForEach(responses) { response in
                
    
                Button {
                    
                    
                    guard let q = quizModel.currentQuestion else{
                        //TODO: error handle this
                        return
                    }
                    
                    quizModel.submitAnswer(question: q, response: response)
                    
                    
                } label: {
                    
                    AnswerChoiceButtonView(response: response)
                }
                .buttonStyle(.plain)

                
                    

                
            }
            
        }
    }
    
    
    
    struct AnswerChoiceButtonView: View{
        
        var response: RGResponse
        
        var body: some View{
            
         
                Text(.init(response.rawValue))
                
                    //.foregroundColor(Color.accentColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .strokeBorder(Color.primary, lineWidth: 2)
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
        
      
        AnswerView(responses: [.o9, .o10, .o11, .o12])
    }
}
