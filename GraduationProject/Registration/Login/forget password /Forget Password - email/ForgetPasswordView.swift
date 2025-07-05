//
//  ForgetPasswordView.swift
//  GraduationProject
//
//  Created by MacBook Pro on 19/02/2025.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading = false

    @StateObject private var viewModel = ForgetPasswordViewModel() //search why we use stateobject here for view model
    @AppStorage("paging") var paging: Int = 0
    @EnvironmentObject var userViewModel: UserViewModel


    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.color1, .color]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                
                HStack {
                    Button(action: {
                        paging = 4 // Go back to login screen
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.color)
                            .font(.title2)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Enter your email to reset your password")
                    .font(.body)
                    .foregroundColor(.gray)
                
                
                InputField(label: "Email", placeHolder: "please enter the email", text: $email, fieldType: .email)
                    .padding(.leading,-20)
                    .padding(.trailing,-20)
                
                
                
                
                
                
                
                Button {
                    viewModel.onSuccess = { message in
                        // Save email to UserDefaults for OTPViewModel
                        UserDefaults.standard.set(self.email, forKey: "ForGetPasswordemail")
                        print("Saved email to UserDefaults: \(self.email)")
                        
                        
                        self.showAlert = true
                        self.alertMessage = message

                        userViewModel.userStatus = "forgetpassword"

                    }
                    viewModel.ForgetPassword(email: email)
             
                    
                } label: {
                    if isLoading {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white)) // Customize color
                            .frame(width: 50, height: 50) // Set size
                            .background(Color.mainColorScreen.opacity(0.8)) // Background with opacity
                            .cornerRadius(10) // Rounded corners
                    }
                    else {
                        Text("Reset Password")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColorScreen)
                            .cornerRadius(10)
                    }
                }

                
                
  
                
                Spacer()
            }
            .padding(.top,10)
            .padding(.horizontal)
            Spacer()


            
            
            
            
            
            
            
            
        }
        
        .onAppear{
            viewModel.onLoading = { isLoading in
                self.isLoading = isLoading
                
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK"),action: {
                paging = 6
            }))
        }

    }
    

}

#Preview {
    ForgetPasswordView()
}
