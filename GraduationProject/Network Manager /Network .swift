////
////  Network .swift
////  GraduationProject
////
////  Created by MacBook Pro on 15/02/2025.
////
//
//import Foundation
//class APIService {
//    static let shared = APIService()
//    private init() {}
//    
//    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let requestUrl = URL(string: url) else {
//            completion(.failure(URLError(.badURL)))
//            return
//        }
//
//        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(URLError(.badServerResponse)))
//                return
//            }
//
//            // 🔍 Print raw data
//            if let rawString = String(data: data, encoding: .utf8) {
//                print("✅ Raw Response:\n\(rawString)")
//            } else {
//                print("⚠️ Could not decode raw response to string.")
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func postData<T: Decodable, U: Encodable>(to urlString: String, body: U, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(body)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
//                return
//            }
//            
//            // Print the raw response for debugging
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Raw Response: \(jsonString)")
//            } else {
//                print("Raw Response: (Could not convert data to string)")
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(decodedData))
//                }
//            } catch {
//                print("Decoding Error: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//}


//
//  Network .swift
//  GraduationProject
//
//  Created by MacBook Pro on 15/02/2025.
//

import Foundation
class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestUrl = URL(string: url) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // 🔍 Print raw data
            if let rawString = String(data: data, encoding: .utf8) {
                print("✅ Raw Response:\n\(rawString)")
            } else {
                print("⚠️ Could not decode raw response to string.")
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func postData<T: Decodable, U: Encodable>(to urlString: String, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            // Print the raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(jsonString)")
            } else {
                print("Raw Response: (Could not convert data to string)")
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
//    func postChatData<T: Decodable, U: Encodable>(to urlString: String, body: U, bearerToken: String, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(body)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
//                return
//            }
//            
//            // Print the raw response for debugging
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Raw Response: \(jsonString)")
//            } else {
//                print("Raw Response: (Could not convert data to string)")
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(decodedData))
//                }
//            } catch {
//                print("Decoding Error: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    
        func postChatData<T: Codable, U: Codable>(to url: URL, body: T, bearerToken: String, completion: @escaping (Result<U, Error>) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
                print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "Invalid body")")
            } catch {
                print("Encoding error: \(error)")
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    print("Invalid response")
                    completion(.failure(error))
                    return
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(responseString)")
                } else {
                    print("Raw Response: <No data>")
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let error: Error
                    switch httpResponse.statusCode {
                    case 401:
                        error = HTTPError.unauthorized
                    case 403:
                        error = HTTPError.forbidden
                    case 500..<600:
                        error = HTTPError.serverError
                    default:
                        error = HTTPError.other(httpResponse.statusCode)
                    }
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server error message: \(errorMessage)")
                    }
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    print("No data received")
                    completion(.failure(error))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(U.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Decoding error: \(error)")
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("Response data: \(dataString)")
                    }
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
}
