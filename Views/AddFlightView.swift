//
//  AddFlightView.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import SwiftUI

struct AddFlightView: View {
    @ObservedObject var viewModel: FlightViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var flightNumber = ""
    @State private var departure = ""
    @State private var destination = ""
    @State private var departureTime = Date()
    @State private var arrivalTime = Date().addingTimeInterval(3600) // 1 hour later
    @State private var showError = false
    
    var body: some View {
        Form {
            Section(header: Text("Flight Details")) {
                TextField("Flight Number", text: $flightNumber)
                    .accessibilityIdentifier("flightNumberField")
                TextField("Departure Airport", text: $departure)
                    .accessibilityIdentifier("departureField")
                TextField("Destination Airport", text: $destination)
                    .accessibilityIdentifier("destinationField")
            }
            
            Section(header: Text("Schedule")) {
                DatePicker("Departure Time", selection: $departureTime, in: Date()...)
                    .accessibilityIdentifier("departureTimePicker")
                DatePicker("Arrival Time", selection: $arrivalTime, in: departureTime...)
                    .accessibilityIdentifier("arrivalTimePicker")
            }
            
            Section {
                Button("Add Flight") {
                    addFlight()
                }
                .accessibilityIdentifier("submitFlightButton")
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Add New Flight")
        .alert("Invalid Input", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your inputs. Arrival time must be after departure time.")
        }
    }
    
    private var isFormValid: Bool {
        !flightNumber.isEmpty && 
        !departure.isEmpty && 
        !destination.isEmpty && 
        arrivalTime > departureTime
    }
    
    private func addFlight() {
        if viewModel.addFlight(
            flightNumber: flightNumber,
            departure: departure,
            destination: destination,
            departureTime: departureTime,
            arrivalTime: arrivalTime
        ) {
            dismiss()
        } else {
            showError = true
        }
    }
}