//
//  ContentView.swift
//  FlightLogger
//
//  Created by Muhammed-Sharif Adepetu on 10/31/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlightViewModel()
    
    var body: some View {
        NavigationView {
            FlightListView(viewModel: viewModel)
                .navigationTitle("FlightLogger")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Add Flight") {
                            AddFlightView(viewModel: viewModel)
                        }
                        .accessibilityIdentifier("addFlightButton")
                    }
                }
        }
    }
}