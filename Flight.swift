//
//  Flight.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import Foundation

struct Flight: Identifiable, Codable {
    let id = UUID()
    var flightNumber: String
    var departure: String
    var destination: String
    var status: String = "Scheduled"
}