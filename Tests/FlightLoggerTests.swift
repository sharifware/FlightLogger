//
//  FlightLoggerTests.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import XCTest
@testable import FlightLogger

class FlightLoggerTests: XCTestCase {
    var viewModel: FlightViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FlightViewModel()
    }
    
    func testAddValidFlight() {
        // When
        let result = viewModel.addFlight(
            flightNumber: "FX123",
            departure: "JFK",
            destination: "LAX"
        )
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(viewModel.flights.count, 1)
        XCTAssertEqual(viewModel.flights.first?.flightNumber, "FX123")
    }
    
    func testAddInvalidFlight() {
        // When
        let result = viewModel.addFlight(
            flightNumber: "",
            departure: "JFK",
            destination: "LAX"
        )
        
        // Then
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.flights.isEmpty)
    }
    
    func testSearchFlights() {
        // Given
        viewModel.addFlight(flightNumber: "FX100", departure: "JFK", destination: "LAX")
        viewModel.addFlight(flightNumber: "FX200", departure: "LAX", destination: "MIA")
        
        // When
        viewModel.searchText = "FX100"
        
        // Then
        XCTAssertEqual(viewModel.filteredFlights.count, 1)
        XCTAssertEqual(viewModel.filteredFlights.first?.flightNumber, "FX100")
    }
    
    func testDeleteFlight() {
        // Given
        viewModel.addFlight(flightNumber: "FX100", departure: "JFK", destination: "LAX")
        let flight = viewModel.flights[0]
        
        // When
        viewModel.deleteFlight(flight)
        
        // Then
        XCTAssertTrue(viewModel.flights.isEmpty)
    }
}