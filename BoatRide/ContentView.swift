import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var selectedTab = 0
    
    var body: some View {
        if userManager.isLoggedIn {
            TabView(selection: $selectedTab) {
                if userManager.currentUser?.userType == .passenger {
                    PassengerHomeView()
                        .tabItem {
                            Label("乘船", systemImage: "ferry")
                        }
                        .tag(0)
                } else {
                    BoatmanHomeView()
                        .tabItem {
                            Label("接单", systemImage: "helm")
                        }
                        .tag(0)
                }
                
                OrdersView()
                    .tabItem {
                        Label("订单", systemImage: "list.bullet")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Label("我的", systemImage: "person")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
        } else {
            LoginView()
        }
    }
} 