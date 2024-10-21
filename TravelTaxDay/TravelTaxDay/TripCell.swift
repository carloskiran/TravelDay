//
//  TripCell.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 2/7/24.
//

import SwiftUI

//cell to display a trip (an interval)
struct TripCell: View {
    let interval : Interval
    var body: some View {
        HStack {
            Text(DateFormatter(interval.startDate))
            Text("to")
            Text(DateFormatter(interval.endDate))
            Spacer()
            if DaysBetween(interval.startDate, interval.endDate) == 1 {
                Text("\(DaysBetween(interval.startDate, interval.endDate)) day")
            } else {
                Text("\(DaysBetween(interval.startDate, interval.endDate)) days")
            }
        }
        .padding()
    }
    
    //function to format the date correctly (this can later be edited to be changed as per user preference)
    func DateFormatter(_ date: Date) -> String {
        let formatter = Foundation.DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy" // Custom format: day month year
            return formatter.string(from: date)
        }
}

#Preview {
    TripCell(interval: Interval(Date(), Date() ))
}
