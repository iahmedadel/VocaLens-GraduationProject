//
//  loadingScreenOtp.swift
//  GraduationProject
//
//  Created by MacBook Pro on 16/02/2025.
//
import SwiftUI

struct LoadingView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var navigateToNextScreen = false
    @AppStorage("paging") var paging: Int = 0
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        ZStack {
            
            //   Color(.color) // Background color
            
//            LinearGradient(gradient: Gradient(colors: [.color1, .color]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
            LinearGradient(gradient: Gradient(colors: [.white, .color1]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Extend to the whole screen
            
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color(.color1), lineWidth: 6) // Background circle
                        .frame(width: 220   , height: 220, alignment: .center)
                    
                    Circle()
                        .trim(from: 0.0, to: progress) // Animating progress circle
                        .stroke(Color(.color), lineWidth: 6)
                        .rotationEffect(.degrees(-90)) // Start from top
                        .animation(.easeInOut(duration: 10), value: progress)
                }
                .frame(width: 174, height: 174) // Twice the radius
            }
            Text("VocaLens")
               // .padding(.top,-100)
            
                .foregroundStyle(Color(hex: "31babe"))
                .font(.custom("Rockwell Bold", size: 30))
        }
        .onAppear {
            print("User Status: \(userViewModel.userStatus)")
            progress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                print("Navigating with userStatus: \(userViewModel.userStatus)")
                navigateToNextScreen = true
            }
        }
        .fullScreenCover(isPresented: $navigateToNextScreen) {
            
            if userViewModel.userStatus == "SignedUp" {
                OTPScreen() // Replace with your OTP screen

            }
            else if userViewModel.userStatus == "forgetpassword"{
                ResetPasswordOtpView()

            }
        }
    }
}

#Preview {
    LoadingView()
}
