//
//  Apis.swift
//  GraduationProject
//
//  Created by MacBook Pro on 15/02/2025.
//

import Foundation
struct Apis {
    static let signUp = "http://vocalens.runasp.net/api/Auth/register"
    static let otpCode = "http://vocalens.runasp.net/api/Auth/confirm-email"
    static let resendOtpCode = "http://vocalens.runasp.net/api/Auth/resend-confirmation"
    static let logIn = "http://vocalens.runasp.net/api/Auth/login"
    static let forGetPassword = "http://vocalens.runasp.net/api/Auth/forgot-password"
    static let resetPassword = "http://vocalens.runasp.net/api/Auth/reset-password"
    static let resendResetPasswordOTp = "http://vocalens.runasp.net/api/Auth/resend-reset-password"
    static let resetPasswordOTp =  "http://vocalens.runasp.net/api/Auth/verify-resetpass-otp"
    static let refreshToken = "http://vocalens.runasp.net/api/Auth/refresh-token"
    static let updateNewPassword = "http://vocalens.runasp.net/api/Auth/reset-password"
    static let chatHistory = URL(string: "http://vocalens.runasp.net/api/chat-history/filter")!
    static let FontSize = URL(string: "http://vocalens.runasp.net/api/font")!

    
}

