import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        if let url = userManager.currentUser?.avatarURL {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userManager.currentUser?.name ?? "用户")
                                .font(.title2)
                                .bold()
                            
                            Text(userManager.currentUser?.phoneNumber ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text(userManager.currentUser?.userType == .passenger ? "乘客" : "船家")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                                
                                Button("切换身份") {
                                    userManager.switchUserType()
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("账户与安全")) {
                    NavigationLink(destination: Text("个人信息设置")) {
                        Label("个人信息", systemImage: "person")
                    }
                    
                    NavigationLink(destination: Text("支付设置")) {
                        Label("支付管理", systemImage: "creditcard")
                    }
                    
                    NavigationLink(destination: Text("隐私设置")) {
                        Label("隐私设置", systemImage: "hand.raised")
                    }
                }
                
                Section(header: Text("帮助与支持")) {
                    NavigationLink(destination: Text("常见问题")) {
                        Label("常见问题", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: Text("联系客服")) {
                        Label("联系客服", systemImage: "message")
                    }
                    
                    NavigationLink(destination: Text("关于我们")) {
                        Label("关于我们", systemImage: "info.circle")
                    }
                }
                
                Section {
                    Button(action: {
                        userManager.logout()
                    }) {
                        Text("退出登录")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("我的")
        }
    }
} 