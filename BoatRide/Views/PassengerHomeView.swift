import SwiftUI
import MapKit

struct PassengerHomeView: View {
    @EnvironmentObject var orderManager: OrderManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var showingOrderSheet = false
    @State private var selectedStartLocation: LocationInfo?
    @State private var selectedEndLocation: LocationInfo?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("滴滴打船")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    
                    Button(action: {
                        showingOrderSheet = true
                    }) {
                        HStack {
                            Image(systemName: "ferry")
                                .font(.title2)
                            Text("预约船只")
                                .font(.title3)
                                .bold()
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
        .sheet(isPresented: $showingOrderSheet) {
            OrderSheetView()
                .environmentObject(orderManager)
        }
    }
}

struct OrderSheetView: View {
    @EnvironmentObject var orderManager: OrderManager
    @Environment(\.dismiss) var dismiss
    
    @State private var startLocation = ""
    @State private var endLocation = ""
    @State private var passengerCount = 1
    @State private var scheduledTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("上船地点")) {
                    TextField("请输入上船位置", text: $startLocation)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("目的地")) {
                    TextField("请输入目的地", text: $endLocation)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("乘客人数")) {
                    Stepper("\(passengerCount) 人", value: $passengerCount, in: 1...10)
                }
                
                Section(header: Text("预约时间")) {
                    DatePicker("选择时间", selection: $scheduledTime, in: Date()...)
                        .datePickerStyle(.compact)
                }
                
                Section {
                    Button(action: createOrder) {
                        Text("立即预约")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("预约船只")
            .navigationBarItems(trailing: Button("关闭") {
                dismiss()
            })
        }
    }
    
    func createOrder() {
        // 创建模拟位置信息
        let start = LocationInfo(
            latitude: 31.2304,
            longitude: 121.4737,
            name: startLocation
        )
        
        let end = LocationInfo(
            latitude: 31.2404,
            longitude: 121.4837,
            name: endLocation
        )
        
        orderManager.createOrder(
            start: start,
            end: end,
            passengerCount: passengerCount,
            scheduledTime: scheduledTime
        )
        
        dismiss()
    }
}

// 用于实现圆角
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
} 