//
//  CountryCounter.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import Foundation

//class to represent the tracked days for a singlular country
class CountryCounter : Hashable, Identifiable, Codable, ObservableObject {
    //id for the country
    let id : String
    
    //flag for the country
    let flag : String
    
    //number of days in the past year
    var days : Int
    
    //array of pairs to represent stays
    var stays : [Interval]
    
    //intialiser for the class
    init(_ id : String) {
        self.id = id
        self.flag = GetFlag(country : id)
        self.days = 0
        self.stays = []
    }
    
    //functions to confirm to protocols (equatable and hasher)
    static func == (lhs : CountryCounter, rhs : CountryCounter) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    //function to add a stay to the country
    func AddStay(_ start : Date, _ end : Date) {
        //print("New Stay at \(self.id) from \(start) to \(end)")
        
        
        //check if the new dates are in the same year (currently split as calendar for all nations)
        let startYear = GetYear(from: start)
        let endYear = GetYear(from: end)
        if(startYear != endYear) {//if they are not
            //custom date initalisation pulled from here https://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let startYearLastDay = formatter.date(from: "\(startYear)/12/31 00:00")!
            //print("Recursive")
            AddStay(start, startYearLastDay)
            
            //call the function recursively on from the day after end of the start year to the endDate
            let dayAfterLastDay = formatter.date(from: "\(startYear + 1)/01/01 00:00")!
            //print("Recursive")
            AddStay(dayAfterLastDay, end)
            
            return
        }
        
        //This is essentially an interval inserter problem
        //create a new interval and stays array
        var newInterval = Interval(start, end)
        var newStays : [Interval] = []
        
        //go through all the days
        //inspired by code found here https://gist.github.com/cfilipov/c253b722dbb8db9d4aa0
        for interval in self.stays {
            
            if IsDate1EarlierThanDate2(interval.endDate, newInterval.startDate) {//Old interval occured before the new one
                newStays.append(interval)
                
            } else if IsDate1EarlierThanDate2(newInterval.endDate, interval.startDate) {//The new interval goes before the old one
                newStays.append(newInterval)
                newInterval = interval
                
            } else {//overlap, make a larger interval
                let start = min(newInterval.startDate, interval.startDate)
                let end = max(newInterval.endDate, interval.endDate)
                newInterval = Interval(start, end)
            }
        }
        newStays.append(newInterval)
        
        //update the stays
        self.stays = newStays
        
        //now update the number of days
        UpdateDays()
    }
    
    //function to update the number of days
    //This gets the current date and looks for all intervals in the same year, saving the sum into the variable
    func UpdateDays() {
        //get the current year
        let currentDate = Date()
        let currentYear = GetYear(from: currentDate)
        
        //reset the number of days from the current year
        self.days = 0
        
        //go through all the intervals, if they are in the current year increase the days count
        for stay in stays {
            if GetYear(from: stay.startDate) == currentYear { //increase the number of days
                let span = DaysBetween(stay.startDate, stay.endDate)
                self.days += span
            }
        }
    }
}

//a simple struct to act as a pair of dates
//used to represent an interval
struct Interval: Codable, Identifiable {
    let id : String
    var startDate: Date
    var endDate: Date
    
    init(_ startDate : Date, _ endDate : Date) {
        id = "\(startDate)"
        self.startDate = startDate
        self.endDate = endDate
    }
}

//function to get the flag emoji
//sourced from this repository https://stackoverflow.com/questions/30402435/swift-turn-a-country-code-into-a-emoji-flag-via-unicode
func GetFlag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}


//function to get the year from a date
func GetYear(from date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: date)
    return components.year!
}

//function to find the number of days between two dates
func DaysBetween(_ start: Date, _ end: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day! + 1
}

//function to compare two dates (ignoring time)
func IsDate1EarlierThanDate2(_ date1: Date, _ date2: Date) -> Bool {
    let calendar = Calendar.current

    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

    if let year1 = components1.year, let year2 = components2.year {
        if year1 < year2 {
            return true
        } else if year1 > year2 {
            return false
        }
    }

    if let month1 = components1.month, let month2 = components2.month {
        if month1 < month2 {
            return true
        } else if month1 > month2 {
            return false
        }
    }

    if let day1 = components1.day, let day2 = components2.day {
        return day1 < day2
    }

    return false
}
