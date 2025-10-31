//
//  FlightViewModelTests.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import XCTest
@testable import FlightLogger

class FlightViewModelTests: XCTestCase {
    var viewModel: FlightViewModel!
    var mockDataStore: MockFlightDataStore!
    
    override func setUp() {
        super.setUp()
        mockDataStore = MockFlightDataStore()
        viewModel = FlightViewModel(dataStore: mockDataStore)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataStore = nil
        super.tearDown()
    }
    
    // MARK: - Flight Creation Tests
    func testAddValidFlight() {
        // Given
        let flightNumber = "FX123"
        let departure = "JFK"
        let destination = "LAX"
        let departureTime = Date()
        let arrivalTime = Date().addingTimeInterval(3600)
        
        // When
        let result = viewModel.addFlight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        )
        
        // Then
        XCTAssertTrue(result, "Valid flight should be added successfully")
        XCTAssertEqual(mockDataStore.addedFlights.count, 1, "One flight should be added to data store")
        XCTAssertEqual(mockDataStore.addedFlights.first?.flightNumber, flightNumber)
    }
    
    func testAddFlightWithEmptyFields() {
        // Given
        let emptyFlightNumber = ""
        let departure = "JFK"
        let destination = "LAX"
        let departureTime = Date()
        let arrivalTime = Date().addingTimeInterval(3600)
        
        // When
        let result = viewModel.addFlight(
            flightNumber: emptyFlightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        )
        
        // Then
        XCTAssertFalse(result, "Flight with empty flight number should not be added")
        XCTAssertTrue(mockDataStore.addedFlights.isEmpty, "No flights should be added to data store")
    }
    
    func testAddFlightWithInvalidTimes() {
        // Given (arrival before departure)
        let flightNumber = "FX123"
        let departure = "JFK"
        let destination = "LAX"
        let departureTime = Date().addingTimeInterval(3600)
        let arrivalTime = Date()
        
        // When
        let result = viewModel.addFlight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        )
        
        // Then
        XCTAssertFalse(result, "Flight with arrival before departure should not be added")
        XCTAssertTrue(mockDataStore.addedFlights.isEmpty, "No flights should be added to data store")
    }
    
    // MARK: - Flight Filtering Tests
    func testFilterFlightsByFlightNumber() {
        // Given
        let testFlights = [
            Flight(flightNumber: "FX100", departure: "JFK", destination: "LAX", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600)),
            Flight(flightNumber: "FX200", departure: "LAX", destination: "JFK", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600)),
            Flight(flightNumber: "DL300", departure: "JFK", destination: "SFO", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600))
        ]
        
        mockDataStore.flights = testFlights
        viewModel.flights = testFlights
        
        // When
        viewModel.searchText = "FX100"
        let filtered = viewModel.filteredFlights()
        
        // Then
        XCTAssertEqual(filtered.count, 1, "Should find exactly one flight")
        XCTAssertEqual(filtered.first?.flightNumber, "FX100")
    }
    
    func testFilterFlightsByDestination() {
        // Given
        let testFlights = [
            Flight(flightNumber: "FX100", departure: "JFK", destination: "LAX", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600)),
            Flight(flightNumber: "FX200", departure: "LAX", destination: "JFK", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600)),
            Flight(flightNumber: "DL300", departure: "JFK", destination: "SFO", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600))
        ]
        
        mockDataStore.flights = testFlights
        viewModel.flights = testFlights
        
        // When
        viewModel.searchText = "LAX"
        let filtered = viewModel.filteredFlights()
        
        // Then
        XCTAssertEqual(filtered.count, 2, "Should find two flights with LAX")
        XCTAssertTrue(filtered.allSatisfy { $0.departure == "LAX" || $0.destination == "LAX" })
    }
    
    func testFilterFlightsEmptySearch() {
        // Given
        let testFlights = [
            Flight(flightNumber: "FX100", departure: "JFK", destination: "LAX", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600)),
            Flight(flightNumber: "FX200", departure: "LAX", destination: "JFK", 
                   departureTime: Date(), arrivalTime: Date().addingTimeInterval(3600))
        ]
        
        mockDataStore.flights = testFlights
        viewModel.flights = testFlights
        
        // When
        viewModel.searchText = ""
        let filtered = viewModel.filteredFlights()
        
        // Then
        XCTAssertEqual(filtered.count, 2, "Empty search should return all flights")
    }
    
    // MARK: - Data-Driven Testing for Flight Validation
    func testFlightValidationDataDriven() {
        // Test data: (flightNumber, departure, destination, departureOffset, arrivalOffset, shouldSucceed)
        let testCases: [(String, String, String, TimeInterval, TimeInterval, Bool)] = [
            ("FX123", "JFK", "LAX", 0, 3600, true),      // Valid case
            ("", "JFK", "LAX", 0, 3600, false),          // Empty flight number
            ("FX123", "", "LAX", 0, 3600, false),        // Empty departure
            ("FX123", "JFK", "", 0, 3600, false),        // Empty destination
            ("FX123", "JFK", "LAX", 3600, 0, false),     // Arrival before departure
            ("FX123", "JFK", "LAX", 0, 0, false),        // Same time
            ("FX123", "JFK", "LAX", 0, -3600, false)     // Past arrival
        ]
        
        for (i, (flightNumber, departure, destination, depOffset, arrOffset, shouldSucceed)) in testCases.enumerated() {
            // Given
            let departureTime = Date().addingTimeInterval(depOffset)
            let arrivalTime = Date().addingTimeInterval(arrOffset)
            
            // When
            let result = viewModel.addFlight(
                flightNumber: flightNumber,
                departure: departure,
                destination: destination,
                departureTime: departureTime,
                arrivalTime: arrivalTime
            )
            
            // Then
            XCTAssertEqual(result, shouldSucceed, "Test case \(i) failed: \(flightNumber), \(departure), \(destination)")
        }
    }
}

// MARK: - Mock Data Store for Testing
class MockFlightDataStore: FlightDataStore {
    var addedFlights: [Flight] = []
    var removedFlights: [Flight] = []
    
    override func addFlight(_ flight: Flight) {
        addedFlights.append(flight)
        super.addFlight(flight)
    }
    
    override func removeFlight(_ flight: Flight) {
        removedFlights.append(flight)
        super.removeFlight(flight)
    }
}