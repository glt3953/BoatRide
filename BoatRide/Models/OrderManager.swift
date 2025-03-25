import Foundation
import Combine
import CoreLocation

enum OrderStatus: String, Codable {
    case pending = "等待接单"
    case accepted = "已接单"
    case onTheWay = "正在前往"
    case inProgress = "行程中"
    case completed = "已完成"
    case cancelled = "已取消"
}

struct BoatOrder: Identifiable, Codable {
    var id: String
    var passengerId: String
    var boatmanId: String?
    var startLocation: LocationInfo
    var endLocation: LocationInfo
    var passengerCount: Int
    var price: Double
    var status: OrderStatus
    var createdAt: Date
    var scheduledTime: Date
}

struct LocationInfo: Codable {
    var latitude: Double
    var longitude: Double
    var name: String
}

class OrderManager: ObservableObject {
    @Published var currentOrder: BoatOrder?
    @Published var orderHistory: [BoatOrder] = []
    @Published var availableOrders: [BoatOrder] = []
    
    init() {
        // 加载模拟数据
        let mockOrders = MockDataService.generateMockOrders()
        orderHistory = mockOrders
        availableOrders = mockOrders.filter { $0.status == .pending }
    }
    
    func createOrder(start: LocationInfo, end: LocationInfo, passengerCount: Int, scheduledTime: Date) {
        let order = BoatOrder(
            id: UUID().uuidString,
            passengerId: UUID().uuidString, // 实际项目中使用真实用户ID
            boatmanId: nil,
            startLocation: start,
            endLocation: end,
            passengerCount: passengerCount,
            price: calculatePrice(from: start, to: end, passengerCount: passengerCount),
            status: .pending,
            createdAt: Date(),
            scheduledTime: scheduledTime
        )
        
        currentOrder = order
        orderHistory.append(order)
        availableOrders.append(order)
        
        // 实际项目中应该将订单发送至服务器
    }
    
    private func calculatePrice(from start: LocationInfo, to end: LocationInfo, passengerCount: Int) -> Double {
        // 简单价格计算逻辑
        let distance = calculateDistance(from: start, to: end)
        let basePrice = distance * 2.0
        let passengerFactor = Double(passengerCount) * 0.5
        
        return basePrice + passengerFactor
    }
    
    private func calculateDistance(from start: LocationInfo, to end: LocationInfo) -> Double {
        let startCoord = CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude)
        let endCoord = CLLocationCoordinate2D(latitude: end.latitude, longitude: end.longitude)
        
        let startLocation = CLLocation(latitude: startCoord.latitude, longitude: startCoord.longitude)
        let endLocation = CLLocation(latitude: endCoord.latitude, longitude: endCoord.longitude)
        
        return endLocation.distance(from: startLocation) / 1000.0 // 转换为公里
    }
    
    func acceptOrder(orderId: String, boatmanId: String) {
        if let index = availableOrders.firstIndex(where: { $0.id == orderId }) {
            availableOrders[index].boatmanId = boatmanId
            availableOrders[index].status = .accepted
            
            // 更新历史订单
            if let historyIndex = orderHistory.firstIndex(where: { $0.id == orderId }) {
                orderHistory[historyIndex].boatmanId = boatmanId
                orderHistory[historyIndex].status = .accepted
            }
            
            // 实际项目中应该将更新发送至服务器
        }
    }
} 