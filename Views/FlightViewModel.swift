//
//  FlightViewModel.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import Foundation
import Combine

class FlightViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var searchText: String = ""
    
    private let dataStore: FlightDataStore
    private var cancellables = Set<AnyCancellable>()
    
    // Dependency injection for testing
    init(dataStore: FlightDataStore = FlightDataStore()) {
        self.dataStore = dataStore
        setupBindings()
        loadFlights()
    }
    
    private func setupBindings() {
        dataStore.$flights
            .assign(to: &$flights)
    }
    
    func addFlight(flightNumber: String, departure: String, destination: String, 
                   departureTime: Date, arrivalTime: Date) -> Bool {
        
        // Input validation - crucial for testing
        guard !flightNumber.isEmpty, !departure.isEmpty, !destination.isEmpty,
              arrivalTime > departureTime else {
            return false
        }
        
        let newFlight = Flight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        )
        
        dataStore.addFlight(newFlight)
        return true
    }
    
    func deleteFlight(_ flight: Flight) {
        dataStore.removeFlight(flight)
    }
    
    func filteredFlights() -> [Flight] {
        guard !searchText.isEmpty else { return flights }
        return flights.filter { 
            $0.flightNumber.localizedCaseInsensitiveContains(searchText) ||
            $0.departure.localizedCaseInsensitiveContains(searchText) ||
            $0.destination.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func loadFlights() {
        dataStore.loadFlights()
    }
}