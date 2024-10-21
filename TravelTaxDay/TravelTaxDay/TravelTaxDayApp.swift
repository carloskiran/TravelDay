//
//  TravelTaxDayApp.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import SwiftUI
import SwiftData

@main
struct TravelTaxDayApp: App {
    // Integrate AppDelegate with SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var stayViewModel = StayViewModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            //ContentView()
            HomeView(stayViewModel: stayViewModel).environmentObject(stayViewModel)
                .onAppear {
                    // Provide stayViewModel to AppDelegate
                    print("setting viewModel")
                    appDelegate.stayViewModel = stayViewModel
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
