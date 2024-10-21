//
//  HomeView.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import SwiftUI
import SwiftData

//Home View that is seen on open
//Contains a list of countries and a button to add new trips
struct HomeView: View {
    //store an instance of the model
    //@StateObject var stayViewModel = StayViewModel()
    
    @ObservedObject var stayViewModel: StayViewModel
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome Back")

                Button("Add stay in current country") {
                    stayViewModel.AddCurrent()
                    print(stayViewModel.countries.count)
                }
                .onAppear {
                    stayViewModel.locationManager.requestLocation()
                }
                
                //Have a list of all the countries the user has been to
                List($stayViewModel.countries, editActions: .delete) { $country in
                    NavigationLink {
                        CountryPageView().environmentObject(country)
                    } label: {
                        CountryCell(countryCounter: country)
                    }
                }
            }
            .toolbar {//button to navigate to the page to add a new trip
                NavigationLink {
                    AddStayView()
                } label: {
                    Label("Show Plus", systemImage: "plus")
                }
            }
        }
        .refreshable {
            print("refresh")
        }
        .environmentObject(stayViewModel)
    }
}

#Preview {
    HomeView(stayViewModel: StayViewModel())
}

