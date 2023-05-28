//
//  QuizView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//


import SwiftUI
/// Relationship Goals Quiz View.  This is the main view that shows the relationship goals questions 
struct QuizView: View {
	
	
	
	@State var startDate = Date.now
	@State var timeElapsed: Int = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@State var currentPage = 0
	
	
	@State var disablePaging = false
	
	///use this so that the page never disables again
	@State var neverDisablePagingAgain = false
	
    
    var body: some View {
        
	
			GeometryReader{ proxy in
				
				TabView(selection: $currentPage){
					
					
					Group{
						
						BeginQuizView()
							.tag(0)
							.onReceive(timer) { firedDate in
								// This is executed every second
								timeElapsed = Int(firedDate.timeIntervalSince(startDate))
								
								// After 3 seconds, switch to the next page if the user hasn't already done it
								if timeElapsed == 3 && currentPage == 0{
									
										currentPage+=1
									
								}
								
							}
							
						
						BeginQuizBodyView(disablePaging: $disablePaging, nextPage: nextPage)
							.tag(1)
							.onAppear{
								if neverDisablePagingAgain == false {
									disablePaging = true
								}
								
							}
							.onDisappear{
								neverDisablePagingAgain = true 
							}
							
						
						
						
						ForEach(Array(RGQuizQuestion.allCases.enumerated()), id: \.1){ index, question in
							
							QuestionView(question: question)
								.tag(index + 2 )
						}
						
						
					}
					.rotationEffect(.degrees(-90)) // We rotate the content in the tab view so that it's vertical
									.frame(
										width: proxy.size.width,
										height: proxy.size.height
									)
					
					
				}
				.disabled(disablePaging)
				.animation(.easeInOut)
				.navigationTitle(Text("Unlock Your Relationship Potential"))
				.navigationBarTitleDisplayMode(.large)
				// We need to rotate the tab view itself to enable vertical pagging
			   
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
	
	
	func nextPage() {
		  currentPage += 1
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


