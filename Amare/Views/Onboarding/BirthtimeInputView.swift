//
//  BirthtimeInputView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import SwiftUI



struct BirthtimeInputView: View {
	
	@EnvironmentObject var model: OnboardingViewModel
	
	
	@State var showBDayConfirmationAlert: Bool = false

	///This is for the alert that shows if the user does not know his birth time.
	@State var showAlertForNoTimeSelection: Bool = false
	
	var body: some View {
		
		VStack{
			
			
			
			
			
			Spacer()
		   
			Text("What Time Were You Born?")
				.bold()
				.font(.system(size: 40))
				//.lineLimit(1)
			   // .minimumScaleFactor(0.01)
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
			Text("I'm not sure when I was born.")
				 .font(.system(size: 20))
				 //.foregroundColor(.white)
				 .padding()
		}
		.buttonStyle(PlainButtonStyle())
		.foregroundColor(.accentColor)

	}
	
	func alertMessageForNoTimeZone() -> Alert {
		Alert(
			title: Text("What is your timezone?"),
			message: Text("Please go back and select your hometown. We don't know your timezone."),
			
			
			dismissButton: .default(Text("Ok"), action: {
				withAnimation{
					model.currentPage = .hometown
				}
				
			}) )
		
	}
	
	
	func alertMessageForBirthtime() -> Alert {
		Alert(
			title: Text("Call Your Mom"),
			message: Text("We need your birth time for accuracy. \nIt's likely your mother knows it. \n\nWithout it, crucial compatibility details will be missing, but we can still proceed. \n\nNote: You can't add it later. You can also check your birth certificate."),
			
			
			primaryButton: .default(Text("I'll find it"), action: {
				
				
			}),
			
			secondaryButton: .cancel(Text("I can't"), action: {
				// Set the user time to 12pm Noon
				model.knowsBirthTime = false
				model.birthday = model.birthday.setToNoon()!
				withAnimation {
					model.currentPage = .genderSelection
				}

			})
		)
	}
	
	func alertMessageForBirthdayConfirmation() -> Alert {
		
		
		Alert(
			title: Text("Is this when you were born?"),
			message: Text("\(model.birthday.string(from: model.homeCityTimeZone))"),
			
			
			primaryButton: .default(Text("Yes"), action: {
				
				if model.knowsBirthTime == nil { model.knowsBirthTime = true }
				withAnimation {
					model.currentPage = .genderSelection
				}
				
			}),
			
			secondaryButton: .destructive(Text("No"), action: {
				// Set the user time to 12pm Noon
				

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
