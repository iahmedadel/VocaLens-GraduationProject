//
//  LoginModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 19/02/2025.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}



struct loginRequest: Codable {
    let email: String
    let password: String
}
