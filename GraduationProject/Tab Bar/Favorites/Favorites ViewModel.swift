//
//  Favorites ViewModel.swift
//  GraduationProject
//
//  Created by Khalid Gad on 07/04/2025.
//

import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteChats: [FavChat] = []
    @Published var activeTracking: [String: Bool] = [:] // [FavoriteName: isTrackingEnabled]
}

//class FavoritesViewModel: ObservableObject {
//    @Published var favoriteChats: [FavChat] = []
//    @Published var activeTracking: [String: Bool] = [:]
//    @Published var trackingTimestamps: [UUID: Date] = [:] // Add this
//
//    func toggleTracking(for chat: FavChat, isOn: Bool) {
//        activeTracking[chat.name] = isOn
//        if isOn {
//            trackingTimestamps[chat.id] = Date()
//        } else {
//            trackingTimestamps.removeValue(forKey: chat.id)
//        }
//    }
//
//    func autoSaveMessage(_ message: Message) {
//        for chat in favoriteChats {
//            if let isTracking = activeTracking[chat.name],
//               isTracking,
//               let timestamp = trackingTimestamps[chat.id],
//               message.timestamp >= timestamp {
//                chat.messages.append(message)
//                chat.lastMessage = message.text
//                chat.timestamp = formatDate(message.timestamp)
//            }
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm a"
//        return formatter.string(from: date)
//    }
//}



//class FavoritesViewModel: ObservableObject {
//    @Published var favoriteChats: [FavChat] = []
//    @Published var activeTracking: [String: Bool] = [:] // [FavoriteName: isTrackingEnabled]
//    
//    func updateFavoriteChat(updatedChat: FavChat) {
//        if let index = favoriteChats.firstIndex(where: { $0.id == updatedChat.id }) {
//            favoriteChats[index] = updatedChat
//        }
//    }
//}
