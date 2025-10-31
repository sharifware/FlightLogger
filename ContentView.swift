//
//  ContentView.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlightViewModel()
    @State private var showingAddFlight = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search flights...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibilityIdentifier("searchField")
                
                // Flight List
                List {
                    ForEach(viewModel.filteredFlights) { flight in
                        FlightRow(flight: flight)
                            .accessibilityIdentifier("flightRow_\(flight.flightNumber)")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let flight = viewModel.filteredFlights[index]
                            viewModel.deleteFlight(flight)
                        }
                    }
                }
                .accessibilityIdentifier("flightList")
            }
            .navigationTitle("FlightLogger")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Flight") {
                        showingAddFlight = true
                    }
                    .accessibilityIdentifier("addFlightButton")
                }
            }
            .sheet(isPresented: $showingAddFlight) {
                AddFlightView(viewModel: viewModel)
            }
        }
    }
}

// Flight Row View
struct FlightRow: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(flight.flightNumber)
                .font(.headline)
                .accessibilityIdentifier("flightNumber")
            
            Text("\(flight.departure) → \(flight.destination)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// Add Flight View
struct AddFlightView: View {
    @ObservedObject var viewModel: FlightViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var flightNumber = ""
    @State private var departure = ""
    @State private var destination = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Flight Details")) {
                    TextField("Flight Number", text: $flightNumber)
                        .accessibilityIdentifier("flightNumberField")
                    TextField("Departure", text: $departure)
                        .accessibilityIdentifier("departureField")
                    TextField("Destination", text: $destination)
                        .accessibilityIdentifier("destinationField")
                }
                
                Button("Add Flight") {
                    if viewModel.addFlight(
                        flightNumber: flightNumber,
                        departure: departure,
                        destination: destination
                    ) {
                        dismiss()
                    }
                }
                .accessibilityIdentifier("submitButton")
                .disabled(!isFormValid)
            }
            .navigationTitle("Add Flight")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
    
    private var isFormValid: Bool {
        !flightNumber.isEmpty && !departure.isEmpty && !destination.isEmpty
    }
}