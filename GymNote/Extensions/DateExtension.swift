//
//  DateExtension.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/17/22.
//

import Foundation

extension Date {
    
    func datesFormatForWorkout() -> String {
        let formatDay = DateFormatter()
        let formatDates = DateFormatter()
        formatDay.dateFormat = "EEEE"
        formatDates.dateFormat = "MMM d"
        let dayString = formatDay.string(from: self)
        let datesString = formatDates.string(from: self)
        return "\(dayString) \(datesString)"
    }
    
    func timeFormatForWorkout() -> String {
        let formatTimes = DateFormatter()
        formatTimes.dateFormat = "h:mm a"
        let timesString = formatTimes.string(from: self)
        return timesString
    }
    
}//End of extension
