//
//  HomeViewModel.swift
//  VocaLens
//
//  Created by MacBook Pro on 18/06/2025.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var backendMessage: String? // Publishes the backend response message
    // Inject LoginViewModel as a dependency
    private let loginViewModel: LoginViewModel

    init(loginViewModel: LoginViewModel = LoginViewModel()) {
        self.loginViewModel = loginViewModel
        loginViewModel.postLogin(email: "abdelrahmandiab861@gmail.com", password: "Abdo.123")

    }

   
     func makeFontRequest(body: Int) {
        let bodyrequest = FontRequest(fontSize: body)

        APIService.shared.postChatData(to: Apis.FontSize, body: bodyrequest, bearerToken: Keychain.load(key: "accessToken")!) { (result: Result<[FontResponse], Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    print("API Success: Received \(response))")
                    
                    self.errorMessage = nil
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: Error) {
        let errorDescription = error.localizedDescription
        print("API Failure: \(errorDescription)")
        if let urlError = error as? URLError {
            if urlError.code == .notConnectedToInternet {
                errorMessage = "No internet connection. Please check your network.".localized
            } else if urlError.code == .timedOut {
                errorMessage = "Request timed out. Please try again later.".localized
            } else {
                errorMessage = "Network error: \(errorDescription)".localized
            }
        } else if let decodingError = error as? DecodingError {
            errorMessage = "Failed to parse server response. Please try again.".localized
            print("Decoding Error: \(decodingError)")
        } else if let httpError = error as? HTTPError {
            switch httpError {
            case .unauthorized:
                errorMessage = "Session expired. Please log in again.".localized
            case .forbidden:
                errorMessage = "Access denied. Contact support.".localized
            case .serverError:
                errorMessage = "Server error. Please try again later.".localized
            case .other(let code):
                errorMessage = "HTTP error: \(code)".localized
            }
        } else {
            errorMessage = "Unexpected error: \(errorDescription)".localized
        }
    }
}

struct FontRequest: Codable{
    let fontSize: Int
}


struct FontResponse: Codable{
    let message: String
    let fontSize: Int
}
