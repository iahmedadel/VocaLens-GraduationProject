//
//  Chat Model.swift
//  GraduationProject
//
//  Created by MacBook Pro on 14/02/2025.
//


import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

//struct ChatHistoryModel: Codable {
//    let id: Int
//    let englishText: String?
//    let arabicText: String?
//    let timestamp: String
//}

//struct Message: Identifiable {
//    let id = UUID()
//    let text: String
//    let isUser: Bool
//    let timestamp: Date // Add this if it's missing
//}
struct ChatHistoryModel: Identifiable {
    let id: Int
    let englishText: String?
    let arabicText: String?
    let timestamp: String
    
}
