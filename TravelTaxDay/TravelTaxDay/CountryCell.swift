//
//  CountryCell.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 2/7/24.
//

import SwiftUI

//View for each of the countries to be represented in the home screen
struct CountryCell: View {
    let countryCounter : CountryCounter
    var body: some View {
        HStack {
            VStack (spacing: 12.0) {
                Text(Locale.current.localizedString(forRegionCode: countryCounter.id) ?? countryCounter.id)
                    .font(.title3)
                Text(countryCounter.flag)
                    .font(.subheadline)
            }
            Spacer()
            if(countryCounter.days == 1) {
                Text("\(countryCounter.days) day")
            } else {
                Text("\(countryCounter.days) days")
            }
        }
        .padding()
    }
}

#Preview {
    CountryCell(countryCounter: CountryCounter("GB"))
}
