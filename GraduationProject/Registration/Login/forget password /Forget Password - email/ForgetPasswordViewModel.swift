//
//  ForgetPasswordViewModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 19/02/2025.
//

import Foundation
import SwiftUI
class ForgetPasswordViewModel: ObservableObject {
    @State private var isLoading = false

    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    
    func ForgetPassword(email: String) {
        isLoading = true
        onLoading?(true)
        
        let forget = ForgetPasswordRequest(email: email)
        
        APIService.shared.postData(to: Apis.forGetPassword, body: forget) { (result: Result<ForgetPasswordResponse, Error>) in
            DispatchQueue.main.async {
                
                self.isLoading = false
                self.onLoading?(false)
                

                switch result {
                case .success(let response):
 
           
                    self.onSuccess?(response.message)
                    print(response.message)
        

                case .failure(let error):
                    print("Login Failed: \(error.localizedDescription)")
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
