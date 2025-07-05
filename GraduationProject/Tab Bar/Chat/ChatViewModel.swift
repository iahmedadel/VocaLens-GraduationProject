//
//import Foundation
//
//class ChatViewModel: ObservableObject {
//    @Published var isLoading = false
//    @Published var chatHistory: [ChatHistoryModel] = []
//    @Published var errorMessage: String? = nil
//    
//    
//    func fetchChatHistory(language: String, completion: @escaping ([ChatHistoryModel]?) -> Void) {
//        isLoading = true
//        let body = RequestBody(filterType: language)
////        guard let token = Keychain.load(key: "accessToken") else {
////            print("Error: No access token found in Keychain")
////            DispatchQueue.main.async {
////                self.isLoading = false
////                self.errorMessage = "No access token found.".localized
////                completion(nil)
////            }
////            return
////        }
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI1YmJlNmNhOC1lYjk2LTRhZTUtOTQ1Ni00YWQ0OTJjNTI3YTEiLCJlbWFpbCI6ImFiZGVscmFobWFuZGlhYjg2MUBnbWFpbC5jb20iLCJ1bmlxdWVfbmFtZSI6ImFiZGVscmFobWFuZGlhYjg2MUBnbWFpbC5jb20iLCJGaXJzdE5hbWUiOiJBYmRvIiwiTGFzdE5hbWUiOiJEaWFiIiwibmJmIjoxNzUwMzE2MzMzLCJleHAiOjE3NTAzMTcyMzMsImlhdCI6MTc1MDMxNjMzMywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTEwNSIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjUxMDUifQ.z4PEKQSzxCj0hOlI3k98X2v7B3DSc5RJmVtVe9Hkpo4"
//        
//        print("API Request: URL=\(Apis.chatHistory), Token=\(token.prefix(10))..., Body=\(body.filterType)")
//        
//        APIService.shared.postChatData(to: Apis.chatHistory, body: body, bearerToken: token) { (result: Result<[ResponseData], Error>) in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch result {
//                case .success(let response):
//                    print("API Success: Received \(response.count) items: \(response)")
//                    let history = response.map { data in
//                        ChatHistoryModel(
//                            id: data.id,
//                            englishText: data.englishText,
//                            arabicText: data.arabicText,
//                            timestamp: data.timestamp
//                        )
//                    }
//                    self.chatHistory = history
//                    self.errorMessage = nil
//                    completion(history)
//                case .failure(let error):
//                    let errorDescription = error.localizedDescription
//                    print("API Failure: \(errorDescription)")
//                    if let urlError = error as? URLError {
//                        if urlError.code == .notConnectedToInternet {
//                            self.errorMessage = "No internet connection.".localized
//                        } else if urlError.code == .timedOut {
//                            self.errorMessage = "Request timed out.".localized
//                        } else {
//                            self.errorMessage = "Network error: \(errorDescription)".localized
//                        }
//                    } else if let decodingError = error as? DecodingError {
//                        self.errorMessage = "Invalid response format.".localized
//                        print("Decoding Error: \(decodingError)")
//                    } else if let httpError = error as? HTTPError {
//                        switch httpError {
//                        case .unauthorized:
//                            self.errorMessage = "Invalid or expired token.".localized
//                        case .forbidden:
//                            self.errorMessage = "Access denied.".localized
//                        case .serverError:
//                            self.errorMessage = "Server error.".localized
//                        case .other(let code):
//                            self.errorMessage = "HTTP error: \(code)".localized
//                        }
//                    } else {
//                        self.errorMessage = "Unknown error: \(errorDescription)".localized
//                    }
//                    completion(nil)
//                }
//            }
//        }
//    }
//}
//
//struct ResponseData: Codable {
//    let id: Int
//    let englishText: String
//    let arabicText: String
//    let timestamp: String
//}
//
//struct RequestBody: Codable {
//    let filterType: String
//}
//
//enum HTTPError: Error {
//    case unauthorized
//    case forbidden
//    case serverError
//    case other(Int)
//}

import Foundation
import SwiftUI
class ChatViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var chatHistory: [ChatHistoryModel] = []
    @Published var errorMessage: String? = nil
     private var viewModel = LoginViewModel() //search why we use stateobject here for view model

    
    func fetchChatHistory(language: String, completion: @escaping ([ChatHistoryModel]?) -> Void) {
        isLoading = true
        let body = RequestBody(filterType: language)
        

        viewModel.postLogin(email: "abdelrahmandiab861@gmail.com", password: "Abdo.123")

        

        let token = Keychain.load(key: "accessToken")!
        
        print("API Request: URL=\(Apis.chatHistory), Token=\(token.prefix(10))..., Body=\(body.filterType)")
        
        APIService.shared.postChatData(to: Apis.chatHistory, body: body, bearerToken: token) { (result: Result<[ResponseData], Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    print("API Success: Received \(response.count) items: \(response)")
                    let history = response.map { data in
                        ChatHistoryModel(
                            id: data.id,
                            englishText: data.englishText,
                            arabicText: data.arabicText,
                            timestamp: data.timestamp
                        )
                    }
                    self.chatHistory = history
                    self.errorMessage = nil
                    completion(history)
                case .failure(let error):
                    let errorDescription = error.localizedDescription
                    print("API Failure: \(errorDescription)")
                    if let urlError = error as? URLError {
                        if urlError.code == .notConnectedToInternet {
                            self.errorMessage = "No internet connection. Please check your network.".localized
                        } else if urlError.code == .timedOut {
                            self.errorMessage = "Request timed out. Please try again later.".localized
                        } else {
                            self.errorMessage = "Network error: \(errorDescription)".localized
                        }
                    } else if let decodingError = error as? DecodingError {
                        self.errorMessage = "Failed to parse server response. Please try again.".localized
                        print("Decoding Error: \(decodingError)")
                    } else if let httpError = error as? HTTPError {
                        switch httpError {
                        case .unauthorized:
                            self.errorMessage = "Session expired. Please log in again.".localized
                        case .forbidden:
                            self.errorMessage = "Access denied. Contact support.".localized
                        case .serverError:
                            self.errorMessage = "Server error. Please try again later.".localized
                        case .other(let code):
                            self.errorMessage = "HTTP error: \(code)".localized
                        }
                    } else {
                        self.errorMessage = "Unexpected error: \(errorDescription)".localized
                    }
                    completion(nil)
                }
            }
        }
    }
}

struct ResponseData: Codable {
    let id: Int
    let englishText: String?
    let arabicText: String?
    let translatedText: String?
    let timestamp: String
}

struct RequestBody: Codable {
    let filterType: String
}

enum HTTPError: Error {
    case unauthorized
    case forbidden
    case serverError
    case other(Int)
}
