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
	func combineWithTime(time: Date, in timeZone: TimeZone = .current) -> Date? {
			var calendar = Calendar.current
			calendar.timeZone = timeZone
			
			var dateComponents = calendar.dateComponents(in: timeZone, from: self)
			print("Date components: \(dateComponents)")
			
			let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
			print("Time components before modification: \(timeComponents)")
			
			dateComponents.hour = timeComponents.hour
			dateComponents.minute = timeComponents.minute
			dateComponents.second = timeComponents.second
			
			print("Date components after modification: \(dateComponents)")
			
			let combinedDate = calendar.date(from: dateComponents)
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			dateFormatter.timeZone = timeZone
			print("Combined date in given timezone: \(String(describing: dateFormatter.string(from: combinedDate!)))")
			
			return combinedDate
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



extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    /// Returns the day of the date
    func day() -> Int {
        return self.get(.day, .month, .year).day ?? 0
    }
    
    /// Returns the year of the date
    func year() -> Int {
        return self.get(.day, .month, .year).year ?? 0
    }
    
    /// Returns the month of a date object. Or an empty string if something's wrong or no date given.
    func month() -> String {
        
        
        switch self.get(.day, .month, .year).month {
            
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return ""
            
        }
    }
    
    /// Returns proper date to ensure the time zone is correct. Pass in a time zone and it'll return the proper UTC time
    /// - Warning: This is Broken! Do not use this..
    func toUTC(from localTimeZone: TimeZone) -> Date {
        
        
                let timezone = localTimeZone
               let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
               return Date(timeInterval: seconds, since: self)
    }
    
    
    /// Returns the proper Date object in consideration of its time zone
    func corrected(by localTimeZone: TimeZone) -> Date {
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  localTimeZone.secondsFromGMT()
         
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
         
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
         
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    
}

extension Date {
    static func random() -> Date {
        let calendar = Calendar.current
        let defaultStartDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let defaultEndDate = Date()

        return randomBetween(startDate: defaultStartDate, endDate: defaultEndDate)
    }

    static func randomBetween(startDate: Date, endDate: Date) -> Date {
        guard startDate < endDate else {
            fatalError("Invalid date range. The start date must be earlier than the end date.")
        }

        let timeInterval = endDate.timeIntervalSince(startDate)
        let randomTimeInterval = TimeInterval.random(in: 0..<timeInterval)
        return startDate.addingTimeInterval(randomTimeInterval)
    }
}
