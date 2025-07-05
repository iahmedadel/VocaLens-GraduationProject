//
//  ResetPasswordOtpView.swift
//  GraduationProject
//
//  Created by MacBook Pro on 17/06/2025.
//

import SwiftUI

struct ResetPasswordOtpView: View {
        @StateObject private var viewModel = ResetPasswordOTPViewModel()
        @FocusState private var focusedIndex: Int?
        
        
        // 3shan lw hbena ntb3 el error w el success mn el backend direct 3la hena
        @State private var showAlert = false
        @State private var alertTitle = ""
        @State private var alertMessage = ""
        
        @AppStorage("paging") var paging: Int = 0
        @EnvironmentObject var userViewModel: UserViewModel
        

        var body: some View {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.white, .color1]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Extend to the whole screen
                
                VStack {
                    HStack {
                        Button(action: {
                            paging = 7 // Go back to forgot password screen
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.color)
                                .font(.title2)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    if viewModel.showCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                            .transition(.scale)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: viewModel.showCheckmark)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    paging = 4
                                }
                            }
                    } else {
                        Text("Enter OTP")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)

                        Text("We have sent a verification code to your Email.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        HStack {
                            ForEach(0..<5, id: \.self) { index in
                                TextField("", text: $viewModel.otp[index])
                                    .frame(width: 50, height: 50)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: .gray.opacity(0.3), radius: 5)
                                    .focused($focusedIndex, equals: index)
                                    .onChange(of: viewModel.otp[index]) { newValue in
                                        viewModel.handleInputChange(index: index, value: newValue, focusedIndex: &focusedIndex!)
                                    }
                                
                            }
                        }
                        .padding(.top, 20)
                        
                        
                        if userViewModel.userStatus == "SignedUp" {
                       //     Text("i comes from sign up")
                            
                        }
                        else if userViewModel.userStatus == "forgetpassword"{
                            //Text("i comes from forgetpassword")

                        }
                        
                        if viewModel.showError {
                            Text("Invalid OTP, please try again.")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }

                        if viewModel.success {
                            Text("OTP Verified Successfully!")
                                .foregroundColor(.green)
                                .font(.caption)
                                .padding(.top, 5)
                                .onAppear {
                                            paging = 8
                                        }
                        }
                        

                        if !viewModel.isVerified {
                            Button(action: viewModel.verifyOTP) {
                                
                                Text("Verify OTP")
                                    .foregroundColor(.color1)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.color)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 30)
                            }
                            .padding(.top, 20)
                        }

                        if !viewModel.isResendEnabled {
                            Text("Resend OTP in \(viewModel.timeRemaining)s")
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        } else {
                            Button(action: viewModel.resendOTP) {
                                Text("Resend OTP")
                                    .foregroundColor(.color)
                                    .fontWeight(.bold)
                            }
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .onAppear {
                focusedIndex = 0
            }
        }
    }
#Preview {
    ResetPasswordOtpView()
}
