//
//  Favorites model.swift
//  GraduationProject
//
//  Created by Khalid Gad on 06/04/2025.
//

import Foundation
import SwiftUICore
import SwiftUI

//struct FavChat: Identifiable {
//    var id = UUID()
//    var name: String
//    var lastMessage: String
//    var timestamp: String
//    var iconName: Image // SF Symbol name
//    var messages: [Message] // List of messages in the favorite chat
//    
//}


//struct FavChat: Identifiable {
//    let id = UUID()
//    var name: String
//    var lastMessage: String
//    var timestamp: String
//    var iconName: Image
//    var messages: [Message]
//    
//    // New tracking toggle additions
//    var isCollecting: Bool = false
//    var collectingStartDate: Date? = nil
//}



class FavChat: Identifiable, ObservableObject {
    let id: UUID
    var name: String
    var lastMessage: String
    var timestamp: String
    var iconName: Image
    @Published var messages: [Message]

    init(
        id: UUID = UUID(),
        name: String,
        lastMessage: String,
        timestamp: String,
        iconName: Image,
        messages: [Message]
    ) {
        self.id = id
        self.name = name
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.iconName = iconName
        self.messages = messages
    }
}

