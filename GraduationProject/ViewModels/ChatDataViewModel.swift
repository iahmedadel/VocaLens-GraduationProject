import SwiftUI
import SwiftData

@Observable
class ChatDataViewModel {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Chat Messages Operations
    
    func saveMessage(text: String, isUser: Bool) {
        let message = ChatMessage(text: text, isUser: isUser)
        modelContext.insert(message)
        try? modelContext.save()
    }
    
    func fetchMessages() -> [ChatMessage] {
        let descriptor = FetchDescriptor<ChatMessage>(sortBy: [SortDescriptor(\.timestamp)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Favorite Chats Operations
    
    func saveFavoriteChat(name: String, lastMessage: String, iconName: String, messages: [ChatMessage]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timestamp = formatter.string(from: Date())
        
        let favoriteChat = FavoriteChat(
            name: name,
            lastMessage: lastMessage,
            timestamp: timestamp,
            iconName: iconName,
            messages: messages
        )
        
        modelContext.insert(favoriteChat)
        try? modelContext.save()
    }
    
    func fetchFavoriteChats() -> [FavoriteChat] {
        let descriptor = FetchDescriptor<FavoriteChat>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func deleteFavoriteChat(_ chat: FavoriteChat) {
        modelContext.delete(chat)
        try? modelContext.save()
    }
} 