//
//  FlightDataStore.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import Foundation

class FlightDataStore: ObservableObject {
    @Published var flights: [Flight] = []
    
    func addFlight(_ flight: Flight) {
        flights.append(flight)
        saveFlights()
    }
    
    func removeFlight(_ flight: Flight) {
        flights.removeAll { $0.id == flight.id }
        saveFlights()
    }
    
    private func saveFlights() {
        // Simple persistence using UserDefaults for demo
        if let encoded = try? JSONEncoder().encode(flights) {
            UserDefaults.standard.set(encoded, forKey: "savedFlights")
        }
    }
    
    func loadFlights() {
        if let data = UserDefaults.standard.data(forKey: "savedFlights"),
           let decoded = try? JSONDecoder().decode([Flight].self, from: data) {
            flights = decoded
        }
    }
}