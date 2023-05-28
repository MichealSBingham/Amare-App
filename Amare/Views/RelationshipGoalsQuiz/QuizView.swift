//
//  QuizView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//


import SwiftUI

struct QuizView: View {
    
    var body: some View {
        
        GeometryReader{ proxy in
            
            TabView {
                
                Group{
                    
                    ForEach(RGQuizQuestion.allCases){ question in
                        
                        QuestionView(question: question)
                    }
                    
                    
                }
                .rotationEffect(.degrees(-90)) // Rotate content
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height
                                )
                
                
            }
           
            .frame(
                            width: proxy.size.height, // Height & width swap
                            height: proxy.size.width
                        )
                        .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
                        .offset(x: proxy.size.width) // Offset back into screens bounds
                        .tabViewStyle(
                            PageTabViewStyle(indexDisplayMode: .never)
                        )
            
        }
        
       
      
    }
}




struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(/*viewModel: QuizViewModel()*/)
    }
}


// QuizViewModel.swift

import Foundation
/*
class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var userAnswers = [String?]()
    
    
    let q1 = "You and your partner can't agree on which Netflix series to binge next. Your partner is really into a crime thriller, but you're in the mood for a comedy. What's your move?"
    
    let quizQuestions: [QuizQuestion] = [
        QuizQuestion(id: UUID(), question: QuizData.question1, choices: QuizData.question1Choices, correctAnswer: "Choice 1"),
        QuizQuestion(id: UUID(), question: "Question 2", choices: ["Choice 1", "Choice 2", "Choice 3"], correctAnswer: "Choice 2"),
        // Add more questions as needed
    ]
    
    var currentQuestion: QuizQuestion {
        quizQuestions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == quizQuestions.count - 1
    }
    
    func selectAnswer(_ answer: String) {
        userAnswers.append(answer)
    }
    
    func checkAnswer() -> Bool {
        let userAnswer = userAnswers[currentQuestionIndex] ?? ""
        return userAnswer == currentQuestion.correctAnswer
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
    }
}
*/

// QuizQuestion.swift

struct QuizQuestion: Identifiable {
    let id: UUID
    let question: String
    let choices: [String]
    let correctAnswer: String
}


