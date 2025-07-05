//
//  NewPasswordViewModel.swift
//  GraduationProject
//
//  Created by MacBook Pro on 26/02/2025.
//

import Foundation
class NewPasswordViewModel: ObservableObject{
    @Published var showError = false
    @Published var success = false
    @Published var isLoading = false
    var onLoading: ((Bool) -> Void)?


    var onError: ((String) -> Void)?
    var onSuccess: ((String) -> Void)?

    func validNewPassword(newPassword:String , confirmNewPassword:String) -> Bool{
        if newPassword == confirmNewPassword {
            return true
        }
        else {
            return false
        }
    }

    
    
    func postUpdateNewPassword(newPassword:String){
        isLoading = true
        onLoading?(true)
        
        let updatePassword = updatePasswordRequest(email:getUserEmail() , newPassword: newPassword)
        APIService.shared.postData(to: Apis.updateNewPassword, body: updatePassword) {  [weak self] (result: Result<updatePasswordResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Server Response: \(response)")
                    self?.isLoading = false
                    self?.onLoading?(false)
                    self?.onSuccess?(response.message)
                    self?.showError = false
                    self?.success = true
                    
                case .failure(let error):
                    print("Error verifying OTP: \(error.localizedDescription)")
                    self?.onError?(error.localizedDescription)
                    
                    self?.showError = true
                    self?.success = false
                }
            }
        }
    }
    private func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: "ForGetPasswordemail") ?? ""
    }
}

