import Foundation
import CoreLocation

class MockDataService {
    static func generateMockOrders() -> [BoatOrder] {
        var orders: [BoatOrder] = []
        
        // 上海几个地标位置
        let locations = [
            LocationInfo(latitude: 31.2304, longitude: 121.4737, name: "人民广场"),
            LocationInfo(latitude: 31.2398, longitude: 121.4989, name: "陆家嘴"),
            LocationInfo(latitude: 31.1740, longitude: 121.4857, name: "徐家汇"),
            LocationInfo(latitude: 31.2286, longitude: 121.5309, name: "世纪公园"),
            LocationInfo(latitude: 31.2287, longitude: 121.4966, name: "外滩"),
            LocationInfo(latitude: 31.2032, longitude: 121.4372, name: "静安寺")
        ]
        
        // 生成5个模拟订单
        for i in 0..<5 {
            let startLocation = locations[Int.random(in: 0..<locations.count)]
            var endLocation = locations[Int.random(in: 0..<locations.count)]
            
            // 确保起点和终点不同
            while endLocation.name == startLocation.name {
                endLocation = locations[Int.random(in: 0..<locations.count)]
            }
            
            let order = BoatOrder(
                id: UUID().uuidString,
                passengerId: UUID().uuidString,
                boatmanId: i < 2 ? UUID().uuidString : nil, // 前两个订单已有船家接单
                startLocation: startLocation,
                endLocation: endLocation,
                passengerCount: Int.random(in: 1...5),
                price: Double.random(in: 50...200),
                status: i < 2 ? (i == 0 ? .completed : .inProgress) : .pending,
                createdAt: Date().addingTimeInterval(-Double(i * 3600)),
                scheduledTime: Date().addingTimeInterval(Double(i * 1800))
            )
            
            orders.append(order)
        }
        
        return orders
    }
} 