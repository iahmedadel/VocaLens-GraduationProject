
import SwiftUI
struct LoginScreen: View {
   
    // Properties
    @State var email: String = ""
    @State var password: String = ""
    @StateObject private var viewModel = LoginViewModel() //search why we use stateobject here for view model
    @State private var isLoading = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Navigation using paging
    @AppStorage("paging") var paging: Int = 0
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.color1, .color]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            // Color.color.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, -100)
                    .frame(width: 234 , height: 118, alignment:.center)
               
                Text("VocaLens")
                    .padding(.top,-50)
                    .foregroundStyle(Color(hex: "31babe"))
                    .font(.custom("Rockwell Bold", size: 40))
               

                InputField(label: "Email", placeHolder: "Enter Your Email", text: $email, fieldType: .email, iconName: "emailImage").padding(.top,20)
                
                InputField(label: "Password", placeHolder: "Enter Your Password", text: $password, fieldType: .password).padding(.top,12)
                
                
                Button {
                    paging = 7
                } label: {
                    Text("Forgot Password ?").font(.title3)
                        .foregroundStyle(Color(hex: "CCF3FF"))
                        .underline().padding(.leading, 180)
                }
                
                Button {
                    viewModel.onSuccess = { accessToken, refreshToken in
                        print("Access Token Saved: \(Keychain.load(key: "accessToken"))")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn") // Save login state
                            paging = -1
                       }

                       viewModel.postLogin(email: email, password: password)
                    
                } label: {
                    if isLoading {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white)) // Customize color
                            .frame(width: 50, height: 50) // Set size
                            .background(Color.mainColorScreen.opacity(0.8)) // Background with opacity
                            .cornerRadius(10) // Rounded corners
                    }
                    else {
                        
                        Text("Sign In")
                            .foregroundStyle(Color.mainColorScreen)
                            .padding(.horizontal, 155.0)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)
                .onAppear{
                    viewModel.onLoading = { isLoading in
                        self.isLoading = isLoading
                    }
                    viewModel.onError = { message in
                        self.alertTitle = "Error"
                        self.alertMessage = "Invalid Email or password"
                        self.showAlert = true
                    }
                }
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                HStack{
                    Text("Don't have an account ?")
                        .foregroundStyle(Color(.darkGray))
                        .padding(.top, 20)
                    
                    Button {
                        paging = 5
                    } label: {
                        Text("Sign Up").font(.title3)
                            .foregroundStyle(Color(hex: "CCF3FF"))
                            .underline().padding(.top, 18)
                    }
                }
            }
        }
    }
}
#Preview {
    LoginScreen()
}
