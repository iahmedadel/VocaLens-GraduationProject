
// sign up screen

import SwiftUI

struct SignUpScreen: View {
    // Properties stored in UserDefaults
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("phoneNumber") var phoneNumber: String = ""

    @StateObject private var viewModel = SignUpViewModel()
    
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @EnvironmentObject var userViewModel: UserViewModel

    @AppStorage("paging") var paging: Int = 0
    
    // Animation state for text writing effect
    @State private var animatedText = ""
    private let fullText = "Welcome To VocaLens App!"

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.color1, .color]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(animatedText).bold()
                    .foregroundColor(Color(hex: "31babe"))
                    .font(.system(size: 26))
                    .padding(.top, -30)
                    .onAppear {
                        animateText()
                    }
             
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("First Name")
                            .foregroundColor(Color(hex: "555555"))
                            .padding(.leading, 20)
                            .padding(.bottom, 16)
                        
                        ZStack {
                            TextField("First Name", text: $firstName)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                                .padding(.leading, 16)
                                .frame(width: 200, height: 30)
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.leading, 150)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Last Name")
                            .foregroundColor(Color(hex: "555555"))
                            .padding(.leading, 4)
                            .padding(.bottom, 16)
                        ZStack {
                            TextField("Last Name", text: $lastName)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                                .padding(.trailing, 16)
                                .frame(width: 200, height: 30)
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.leading, 120)
                        }
                    }
                }
                .padding(.top, 50)
                
                InputField(label: "Email", placeHolder: "Enter Your Email", text: $email, fieldType: .email, iconName: "emailImage").padding(.top, 26)

                InputField(label: "Password", placeHolder: "Enter Your Password", text: $password, fieldType: .password)
                    
                InputField(label: "Confirmed Password", placeHolder: "Enter Your Confirmed Password", text: $confirmedPassword, fieldType: .password)
                
                Button {
                    if validateInputs() {
                        viewModel.signUp(email: email, password: password, confirmPassword: confirmedPassword, firstName: firstName, lastName: lastName)
                    }
                    saveUserData() // Save data when signing up
                //    paging = 4
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 50, height: 50)
                            .background(Color.mainColorScreen.opacity(0.8))
                            .cornerRadius(10)
                    } else {
                        Text("Sign Up")
                            .foregroundStyle(Color.mainColorScreen)
                            .padding(.horizontal, 155.0)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.top, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
                
                HStack {
                    Text("Already have an account?").padding(.top, 20)
                    Button {
                        paging = 4
                    } label: {
                        Text("Sign In").font(.title3)
                            .foregroundStyle(Color(hex: "CCF3FF"))
                            .underline()
                            .padding(.top, 18)
                    }
                }
            }
        }
        .onAppear {
            viewModel.onLoading = { isLoading in
                self.isLoading = isLoading
            }
            viewModel.onError = { message in
                self.alertTitle = "Error"
                self.alertMessage = message
                self.showAlert = true
            }
            viewModel.onSuccess = { successMessage in
                self.alertTitle = "Success"
                self.alertMessage = successMessage
                self.showAlert = true
                print("Sign-up successful! \(successMessage)")
                // Set userStatus for LoadingView navigation
                        self.userViewModel.userStatus = "SignedUp"
                print("Set userStatus to: \(self.userViewModel.userStatus)")
                paging = 6
            }
            
            loadUserData() // Load data when screen appears
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func animateText() {
        animatedText = ""
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if index < fullText.count {
                let character = fullText[fullText.index(fullText.startIndex, offsetBy: index)]
                animatedText.append(character)
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    
    private func validateInputs() -> Bool {
            let emailRegex = "[a-z._%+a-z-0-9]+@[A-Za-z0-9.-]+\\.(com|net|org)$"
            let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
    
            if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
                showAlert(title: "Invalid Email", message: "Please, enter your correct email")
                return false
            }
    
            if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
                showAlert(title: "Invalid Password", message: "Password must be at least 8 characters, contain uppercase, lowercase, a number, and a special character.")
                return false
            }
        
            if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
                   showAlert(title: "Missing Information", message: "All fields are required.")
                   return false
               }
    
            if password != confirmedPassword {
                showAlert(title: "Password Mismatch", message: "Passwords do not match!.")
                return false
            }
    
            return true
        }
    
        private func showAlert(title: String, message: String) {
            alertTitle = title
            alertMessage = message
            showAlert = true
        }
    
    
    private func saveUserData() {
        let userData: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNumber": phoneNumber
        ]
        UserDefaults.standard.set(userData, forKey: "UserData")
    }
    
    private func loadUserData() {
        if let savedData = UserDefaults.standard.dictionary(forKey: "UserData") as? [String: String] {
            firstName = savedData["firstName"] ?? ""
            lastName = savedData["lastName"] ?? ""
            email = savedData["email"] ?? ""
            phoneNumber = savedData["phoneNumber"] ?? ""
        }
    }
}

#Preview {
    SignUpScreen()
}
