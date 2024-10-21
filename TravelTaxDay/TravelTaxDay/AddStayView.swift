//
//  AddStayView.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import SwiftUI
import Foundation

//Page to add a new trip, asks for info and saves it to the viewmodel
struct AddStayView: View {
    //Enviroment object for the model
    @EnvironmentObject var stayViewModel : StayViewModel
    
    
    //variables needed for the trip (country and dates)
    @State private var country : Locale.Region = .unitedKingdom
    @State private var start = Date()
    @State private var end = Date()
    
    //Variable to go back to the homepage after saving
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Add a New Stay")
                
                //Country selector
                HStack {
                    Text("Country")
                    Spacer()
                    Picker("Country", selection: $country) {
                        ForEach(stayViewModel.countryList.indices, id: \.self) {
                            index in let regionCode = stayViewModel.countryList[index].identifier
                            let regionName = Locale.current.localizedString(forRegionCode: regionCode) ?? regionCode
                            Text(regionName).tag(stayViewModel.countryList[index])
                        }
                    }
                }
                .padding()
                
                //Date pickers for the start and end
                DatePicker ("Start", selection: $start, displayedComponents: .date)
                    .padding()
                DatePicker ("End", selection: $end, displayedComponents: .date)
                    .padding()
                
            }
            .toolbar {//button to save and return to the home page
                Button("Save") {
                    //call the add stay function
                    stayViewModel.AddStay(country, start, end)
                    
                    dismiss()
                }
                .disabled(start > end)
            }
        }
    }
}

#Preview {
    AddStayView().environmentObject(StayViewModel())
}
