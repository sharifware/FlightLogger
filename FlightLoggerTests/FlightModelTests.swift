//
//  FlightModelTests.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import XCTest
@testable import FlightLogger

class FlightModelTests: XCTestCase {
    
    func testFlightInitialization() {
        // Given
        let flightNumber = "FX123"
        let departure = "JFK"
        let destination = "LAX"
        let departureTime = Date()
        let arrivalTime = Date().addingTimeInterval(7200) // 2 hours later
        
        // When
        let flight = Flight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        )
        
        // Then
        XCTAssertEqual(flight.flightNumber, flightNumber)
        XCTAssertEqual(flight.departure, departure)
        XCTAssertEqual(flight.destination, destination)
        XCTAssertEqual(flight.departureTime, departureTime)
        XCTAssertEqual(flight.arrivalTime, arrivalTime)
        XCTAssertEqual(flight.status, .scheduled)
    }
    
    func testFlightCodable() throws {
        // Given
        let originalFlight = Flight(
            flightNumber: "FX123",
            departure: "JFK",
            destination: "LAX",
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(7200)
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(originalFlight)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedFlight = try decoder.decode(Flight.self, from: data)
        
        // Then
        XCTAssertEqual(decodedFlight.flightNumber, originalFlight.flightNumber)
        XCTAssertEqual(decodedFlight.departure, originalFlight.departure)
        XCTAssertEqual(decodedFlight.destination, originalFlight.destination)
        XCTAssertEqual(decodedFlight.status, originalFlight.status)
    }
    
    func testFlightStatusColors() {
        // Given
        let scheduledFlight = Flight(flightNumber: "FX1", departure: "A", destination: "B", 
                                    departureTime: Date(), arrivalTime: Date(), status: .scheduled)
        let delayedFlight = Flight(flightNumber: "FX2", departure: "A", destination: "B", 
                                  departureTime: Date(), arrivalTime: Date(), status: .delayed)
        
        // This would test the computed property in your View extension
        // You might want to move status color logic to a testable helper
    }
}