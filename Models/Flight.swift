//
//  Flight.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import Foundation

struct Flight: Identifiable, Codable {
    let id: UUID
    var flightNumber: String
    var departure: String
    var destination: String
    var departureTime: Date
    var arrivalTime: Date
    var status: FlightStatus
    
    init(id: UUID = UUID(), flightNumber: String, departure: String, destination: String, 
         departureTime: Date, arrivalTime: Date, status: FlightStatus = .scheduled) {
        self.id = id
        self.flightNumber = flightNumber
        self.departure = departure
        self.destination = destination
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.status = status
    }
}

enum FlightStatus: String, CaseIterable, Codable {
    case scheduled = "Scheduled"
    case boarding = "Boarding"
    case inAir = "In Air"
    case landed = "Landed"
    case delayed = "Delayed"
}