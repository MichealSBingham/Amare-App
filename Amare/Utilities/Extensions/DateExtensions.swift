//
//  DateExtensions.swift
//  Amare
//
//  Created by Micheal Bingham on 6/24/23.
//

import Foundation

extension Date {
	/**
	 Combines the date from the instance (`self`) and time from the provided date (`time`) into a new `Date` instance.
	 
	 - Parameters:
		- time: The `Date` instance from which to extract the time.
		- timeZone: The `TimeZone` instance to use when combining date and time. Defaults to the current time zone.
	 
	 - Returns: A new `Date` instance with the date from `self` and time from `time`.
				Returns `nil` if the date and time couldn't be combined into a valid date.
	 
	 - Example:
	 ```swift
	 let bday: Date = // The date set to 7/21/1999.
	 let selectedTime: Date = // The time selected from the DatePicker.
	 let finalDate = bday.combineWithTime(time: selectedTime)
	 ```
	 This will return a new `Date` object that has the date from `bday` and the time from `selectedTime`.
	 */
	func combineWithTime(time: Date, timeZone: TimeZone = .current) -> Date? {
		var calendar = Calendar.current
		calendar.timeZone = timeZone

		let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
		let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

		var combinedComponents = DateComponents()
		combinedComponents.year = dateComponents.year
		combinedComponents.month = dateComponents.month
		combinedComponents.day = dateComponents.day
		combinedComponents.hour = timeComponents.hour
		combinedComponents.minute = timeComponents.minute
		combinedComponents.timeZone = timeZone

		return calendar.date(from: combinedComponents)
	}
	
	
	
	/**
		 Combines the date from the instance (`self`) and a "noon" time into a new `Date` instance.
		 
		 - Parameters:
			- timeZone: The `TimeZone` instance to use when combining date and time. Defaults to the current time zone.
		 
		 - Returns: A new `Date` instance with the date from `self` and time set to "noon".
					Returns `nil` if the date and time couldn't be combined into a valid date.
		 
		 - Example:
		 ```swift
		 let bday: Date = // The date set to 7/21/1999.
		 let noonDate = bday.combineWithNoon()
		 ```
		 This will return a new `Date` object that has the date from `bday` and the time set to noon.
		 */
		func setToNoon(timeZone: TimeZone = .current) -> Date? {
			var calendar = Calendar.current
			calendar.timeZone = timeZone

			let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)

			var combinedComponents = DateComponents()
			combinedComponents.year = dateComponents.year
			combinedComponents.month = dateComponents.month
			combinedComponents.day = dateComponents.day
			combinedComponents.hour = 12 // set the time to "noon"
			combinedComponents.minute = 0
			combinedComponents.second = 0
			combinedComponents.timeZone = timeZone

			return calendar.date(from: combinedComponents)
		}
	
	
	func string(from timezone: TimeZone? = .current) -> String {
			 let formatter = DateFormatter()
			 formatter.dateFormat = "cccc, MMMM d, YYYY h:m a vvvv"
			 formatter.timeZone = timezone
			 return formatter.string(from: self)
				
			}
	

}
