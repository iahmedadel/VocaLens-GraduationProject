//
//  OtpModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 17/02/2025.
//

import Foundation
struct Otp: Codable {
    let email: String
    let otpCode: String
}
struct otpResponse: Codable{
    let message:String
}

struct reSendOtp: Codable{
    let email: String
}
