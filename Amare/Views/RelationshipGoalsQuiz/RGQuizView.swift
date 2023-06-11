//
//  QuizView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/23.
//




import SwiftUI
/// Relationship Goals Quiz View.  This is the main view that shows the relationship goals questions 
struct RGQuizView: View {
	
	@ObservedObject var quizViewModel = RGQuizViewModel()
	
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
							
						
						
                        
						
                        // Use the function inside ForEach
                        ForEach(Array(RGQuizQuestion.allCases.enumerated()), id: \.1) { index, question in
                            questionAndAnswerViews(index: index, question: question)
                        }
						
					}
                    
                    .environmentObject(quizViewModel)
					.rotationEffect(.degrees(-90)) // We rotate the content in the tab view so that it's vertical
									.frame(
										width: proxy.size.width,
										height: proxy.size.height
									)
					
					
				}
				.disabled(disablePaging)
				.animation(.easeInOut)
                //.navigationTitle(Text("Unlock Your Relationship Potential"))
				//.navigationBarTitleDisplayMode(.large)
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
    
    
    func questionAndAnswerViews(index: Int, question: RGQuizQuestion) -> some View {
        let tag = index*2 + 2
        let tag2 = tag + 1
        return Group {
            QuestionView(question: question)
                .onAppear{
                    quizViewModel.currentQuestion = question
                }
                .tag(tag)
            
            AnswerView(nextPage: nextPage, responses: question.responses, question: question)
                .onAppear{
                    quizViewModel.currentQuestion = question
                }
                .tag(tag2)
        }
    }

   

}




struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        RGQuizView(/*viewModel: QuizViewModel()*/)
    }
}




