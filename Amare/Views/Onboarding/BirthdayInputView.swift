//
//  BirthdayInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/23/23.
//

import SwiftUI

struct BirthdayInputView: View {
    
	@EnvironmentObject var model: OnboardingViewModel
    
    var body: some View {
        
        VStack{
            
            
            
            
            
            Spacer()
           
            Text("When Did Your Cosmic Journey Begin?")
                .bold()
                .font(.system(size: 40))
                //.lineLimit(1)
               // .minimumScaleFactor(0.01)
                .padding()
			
			
		   Text("Enter your birthday")
				.font(.system(size: 20))
				//.foregroundColor(.white)
				.padding()
			
            
			DatePicker("", selection: $model.birthday, in: ...Date().dateFor(years: -13),  displayedComponents: .date)
                .datePickerStyle(.wheel)
                            .padding()
							.labelsHidden()
							.environment(\.timeZone, model.homeCityTimeZone ?? .current)
			
       
			NextButtonView {
				withAnimation {
					model.currentPage = .birthtime
				}
			}
       
            
            
         
            
            Spacer()
         
                
            Spacer()
               
 
                
            }
		.onAppear{
			
			// Dismiss the keyboard
			UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

		}
		

    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView()
			.environmentObject(OnboardingViewModel())
    }
}
