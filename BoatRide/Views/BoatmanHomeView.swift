import SwiftUI
import MapKit

struct BoatmanHomeView: View {
    @EnvironmentObject var orderManager: OrderManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var isOnline = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Toggle("", isOn: $isOnline)
                        .toggleStyle(CustomToggleStyle(onText: "在线", offText: "离线"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.top)
                }
                
                Spacer()
                
                if isOnline {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(orderManager.availableOrders.filter { $0.status == .pending }) { order in
                                OrderCardView(order: order) {
                                    if let userId = userManager.currentUser?.id {
                                        orderManager.acceptOrder(orderId: order.id, boatmanId: userId)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                } else {
                    VStack {
                        Text("您现在处于离线状态")
                            .font(.headline)
                        Text("开启在线状态即可接单")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
    }
}

struct OrderCardView: View {
    let order: BoatOrder
    let onAccept: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                Text(order.startLocation.name)
                    .font(.headline)
            }
            
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                Text(order.endLocation.name)
                    .font(.headline)
            }
            
            Divider()
            
            HStack {
                Text("¥\(String(format: "%.2f", order.price))")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text("\(order.passengerCount)人")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Button(action: onAccept) {
                Text("接单")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 300)
    }
}

struct CustomToggleStyle: ToggleStyle {
    var onText: String
    var offText: String
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text(configuration.isOn ? onText : offText)
                .font(.headline)
                .foregroundColor(configuration.isOn ? .green : .gray)
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.green : Color.gray.opacity(0.5))
                    .frame(width: 50, height: 30)
                
                Circle()
                    .fill(Color.white)
                    .padding(3)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.spring(), value: configuration.isOn)
            }
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
} 