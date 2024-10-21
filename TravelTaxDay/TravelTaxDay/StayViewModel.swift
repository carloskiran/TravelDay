//
//  StayViewModel.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import Foundation
import CoreLocation
import CoreLocationUI
import UIKit
import BackgroundTasks
import SwiftUI

//Class to store and manage the trips by the user
class StayViewModel : ObservableObject {
    //array of all countries travelled to
    @Published var countries: [CountryCounter] {//now with Didset
        didSet {
            Save()//everytime countries are changed
        }
    }
    
    //array of all regions (for the picker, created here to prevent having to remove the non-countries over and over again)
    var countryList : [Locale.Region]
    
    //URL where the flashcards will
    private var countryFilePath : URL
    
    //variable for the location manager
    @Published var locationManager : LocationManager
    
    //variable for background task
    @Published var lastTaskCompletionDate: Date? = nil
    
    //Default Initialiser
    init() {
        //initialise the list of countries to empty
        self.countries = []
        
        //create the list of countries (to prevent having to redo this everytime)
        self.countryList = Locale.Region.isoRegions
        for _ in 0..<29 {//remove the first 29 items (which do not correspond to countries
            self.countryList.remove(at: 0)
        }
        
        //Initialize the file path in custom initializer to the a file called `stays.json` in the documents directory of your app
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathString = "\(documentDirectory)/stays.json"
        countryFilePath = URL(string: pathString)!
        
        //initialise the locationManager
        locationManager = LocationManager()
        
        //load in records if they exists
        if let loadedStays = Load() {
            self.countries = loadedStays
            UpdateAllDays()
        }
        
        //remove any countries with no stays
        //print("init")
        self.countries.removeAll {$0.stays.count == 0}
    }
    
    
    //function to load the class from memory (if it exists)
    private func Load() -> [CountryCounter]?{
        do {
            let data = try Data(contentsOf: countryFilePath)
            let countries = try JSONDecoder().decode([CountryCounter].self, from: data)
            return countries
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    //function to save the class to memory
    private func Save() {
        do {
            let data = try JSONEncoder().encode(countries)
            try data.write(to: countryFilePath)
        } catch {
            print("Error: \(error)")
        }
        UpdateAllDays()
    }
    
    //function to add a stay
    func AddStay(_ country : Locale.Region, _ start : Date, _ end : Date) {
        //look for the country in the list of countries
        let id = country.identifier
        
        if let counter = countries.first(where: {$0.id == id}) {//add the stay to the country
            print("Exists")
            counter.AddStay(start, end)
        } else {//create a new counter for the country, add the stay, and append to the list
            print("New Country")
            let newCounter = CountryCounter(id)
            newCounter.AddStay(start, end)
            countries.append(newCounter)
        }
    }
    
    //function to go through all the countries and update their days (done after loading in)
    func UpdateAllDays() {
        for country in countries {
            country.UpdateDays()
        }
    }
    
    //function to get the current locaiton and add a stay there (using the location passed in)
    func AddCurrent() {
        //print("Adding Current")
        
        self.locationManager.requestLocation()
        let location = self.locationManager.location
        //get the current location
        print(location ?? "None")
        
        let geocoder = CLGeocoder()
        //print("Starting reverse geocoding")
        geocoder.reverseGeocodeLocation(location!) { [weak self] placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error)")
            }

            if let country = placemarks?.first?.isoCountryCode {
                //print("Country code found: \(country)")
                let locale = Locale.Region("\(country)")
                
                //print("Getting date")
                //use the current location and the current date to add a stay of one day
                let currentDate = Date()
                
                self?.AddStay(locale, currentDate, currentDate)
            } else {
                print("No country code found")
            }
        }
    }
    
    
    //background task function
    func performBackgroundTask(completion: @escaping (Bool) -> Void) {
        // Simulate a long-running task
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
            
            //update based on current location
            self.AddCurrent()
            //self.AddCurrent()
            
            DispatchQueue.main.async {
                self.lastTaskCompletionDate = Date()
            }
            completion(true)
        }
    }
    
    func scheduleBackgroundTask() {
        print("Scheduling")
        let request = BGProcessingTaskRequest(identifier: "com.example.app.backgroundtask")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 6 * 60 * 60) // 6 hours from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
}

//class to manage locating the user's current location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil

    //initaliser which sets location
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocation()
    }

    //request location function
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("update location")
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("Error getting location: \(error)")
    }
}



//class for background tasks
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var stayViewModel: StayViewModel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           // Register background tasks
           BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.app.backgroundtask", using: nil) { task in
               print("Background task handler called")
               self.handleBackgroundTask(task: task as! BGProcessingTask)
           }
           print("App did finish launching")
           return true
       }

       func handleBackgroundTask(task: BGProcessingTask) {
           guard let stayViewModel = stayViewModel else {
               print("StayViewModel is not set")
               task.setTaskCompleted(success: false)
               return
           }
           print("Handling background task")
           // Schedule the next task
           stayViewModel.scheduleBackgroundTask()

           task.expirationHandler = {
               // Clean up if the task expires.
               print("Task expired")
           }

           // Perform the background task
           stayViewModel.performBackgroundTask { success in
               task.setTaskCompleted(success: success)
               print("Background task completed: \(success)")
           }
       }

       func applicationDidEnterBackground(_ application: UIApplication) {
           print("App entered background")
           guard let stayViewModel = stayViewModel else {
               print("StayViewModel is not set")
               return
           }
           print("App entered background")
           stayViewModel.scheduleBackgroundTask()
       }

       func applicationWillEnterForeground(_ application: UIApplication) {
           print("App will enter foreground")
       }

       func applicationDidBecomeActive(_ application: UIApplication) {
           print("App did become active")
       }

       func applicationWillResignActive(_ application: UIApplication) {
           print("App will resign active")
       }

       func applicationWillTerminate(_ application: UIApplication) {
           print("App will terminate")
       }
   }
