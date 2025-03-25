import Foundation
import Combine

enum UserType: String, Codable {
    case passenger
    case boatman
}

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var phoneNumber: String
    var userType: UserType
    var avatarURL: URL?
}

class UserManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    
    func login(phoneNumber: String, verificationCode: String) {
        // 实际项目中应该调用API验证登录
        isLoggedIn = true
        
        // 模拟用户数据
        currentUser = User(
            id: UUID().uuidString,
            name: "测试用户",
            phoneNumber: phoneNumber,
            userType: .passenger
        )
    }
    
    func logout() {
        isLoggedIn = false
        currentUser = nil
    }
    
    func switchUserType() {
        guard var user = currentUser else { return }
        user.userType = user.userType == .passenger ? .boatman : .passenger
        currentUser = user
    }
} 