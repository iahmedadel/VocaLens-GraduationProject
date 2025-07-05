import SwiftUI
import SwiftData

@Model
final class ChatMessage {
    var id: UUID
    var text: String
    var isUser: Bool
    var timestamp: Date
    
    init(id: UUID = UUID(), text: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

@Model
final class FavoriteChat {
    var id: UUID
    var name: String
    var lastMessage: String
    var timestamp: String
    var iconName: String
    @Relationship(deleteRule: .cascade) var messages: [ChatMessage]
    
    init(id: UUID = UUID(), name: String, lastMessage: String, timestamp: String, iconName: String, messages: [ChatMessage] = []) {
        self.id = id
        self.name = name
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.iconName = iconName
        self.messages = messages
    }
} 