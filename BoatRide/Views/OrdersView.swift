import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderManager: OrderManager
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("订单类型", selection: $selectedSegment) {
                    Text("进行中").tag(0)
                    Text("已完成").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedSegment == 0 {
                    List {
                        ForEach(orderManager.orderHistory.filter { 
                            $0.status == .pending || $0.status == .accepted || $0.status == .onTheWay || $0.status == .inProgress
                        }) { order in
                            OrderListItemView(order: order)
                        }
                    }
                } else {
                    List {
                        ForEach(orderManager.orderHistory.filter { 
                            $0.status == .completed || $0.status == .cancelled
                        }) { order in
                            OrderListItemView(order: order)
                        }
                    }
                }
            }
            .navigationTitle("我的订单")
        }
    }
}

struct OrderListItemView: View {
    let order: BoatOrder
    
    var statusColor: Color {
        switch order.status {
        case .pending:
            return .orange
        case .accepted, .onTheWay, .inProgress:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(order.createdAt, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text(order.startLocation.name)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text(order.endLocation.name)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Text("¥\(String(format: "%.2f", order.price))")
                    .font(.headline)
            }
            
            HStack {
                Text("\(order.passengerCount)人")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("·")
                    .foregroundColor(.gray)
                
                Text(order.scheduledTime, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
} 