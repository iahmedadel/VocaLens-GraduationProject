//
//  ForgetPasswordModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 19/02/2025.
//

import Foundation
struct ForgetPasswordRequest: Codable {
    let email: String
}
struct ForgetPasswordResponse: Codable {
    let message: String
}
