//
//  New Password Model.swift
//  GraduationProject
//
//  Created by MacBook Pro on 26/02/2025.
//

import Foundation

struct updatePasswordRequest: Codable{
    let email: String
    let newPassword: String
}
struct updatePasswordResponse: Codable{
    let message: String
}
