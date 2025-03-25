import SwiftUI

@main
struct BoatRideApp: App {
    @StateObject private var userManager = UserManager()
    @StateObject private var orderManager = OrderManager()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(orderManager)
                .environmentObject(locationManager)
        }
    }
} 