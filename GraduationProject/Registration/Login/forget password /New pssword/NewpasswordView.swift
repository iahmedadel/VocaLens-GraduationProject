//
//  Newpassword.swift
//  GraduationProject
//
//  Created by MacBook Pro on 20/02/2025.
//

import SwiftUI

struct NewPasswordScreen: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showNewPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var isLoading = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @AppStorage("paging") var paging: Int = 0
    @StateObject private var viewModel  = NewPasswordViewModel()
    @EnvironmentObject var userViewModel: UserViewModel



    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.color1, .color]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Set New Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Please enter and confirm your new password.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)


                InputField(label: "New Password", placeHolder: "please enter the new password", text: $newPassword, fieldType: .password)
                InputField(label: "Confirm New Password", placeHolder: "please confirm the new password", text: $confirmPassword, fieldType: .password)


                Button(action: {
                    if viewModel.validNewPassword(newPassword:newPassword, confirmNewPassword: confirmPassword) {
                        viewModel.postUpdateNewPassword(newPassword: newPassword)
                    }
                }) {
                    if isLoading {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 50, height: 50)
                            .background(Color.mainColorScreen.opacity(0.8))
                            .cornerRadius(10) 
                    }
                    else {
                        Text("Update Password")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mainColorScreen)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .padding(.top, 50)
            .onAppear{
                viewModel.onLoading = { isLoading in
                    self.isLoading = isLoading
                }
                viewModel.onError = { message in
                    self.alertTitle = "Error"
                    self.alertMessage = "Invalid Email or password"
                    self.showAlert = true
                }
                viewModel.onSuccess = { success in
                    self.alertTitle = "Password Reseted Successfully"
                    self.alertMessage = ""
                    self.showAlert = true
                    self.userViewModel.userStatus = "" // Clear userStatus for login
                        
                    // here navigates to login after reseted password
                    
                    
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    self.paging = 4
                }
            } message: {
                Text(alertMessage)
            }
        }
    }


}

// MARK: - Preview
#Preview {
    NewPasswordScreen()
}

