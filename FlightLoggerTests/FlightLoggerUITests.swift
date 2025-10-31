//
//  FlightLoggerUITests.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import XCTest

class FlightLoggerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Launch arguments for testing
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    func testAppLaunch() {
        // Verify app launches to correct screen
        XCTAssertTrue(app.navigationBars["FlightLogger"].exists)
        XCTAssertTrue(app.buttons["addFlightButton"].exists)
    }
    
    func testAddNewFlightFlow() {
        // Given - Start on main screen
        let addFlightButton = app.buttons["addFlightButton"]
        XCTAssertTrue(addFlightButton.waitForExistence(timeout: 2))
        
        // When - Navigate to Add Flight
        addFlightButton.tap()
        
        // Then - Verify Add Flight screen
        XCTAssertTrue(app.navigationBars["Add New Flight"].exists)
        
        // When - Fill out the form
        let flightNumberField = app.textFields["flightNumberField"]
        let departureField = app.textFields["departureField"]
        let destinationField = app.textFields["destinationField"]
        let submitButton = app.buttons["submitFlightButton"]
        
        flightNumberField.tap()
        flightNumberField.typeText("FX999")
        
        departureField.tap()
        departureField.typeText("JFK")
        
        destinationField.tap()
        destinationField.typeText("LAX")
        
        // Then - Submit button should be enabled with valid data
        XCTAssertTrue(submitButton.isEnabled)
        
        // When - Submit the form
        submitButton.tap()
        
        // Then - Should return to main screen and show new flight
        XCTAssertTrue(app.navigationBars["FlightLogger"].exists)
        XCTAssertTrue(app.staticTexts["FX999"].exists)
    }
    
    func testAddFlightValidation() {
        // Given - Navigate to Add Flight
        app.buttons["addFlightButton"].tap()
        
        let flightNumberField = app.textFields["flightNumberField"]
        let submitButton = app.buttons["submitFlightButton"]
        
        // When - Try to submit with empty fields
        // Then - Submit button should be disabled
        XCTAssertFalse(submitButton.isEnabled)
        
        // When - Fill only flight number
        flightNumberField.tap()
        flightNumberField.typeText("FX999")
        
        // Then - Still disabled (other fields empty)
        XCTAssertFalse(submitButton.isEnabled)
    }
    
    func testSearchFunctionality() {
        // Given - Add test flights first
        addTestFlight(number: "FX100", departure: "JFK", destination: "LAX")
        addTestFlight(number: "FX200", departure: "LAX", destination: "MIA")
        addTestFlight(number: "DL300", departure: "JFK", destination: "SFO")
        
        let searchBar = app.textFields["searchTextField"]
        let clearButton = app.buttons["clearSearchButton"]
        
        // When - Search for "FX"
        searchBar.tap()
        searchBar.typeText("FX")
        
        // Then - Should show only FX flights
        XCTAssertTrue(app.staticTexts["FX100"].exists)
        XCTAssertTrue(app.staticTexts["FX200"].exists)
        XCTAssertFalse(app.staticTexts["DL300"].exists)
        
        // When - Clear search
        clearButton.tap()
        
        // Then - Should show all flights again
        XCTAssertTrue(app.staticTexts["FX100"].exists)
        XCTAssertTrue(app.staticTexts["FX200"].exists)
        XCTAssertTrue(app.staticTexts["DL300"].exists)
    }
    
    func testDeleteFlight() {
        // Given - Add a test flight
        addTestFlight(number: "FXDELETE", departure: "A", destination: "B")
        
        // When - Swipe to delete
        let flightRow = app.buttons["flightRow_FXDELETE"].firstMatch
        XCTAssertTrue(flightRow.waitForExistence(timeout: 2))
        
        flightRow.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Then - Flight should be removed
        XCTAssertFalse(flightRow.exists)
    }
    
    func testFlightListScrollAndPerformance() {
        // Given - Add multiple flights
        for i in 1...15 {
            addTestFlight(number: "FX\(i)", departure: "APT\(i)", destination: "APT\(i+1)")
        }
        
        let flightsList = app.collectionViews["flightsList"]
        XCTAssertTrue(flightsList.waitForExistence(timeout: 2))
        
        // When - Scroll to bottom
        flightsList.swipeUp()
        flightsList.swipeUp()
        
        // Then - Should be able to see last flight
        XCTAssertTrue(app.staticTexts["FX15"].exists)
    }
    
    // MARK: - Data-Driven UI Testing
    func testMultipleFlightCreations() {
        let testFlights = [
            ("FX101", "JFK", "LAX"),
            ("FX202", "LAX", "JFK"),
            ("FX303", "SFO", "MIA")
        ]
        
        for (number, departure, destination) in testFlights {
            // When - Add each flight
            addTestFlight(number: number, departure: departure, destination: destination)
            
            // Then - Verify it appears in the list
            XCTAssertTrue(app.staticTexts[number].exists, "Flight \(number) should be visible")
            
            // Verify departure and destination
            XCTAssertTrue(app.staticTexts[departure].exists)
            XCTAssertTrue(app.staticTexts[destination].exists)
        }
    }
    
    // MARK: - Helper Methods
    private func addTestFlight(number: String, departure: String, destination: String) {
        app.buttons["addFlightButton"].tap()
        
        app.textFields["flightNumberField"].tap()
        app.textFields["flightNumberField"].typeText(number)
        
        app.textFields["departureField"].tap()
        app.textFields["departureField"].typeText(departure)
        
        app.textFields["destinationField"].tap()
        app.textFields["destinationField"].typeText(destination)
        
        app.buttons["submitFlightButton"].tap()
    }
}