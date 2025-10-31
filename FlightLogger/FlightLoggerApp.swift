
import SwiftUI

@main
struct FlightLoggerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Clear data if UI testing
                    if CommandLine.arguments.contains("--uitesting") {
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    }
                }
        }
    }
}
