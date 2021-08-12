//
//  Extensions.swift
//  Love
//
//  Created by Micheal Bingham on 6/17/21.
//

import Foundation
import SwiftUI
import Firebase





/// Gets the Verification ID from signing in the phone number
/// - Returns: The verification id string from UserDefaults 
func getVerificationID() -> String? {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    return verificationID
}

extension String{
    
    /// Saves the verification ID string in UserDefaults
    /// - Returns: Void.
    func save()  {
        
        UserDefaults.standard.set(self, forKey: "authVerificationID")
    }
}


extension NSNotification {
    static let logout = NSNotification.Name.init("logout")
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


extension Timestamp{
    
    var month: String{
        return Date(timeIntervalSince1970: Double(self.seconds)).month()
    }
    
    var year: Int{
        return Date(timeIntervalSince1970: Double(self.seconds)).year()
    }
    
    var day: Int{
        return Date(timeIntervalSince1970: Double(self.seconds)).day()
    }
}


extension Date {
    func getDateFor(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }

    /// Extension for returning the `Date` +- years from the current date
    func dateFor(years: Int) -> Date {
        
        return Calendar.current.date(byAdding: .year, value: years, to: Date()) ?? Date()
    }
}



