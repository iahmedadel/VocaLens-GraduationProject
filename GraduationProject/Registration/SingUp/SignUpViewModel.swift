import Foundation

class SignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onSuccess: ((String) -> Void)?

    func signUp(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) {
        isLoading = true
        onLoading?(true)  

        let signUpData = SignUpRequest(email: email, password: password, confirmPassword: confirmPassword, firstName: firstName, lastName: lastName)

        APIService.shared.postData(to: Apis.signUp, body: signUpData) { [weak self] (result: Result<SignUpResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.onLoading?(false)
                
                switch result {
                case .success(let response):
                    print("Sign Up Success: \(response.message)")
                    self.onSuccess?(response.message)
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
