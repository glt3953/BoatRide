import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var isRequestingCode = false
    @State private var countdown = 0
    @State private var userType: UserType = .passenger
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "ferry.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("滴滴打船")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("手机号码")
                    .font(.headline)
                
                TextField("请输入手机号", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("验证码")
                    .font(.headline)
                
                HStack {
                    TextField("请输入验证码", text: $verificationCode)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: requestVerificationCode) {
                        Text(countdown > 0 ? "\(countdown)秒" : "获取验证码")
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(countdown > 0 ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(countdown > 0 || phoneNumber.isEmpty)
                }
            }
            
            Picker("用户类型", selection: $userType) {
                Text("乘客").tag(UserType.passenger)
                Text("船家").tag(UserType.boatman)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)
            
            Button(action: login) {
                Text("登录")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(phoneNumber.isEmpty || verificationCode.isEmpty)
            
            Spacer()
            
            Text("登录即代表您同意《用户协议》和《隐私政策》")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
        .padding()
        .onReceive(timer) { _ in
            if countdown > 0 {
                countdown -= 1
            }
        }
    }
    
    func requestVerificationCode() {
        // 实际项目中应该调用API发送验证码
        countdown = 60
        isRequestingCode = true
    }
    
    func login() {
        userManager.login(phoneNumber: phoneNumber, verificationCode: verificationCode)
        // 设置用户类型
        if var user = userManager.currentUser {
            user.userType = userType
            userManager.currentUser = user
        }
    }
} 