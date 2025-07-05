//
//  ResetPasswordModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 26/02/2025.
//

import Foundation


struct ResetPasswordRequest: Codable {
    let email: String
      let passwordResetOtp: String
    
}


struct ResetPasswordResponse: Codable{
    let message: String
}
