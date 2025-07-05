//
//  Model.swift
//  GraduationProject
//
//  Created by MacBook Pro on 15/02/2025.
//

import Foundation


struct SignUpRequest: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let firstName: String
    let lastName: String
//    let phoneNumber: String
}
struct SignUpResponse: Codable {
    let message: String
}
