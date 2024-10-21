//
//  CountryPageView.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 2/7/24.
//

import SwiftUI

//View to look at a country
struct CountryPageView: View {
    //Enviroment object for the model
    @EnvironmentObject var stayViewModel : StayViewModel
    @EnvironmentObject var countryCounter : CountryCounter
    var body: some View {
        Text("Stays in \(Locale.current.localizedString(forRegionCode: countryCounter.id) ?? countryCounter.id)")
        
        //List of all the intervals the individual has spent a the country
        List {
            ForEach($countryCounter.stays.indices.reversed(), id: \.self) { index in TripCell(interval: countryCounter.stays[index])
            }
            .onDelete(perform: DeleteStay)
        }
    }
    
    //function update the counter on deletion of stay
    func DeleteStay(at offsets: IndexSet) {
        let reversedOffsets = IndexSet(offsets.map { countryCounter.stays.count - 1 - $0 })
        countryCounter.stays.remove(atOffsets: reversedOffsets)
        countryCounter.UpdateDays()
        stayViewModel.countries.removeAll {$0.stays.count == 0}
    }
}

#Preview {
    CountryPageView().environmentObject(CountryCounter("GB"))
}
