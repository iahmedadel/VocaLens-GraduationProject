//
//  LoginViewModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 18/02/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    var onSuccess: ((String, String) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    func postLogin(email: String, password: String) {
        let login = loginRequest(email: email, password: password)
        
        isLoading = true
        onLoading?(true)
        
        APIService.shared.postData(to: Apis.logIn, body: login) { (result: Result<LoginResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                self.onLoading?(false)

                switch result {
                case .success(let response):
 
           
                    self.onSuccess?(response.accessToken, response.refreshToken)
                    Keychain.save(key: "accessToken", data: response.accessToken)
                    Keychain.save(key: "refreshToken", data: response.refreshToken)

                case .failure(let error):
                    print("Login Failed: \(error.localizedDescription)")
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
