//
//  FlightViewModel.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import Foundation

class FlightViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var searchText = ""
    
    func addFlight(flightNumber: String, departure: String, destination: String) -> Bool {
        guard !flightNumber.isEmpty, !departure.isEmpty, !destination.isEmpty else {
            return false
        }
        
        let newFlight = Flight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination
        )
        
        flights.append(newFlight)
        return true
    }
    
    func deleteFlight(_ flight: Flight) {
        flights.removeAll { $0.id == flight.id }
    }
    
    var filteredFlights: [Flight] {
        guard !searchText.isEmpty else { return flights }
        return flights.filter { 
            $0.flightNumber.localizedCaseInsensitiveContains(searchText) ||
            $0.departure.localizedCaseInsensitiveContains(searchText) ||
            $0.destination.localizedCaseInsensitiveContains(searchText)
        }
    }
}