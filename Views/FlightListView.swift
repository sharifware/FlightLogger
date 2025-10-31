//
//  FlightListView.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import SwiftUI

struct FlightListView: View {
    @ObservedObject var viewModel: FlightViewModel
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .accessibilityIdentifier("searchBar")
            
            List {
                ForEach(viewModel.filteredFlights()) { flight in
                    FlightRowView(flight: flight)
                        .accessibilityElement(children: .combine)
                        .accessibilityIdentifier("flightRow_\(flight.flightNumber)")
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let flight = viewModel.filteredFlights()[index]
                        viewModel.deleteFlight(flight)
                    }
                }
            }
            .accessibilityIdentifier("flightsList")
        }
    }
}

struct FlightRowView: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(flight.flightNumber)
                .font(.headline)
                .accessibilityIdentifier("flightNumber")
            
            HStack {
                Text(flight.departure)
                Image(systemName: "airplane")
                Text(flight.destination)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text(flight.status.rawValue)
                .font(.caption)
                .padding(4)
                .background(statusColor)
                .foregroundColor(.white)
                .cornerRadius(4)
                .accessibilityIdentifier("flightStatus")
        }
        .padding(.vertical, 4)
    }
    
    private var statusColor: Color {
        switch flight.status {
        case .scheduled: return .blue
        case .boarding: return .orange
        case .inAir: return .purple
        case .landed: return .green
        case .delayed: return .red
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search flights...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityIdentifier("searchTextField")
            
            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                }
                .accessibilityIdentifier("clearSearchButton")
            }
        }
        .padding()
    }
}