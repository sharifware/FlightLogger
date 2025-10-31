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
        app.launch()
    }
    
    func testAddFlightFlow() {
        // Given - Start on main screen
        let addButton = app.buttons["addFlightButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        
        // When - Add a flight
        addButton.tap()
        
        app.textFields["flightNumberField"].tap()
        app.textFields["flightNumberField"].typeText("FX999")
        
        app.textFields["departureField"].tap()
        app.textFields["departureField"].typeText("JFK")
        
        app.textFields["destinationField"].tap()
        app.textFields["destinationField"].typeText("LAX")
        
        app.buttons["submitButton"].tap()
        
        // Then - Verify flight appears
        XCTAssertTrue(app.staticTexts["FX999"].exists)
    }
    
    func testSearchFunctionality() {
        // Given - Add test flights
        addTestFlight(number: "FX100", departure: "JFK", destination: "LAX")
        addTestFlight(number: "FX200", departure: "LAX", destination: "MIA")
        
        // When - Search for specific flight
        let searchField = app.textFields["searchField"]
        searchField.tap()
        searchField.typeText("FX100")
        
        // Then - Only matching flight should appear
        XCTAssertTrue(app.staticTexts["FX100"].exists)
        XCTAssertFalse(app.staticTexts["FX200"].exists)
    }
    
    func testDeleteFlight() {
        // Given - Add a flight
        addTestFlight(number: "FX300", departure: "A", destination: "B")
        
        // When - Delete the flight
        let flightRow = app.buttons["flightRow_FX300"].firstMatch
        flightRow.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Then - Flight should be gone
        XCTAssertFalse(flightRow.exists)
    }
    
    // Helper method
    private func addTestFlight(number: String, departure: String, destination: String) {
        app.buttons["addFlightButton"].tap()
        
        app.textFields["flightNumberField"].tap()
        app.textFields["flightNumberField"].typeText(number)
        
        app.textFields["departureField"].tap()
        app.textFields["departureField"].typeText(departure)
        
        app.textFields["destinationField"].tap()
        app.textFields["destinationField"].typeText(destination)
        
        app.buttons["submitButton"].tap()
    }
}