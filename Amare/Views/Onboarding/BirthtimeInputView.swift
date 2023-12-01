//
//  BirthtimeInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import SwiftUI



struct BirthtimeInputView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	
	@Environment(\.dismiss) var dismiss
	
	
	@State var showBDayConfirmationAlert: Bool = false

	///This is for the alert that shows if the user does not know his birth time.
	@State var showAlertForNoTimeSelection: Bool = false
	
	/// If this is true, it will adjust the content of the view so that it's for creating another custom profile instead of onboarding the sign up user. i.e. instead of `Enter your name` it'll say `Enter their name`
	var customAccount: Bool = false
	
	var body: some View {
		
		VStack{
			
			
			
			
			
			Spacer()
		   
        
                Text(!customAccount ? "What Time Were You Born?" : "What Time Were They Born?" )
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.system(size: 50))
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
                    .padding()
            
				
			
			
		   
			
			
			DatePicker("", selection: $model.birthtime,  displayedComponents: .hourAndMinute)
				.environment(\.timeZone, model.homeCityTimeZone ?? .current)
				.datePickerStyle(.wheel)
							.padding()
							.labelsHidden()
							/*.onChange(of: model.birthtime) { time in
								guard let _ = model.homeCityTimeZone else { return }
								if let correctedDateWithTZ = model.birthday.combineWithTime(time: time, in: model.homeCityTimeZone!){
									model.birthday = correctedDateWithTZ
								}
								
							}
			*/
			
			
	   
			notSureOfBirthTimeView()
				.alert(isPresented: $showAlertForNoTimeSelection) {
								alertMessageForBirthtime()
						}
					
			
			NextButtonView {
				
				if let correctedDateWithTZ = model.birthday.combineWithTime(time: model.birthtime, in: model.homeCityTimeZone!){
					model.birthday = correctedDateWithTZ
					showBDayConfirmationAlert = true
				}
				
				
				
			}
			.disabled(model.homeCityTimeZone == nil)
			.opacity(model.homeCityTimeZone == nil  ? 0.5 : 1)
			.alert(isPresented: $showBDayConfirmationAlert){
				guard let _ = model.homeCityTimeZone else { return alertMessageForNoTimeZone() }
				return alertMessageForBirthdayConfirmation()
			}
	   
			
			
		 
			
			Spacer()
		 
				
			Spacer()
			   
 
				
			}
		.onAppear{
			// Dismiss the keyboard 
			UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

		}
	}
	
	func notSureOfBirthTimeView() -> some View {
		Button {
			showAlertForNoTimeSelection = true
		} label: {
			Text(!customAccount ? "I'm not sure when I was born." : "I'm not sure when they were born." )
				 .font(.system(size: 20))
				 //.foregroundColor(.white)
				 .padding()
		}
		.buttonStyle(PlainButtonStyle())
		.foregroundColor(.accentColor)

	}
	
	func alertMessageForNoTimeZone() -> Alert {
		Alert(
			title: Text(!customAccount ? "What is your timezone?" : "What is their timezone?"),
			message: Text(!customAccount ? "Please go back and select your hometown. We don't know your timezone." : "Please go back and select their hometown. We don't know their timezone." ),
			
			
			dismissButton: .default(Text("Ok"), action: {
                showAlertForNoTimeSelection = false
				withAnimation{
					model.currentPage = .hometown
				}
				
			}) )
		
	}
	
	
	func alertMessageForBirthtime() -> Alert {
		Alert(
			title: Text(!customAccount ? "Call Your Mom" : "Ask Them"),
			message: Text(!customAccount ? "We need your birth time for accuracy. \nIt's likely your mother knows it. \n\nWithout it, crucial compatibility details will be missing, but we can still proceed. \n\nNote: You can't add it later. You can also check your birth certificate." : "We need their birth time for accuracy. Without it, crucial compatibility details will be missing, but we can still proceed."),
			
			
			primaryButton: .default(Text("I'll find it"), action: {
				showAlertForNoTimeSelection = false
				
			}),
			
			secondaryButton: .cancel(Text("I can't"), action: {
				// Set the user time to 12pm Noon
				model.knowsBirthTime = false
				model.birthday = model.birthday.setToNoon()!
                showAlertForNoTimeSelection = false
                AmareApp().delay(1) {
                    DispatchQueue.main.async{
                        showBDayConfirmationAlert = true
                    }
                }
                
				withAnimation {
					
					//model.currentPage = .genderSelection
				}

			})
		)
	}
	
	func alertMessageForBirthdayConfirmation() -> Alert {
		
		
		Alert(
			title: Text(!customAccount ? "Is this when you were born?" : "Is this when they were born?"),
            message: Text("\(model.birthday.string(from: model.homeCityTimeZone, showTime: model.knowsBirthTime ?? false)) in \(model.homeCity?.cityStateCountry ?? "")"),
			
			
			primaryButton: .default(Text("Yes"), action: {
				
				if model.knowsBirthTime == nil { model.knowsBirthTime = true }
				withAnimation {
					
					model.currentPage = .genderSelection
				}
				
			}),
			
			secondaryButton: .destructive(Text("No"), action: {
				// Set the user time to 12pm Noon
                // go back to the first view because their information is wrong
                withAnimation{
                    model.currentPage = .name 
                }
				

			})
		)
	}
}


struct BirthtimeInputView_Previews: PreviewProvider {
    static var previews: some View {
		
		Group{
			BirthtimeInputView()
				.environmentObject(OnboardingViewModel())
				.environment(\.colorScheme, .light)
			
			BirthtimeInputView()
				.environmentObject(OnboardingViewModel())
				.environment(\.colorScheme, .dark)
			
		}
       
    }
}
