//import SwiftUI
//import PhotosUI
//import SwiftData
//
//struct SelectableMessage: Identifiable, Equatable, Hashable {
//    enum SourceType { case local, backend }
//    let id: String // UUID for local, Int for backend as String
//    let text: String
//    let isUser: Bool
//    let source: SourceType
//    let originalLocal: ChatMessage?
//    let originalBackend: ChatHistoryModel?
//    
//    static func == (lhs: SelectableMessage, rhs: SelectableMessage) -> Bool {
//        lhs.id == rhs.id && lhs.source == rhs.source
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(sourceHash)
//    }
//    
//    private var sourceHash: Int {
//        switch source {
//        case .local: return 0
//        case .backend: return 1
//        }
//    }
//}
//
//struct Chat: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var chatMessages: [ChatMessage]
//    @Query private var favoriteChats: [FavoriteChat]
//    @ObservedObject var viewModel: FavoritesViewModel
//    @StateObject private var chatViewModel = ChatViewModel()
//
//    @State private var newMessage = ""
//    @State private var selectedMessages: Set<SelectableMessage> = []
//    @State private var showFavoriteModal = false
//    @State private var favoriteName = ""
//    @State private var favoriteIcon: Image? = nil
//    @State private var selectedImageItem: PhotosPickerItem? = nil
//    @State private var selectedPredefinedIcon: String = "person"
//    @State private var forwardMessagesItem: ForwardItem? = nil
//    @State private var showSavedSuccessfullyAlert = false
//    @State private var showErrorAlert = false
//    
//    @AppStorage("appearance") private var selectedAppearance: String = "System"
//    @AppStorage("language") private var selectedLanguage: String = "System"
//
//    private var allMessages: [SelectableMessage] {
//        let backend = chatViewModel.chatHistory.map { item in
//            SelectableMessage(
//                id: "backend_\(item.id)",
//                text: item.englishText ?? item.arabicText ?? "No text",
//                isUser: false,
//                source: .backend,
//                originalLocal: nil,
//                originalBackend: item
//            )
//        }
//        let local = chatMessages.map { msg in
//            SelectableMessage(
//                id: msg.id.uuidString,
//                text: msg.text,
//                isUser: msg.isUser,
//                source: .local,
//                originalLocal: msg,
//                originalBackend: nil
//            )
//        }
//        // Sort by timestamp if needed, here just concatenate
//        return backend + local
//    }
//
//    var body: some View {
//        ZStack {
//            Color(.color1).ignoresSafeArea()
//
//            VStack {
//                HStack {
//                    Text("Conversations History".localized)
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.color)
//                        .padding(.trailing, 120)
//
//                    Button {
//                        if !selectedMessages.isEmpty {
//                            showFavoriteModal = true
//                        }
//                    } label: {
//                        Image(systemName: "plus.message.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 35, height: 35)
//                            .foregroundColor(selectedMessages.isEmpty ? .gray : .color)
//                    }
//                    .disabled(selectedMessages.isEmpty)
//                    .padding(.trailing, 5)
//                }
//
//                ScrollViewReader { scrollView in
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(allMessages) { selectable in
//                                MessageView(
//                                    message: ChatMessage(
//                                        id: UUID(uuidString: selectable.id) ?? UUID(),
//                                        text: selectable.text,
//                                        isUser: selectable.isUser
//                                    ),
//                                    isSelected: selectedMessages.contains(selectable),
//                                    onTap: {
//                                        toggleSelection(of: selectable)
//                                    }
//                                )
//                                .id(selectable.id)
//                            }
//                        }
//                        .padding()
//                    }
//                    .onChange(of: chatViewModel.chatHistory.count + chatMessages.count) { _ in
//                        withAnimation {
//                            if let lastChatMessage = chatMessages.last(where: { $0.text != "Speech recognition failed: NoMatch" }) {
//                                scrollView.scrollTo(lastChatMessage.id, anchor: .bottom)
//                            } else if let lastHistoryItem = chatViewModel.chatHistory.last(where: {
//                                !($0.englishText == "Speech recognition failed: NoMatch" || $0.arabicText == "Speech recognition failed: NoMatch")
//                            }) {
//                                scrollView.scrollTo(lastHistoryItem.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//
//                if !selectedMessages.isEmpty {
//                    Button("Messages Selected (\(selectedMessages.count))".localized) {
//                        let selected = selectedMessages.map { $0.originalLocal ?? ChatMessage(text: $0.text, isUser: $0.isUser) }
//                        forwardMessagesItem = ForwardItem(messages: selected)
//                    }
//                    .padding()
//                    .background(Color.color)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//                }
//
//                HStack {
//                    TextField("Type a message...".localized, text: $newMessage)
//                        .padding(12)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.color, lineWidth: 2))
//                        .padding(.horizontal, 10)
//
//                    Button(action: sendMessage) {
//                        Image(systemName: "paperplane.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.color)
//                            .padding(.trailing, 10)
//                    }
//                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
//                }
//                .padding()
//            }
//
//            if showFavoriteModal {
//                Color.black.opacity(0.5).ignoresSafeArea()
//                    .onTapGesture { showFavoriteModal = false }
//
//                VStack {
//                    Spacer()
//                    VStack(spacing: 16) {
//                        Text("Save as Favorite Chat".localized)
//                            .font(.headline)
//                            .foregroundColor(.color)
//                            .padding(.top, 20)
//
//                        TextField("Enter favorite chat name".localized, text: $favoriteName)
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.color, lineWidth: 1))
//
//                        HStack {
//                            ForEach(["person", "star", "heart"], id: \.self) { icon in
//                                Button {
//                                    favoriteIcon = nil
//                                    selectedPredefinedIcon = icon
//                                } label: {
//                                    Image(systemName: "\(icon).fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(selectedPredefinedIcon == icon ? .color : .gray)
//                                }
//                            }
//                        }
//
//                        PhotosPicker(selection: $selectedImageItem, matching: .images) {
//                            if let icon = favoriteIcon {
//                                icon.resizable().scaledToFit().frame(width: 50, height: 50).clipShape(.circle)
//                            } else {
//                                Text("Select an icon from Gallery".localized)
//                                    .foregroundColor(.color)
//                                    .padding()
//                                    .background(Color.color1)
//                                    .cornerRadius(10)
//                            }
//                        }
//                        .onChange(of: selectedImageItem) { newItem in
//                            Task {
//                                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                                   let uiImage = UIImage(data: data) {
//                                    favoriteIcon = Image(uiImage: uiImage)
//                                }
//                            }
//                        }
//
//                        Button("Save".localized) {
//                            showSavedSuccessfullyAlert = true
//                        }
//                        .padding()
//                        .background(favoriteName.isEmpty ? Color.gray : Color.color)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .disabled(favoriteName.isEmpty)
//
//                        Button("Cancel".localized) {
//                            favoriteName = ""
//                            selectedMessages.removeAll()
//                            showFavoriteModal = false
//                        }
//                        .padding(.bottom, 20)
//                        .foregroundColor(.red)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(20)
//                    .frame(width: 300)
//                    .transition(.scale)
//                }
//                .animation(.smooth, value: showFavoriteModal)
//            }
//        }
//        .onAppear {
//            applyTheme(selectedAppearance)
//            let language = selectedLanguage == "System" ? "english" : selectedLanguage.lowercased()
//            chatViewModel.fetchChatHistory(language: language) { _ in }
//        }
//        .sheet(item: $forwardMessagesItem) { item in
//            ForwardedMessagesView(messages: item.messages)
//        }
//        .alert("Saved Successfully".localized, isPresented: $showSavedSuccessfullyAlert) {
//            Button("Ok".localized, role: .cancel) {
//                saveFavoriteChat()
//                favoriteName = ""
//                selectedMessages.removeAll()
//            }
//        } message: {
//            Text("Your Favorite Chat Are Saved Successfully".localized)
//        }
//        .alert("Error", isPresented: $showErrorAlert) {
//            Button("Ok".localized, role: .cancel) {}
//        } message: {
//            Text(chatViewModel.errorMessage ?? "Failed to fetch response.".localized)
//        }
//    }
//
//    private func toggleSelection(of message: SelectableMessage) {
//        if selectedMessages.contains(message) {
//            selectedMessages.remove(message)
//        } else {
//            selectedMessages.insert(message)
//        }
//    }
//
//    private func sendMessage() {
//        let message = ChatMessage(text: newMessage, isUser: true)
//        modelContext.insert(message)
//        try? modelContext.save()
//        autoSaveMessage(message)
//
//        let language = selectedLanguage == "System" ? "english" : (selectedLanguage.lowercased() == "english" ? "english" : "arabic")
//        chatViewModel.fetchChatHistory(language: language) { history in
//            if let history = history {
//                if history.isEmpty {
//                    let botReply = ChatMessage(
//                        text: language == "arabic" ?
//                            "لا يوجد سجل محادثات متاح. حاول تغيير اللغة أو إرسال رسالة جديدة.".localized :
//                            "Hello My Names is Ahmed.".localized,
//                        isUser: false
//                    )
//                    modelContext.insert(botReply)
//                    try? modelContext.save()
//                    autoSaveMessage(botReply)
//                } else {
//                    let lastMessage = history.last!
//                    let botText = language == "english" ?
//                        (lastMessage.englishText ?? lastMessage.arabicText ?? "No response".localized) :
//                        (lastMessage.arabicText ?? lastMessage.englishText ?? "No response".localized)
//                    let botReply = ChatMessage(text: botText, isUser: false)
//                    modelContext.insert(botReply)
//                    try? modelContext.save()
//                    autoSaveMessage(botReply)
//                }
//            } else {
//                self.showErrorAlert = true
//            }
//        }
//
//        newMessage = ""
//    }
//
//    private func autoSaveMessage(_ message: ChatMessage) {
//        let activeFavoriteChats = favoriteChats.filter { chat in
//            viewModel.activeTracking[chat.name] == true
//        }
//
//        for chat in activeFavoriteChats {
//            chat.messages.append(message)
//            chat.lastMessage = message.text
//            chat.timestamp = getCurrentTime()
//        }
//
//        try? modelContext.save()
//
//        for (name, isTracking) in viewModel.activeTracking where isTracking {
//            if let index = viewModel.favoriteChats.firstIndex(where: { $0.name == name }) {
//                let messageModel = Message(text: message.text, isUser: message.isUser)
//                viewModel.favoriteChats[index].messages.append(messageModel)
//                viewModel.favoriteChats[index].lastMessage = message.text
//                viewModel.favoriteChats[index].timestamp = getCurrentTime()
//            }
//        }
//    }
//
//    private func saveFavoriteChat() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm:ss a"
//        let currentTime = formatter.string(from: Date())
//        guard !favoriteName.isEmpty else { return }
//        // Convert all selected messages to ChatMessage
//        let selected: [ChatMessage] = selectedMessages.map { selectable in
//            if let local = selectable.originalLocal {
//                return local
//            } else if let backend = selectable.originalBackend {
//                return ChatMessage(text: backend.englishText ?? backend.arabicText ?? "No text", isUser: false)
//            } else {
//                return ChatMessage(text: selectable.text, isUser: selectable.isUser)
//            }
//        }
//        let favoriteChat = FavoriteChat(
//            name: favoriteName,
//            lastMessage: selected.last?.text ?? "",
//            timestamp: currentTime,
//            iconName: selectedPredefinedIcon,
//            messages: selected
//        )
//        modelContext.insert(favoriteChat)
//        try? modelContext.save()
//        let newFav = FavChat(
//            name: favoriteName,
//            lastMessage: selected.last?.text ?? "",
//            timestamp: currentTime,
//            iconName: Image(systemName: "\(selectedPredefinedIcon).fill"),
//            messages: selected.map { Message(text: $0.text, isUser: $0.isUser) }
//        )
//        viewModel.favoriteChats.append(newFav)
//        showFavoriteModal = false
//        selectedMessages.removeAll()
//        favoriteName = ""
//    }
//
//    private func getCurrentTime() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm:ss a"
//        return formatter.string(from: Date())
//    }
//}
//
//struct ForwardItem: Identifiable {
//    let id = UUID()
//    let messages: [ChatMessage]
//}
//
//struct ForwardedMessagesView: View {
//    let messages: [ChatMessage]
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(messages) { message in
//                        HStack {
//                            if message.isUser {
//                                Spacer()
//                            }
//
//                            Text(message.text)
//                                .padding()
//                                .background(message.isUser ? Color.color : Color.gray.opacity(0.3))
//                                .foregroundColor(message.isUser ? .white : .black)
//                                .cornerRadius(10)
//                                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
//
//                            if !message.isUser {
//                                Spacer()
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Favorite Messages".localized)
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Favorite Messages".localized)
//                        .foregroundColor(.color)
//                        .font(.headline)
//                }
//            }
//        }
//    }
//}
//
//struct MessageView: View {
//    let message: ChatMessage
//    let isSelected: Bool
//    var onTap: () -> Void
//
//    var body: some View {
//        HStack {
//            if message.isUser { Spacer() }
//
//            Text(message.text)
//                .padding()
//                .background(isSelected ? Color.blue.opacity(0.5) :
//                                (message.isUser ? Color.color.opacity(0.8) : Color.gray.opacity(0.3)))
//                .foregroundColor(message.isUser ? .white : .black)
//                .cornerRadius(10)
//                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
//                .onTapGesture {
//                    onTap()
//                }
//
//            if !message.isUser { Spacer() }
//        }
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    Chat(viewModel: FavoritesViewModel())
//}
import SwiftUI
import PhotosUI
import SwiftData

struct SelectableMessage: Identifiable, Equatable, Hashable {
    enum SourceType { case local, backend }
    let id: String // UUID for local, Int for backend as String
    let text: String
    let isUser: Bool
    let source: SourceType
    let originalLocal: ChatMessage?
    let originalBackend: ChatHistoryModel?
    
    static func == (lhs: SelectableMessage, rhs: SelectableMessage) -> Bool {
        lhs.id == rhs.id && lhs.source == rhs.source
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(sourceHash)
    }
    
    private var sourceHash: Int {
        switch source {
        case .local: return 0
        case .backend: return 1
        }
    }
}
import SwiftUI
import PhotosUI
import SwiftData

struct Chat: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var chatMessages: [ChatMessage]
    @Query private var favoriteChats: [FavoriteChat]
    @ObservedObject var viewModel: FavoritesViewModel
    @StateObject private var chatViewModel = ChatViewModel()

    @State private var newMessage = ""
    @State private var selectedMessages: Set<SelectableMessage> = []
    @State private var showFavoriteModal = false
    @State private var favoriteName = ""
    @State private var favoriteIcon: Image? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedPredefinedIcon: String = "person"
    @State private var forwardMessagesItem: ForwardItem? = nil
    @State private var showSavedSuccessfullyAlert = false
    @State private var showErrorAlert = false
    
    @AppStorage("appearance") private var selectedAppearance: String = "System"
    @AppStorage("language") private var selectedLanguage: String = "System"
    @AppStorage("isTranslationOn") private var isTranslationOn: Bool = false
    @AppStorage("transLanguage") private var transLanguage: String = "Arabic"

    private var allMessages: [SelectableMessage] {
        let backend = chatViewModel.chatHistory.map { item in
            let displayText = isTranslationOn && transLanguage == "Arabic"
                ? (item.arabicText ?? item.englishText ?? "No text")
                : (item.englishText ?? item.arabicText ?? "No text")
            return SelectableMessage(
                id: "backend_\(item.id)",
                text: displayText,
                isUser: false,
                source: .backend,
                originalLocal: nil,
                originalBackend: item
            )
        }
        let local = chatMessages.map { msg in
            SelectableMessage(
                id: msg.id.uuidString,
                text: msg.text,
                isUser: msg.isUser,
                source: .local,
                originalLocal: msg,
                originalBackend: nil
            )
        }
        return backend + local
    }

    var body: some View {
        ZStack {
            Color(.color1).ignoresSafeArea()

            VStack {
                HStack {
                    Text("Conversations History".localized)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.color)
                        .padding(.trailing, 120)

                    Button {
                        if !selectedMessages.isEmpty {
                            showFavoriteModal = true
                        }
                    } label: {
                        Image(systemName: "plus.message.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(selectedMessages.isEmpty ? .gray : .color)
                    }
                    .disabled(selectedMessages.isEmpty)
                    .padding(.trailing, 5)
                }

                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(allMessages) { selectable in
                                MessageView(
                                    message: ChatMessage(
                                        id: UUID(uuidString: selectable.id) ?? UUID(),
                                        text: selectable.text,
                                        isUser: selectable.isUser
                                    ),
                                    isSelected: selectedMessages.contains(selectable),
                                    onTap: {
                                        toggleSelection(of: selectable)
                                    }
                                )
                                .id(selectable.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatViewModel.chatHistory.count + chatMessages.count) { _ in
                        withAnimation {
                            if let lastChatMessage = chatMessages.last(where: { $0.text != "Speech recognition failed: NoMatch" }) {
                                scrollView.scrollTo(lastChatMessage.id, anchor: .bottom)
                            } else if let lastHistoryItem = chatViewModel.chatHistory.last(where: {
                                !($0.englishText == "Speech recognition failed: NoMatch" || $0.arabicText == "Speech recognition failed: NoMatch")
                            }) {
                                scrollView.scrollTo(lastHistoryItem.id, anchor: .bottom)
                            }
                        }
                    }
                }

                if !selectedMessages.isEmpty {
                    Button("Messages Selected (\(selectedMessages.count))".localized) {
                        let selected = selectedMessages.map { $0.originalLocal ?? ChatMessage(text: $0.text, isUser: $0.isUser) }
                        forwardMessagesItem = ForwardItem(messages: selected)
                    }
                    .padding()
                    .background(Color.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                }

                HStack {
                    TextField("Type a message...".localized, text: $newMessage)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.color, lineWidth: 2))
                        .padding(.horizontal, 10)

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.color)
                            .padding(.trailing, 10)
                    }
                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }

            if showFavoriteModal {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { showFavoriteModal = false }

                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        Text("Save as Favorite Chat".localized)
                            .font(.headline)
                            .foregroundColor(.color)
                            .padding(.top, 20)

                        TextField("Enter favorite chat name".localized, text: $favoriteName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.color, lineWidth: 1))

                        HStack {
                            ForEach(["person", "star", "heart"], id: \.self) { icon in
                                Button {
                                    favoriteIcon = nil
                                    selectedPredefinedIcon = icon
                                } label: {
                                    Image(systemName: "\(icon).fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(selectedPredefinedIcon == icon ? .color : .gray)
                                }
                            }
                        }

                        PhotosPicker(selection: $selectedImageItem, matching: .images) {
                            if let icon = favoriteIcon {
                                icon.resizable().scaledToFit().frame(width: 50, height: 50).clipShape(.circle)
                            } else {
                                Text("Select an icon from Gallery".localized)
                                    .foregroundColor(.color)
                                    .padding()
                                    .background(Color.color1)
                                    .cornerRadius(10)
                            }
                        }
                        .onChange(of: selectedImageItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    favoriteIcon = Image(uiImage: uiImage)
                                }
                            }
                        }

                        Button("Save".localized) {
                            showSavedSuccessfullyAlert = true
                        }
                        .padding()
                        .background(favoriteName.isEmpty ? Color.gray : Color.color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(favoriteName.isEmpty)

                        Button("Cancel".localized) {
                            favoriteName = ""
                            selectedMessages.removeAll()
                            showFavoriteModal = false
                        }
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .frame(width: 300)
                    .transition(.scale)
                }
                .animation(.smooth, value: showFavoriteModal)
            }
        }
        .onAppear {
            applyTheme(selectedAppearance)
            let language = isTranslationOn ? transLanguage.lowercased() : (selectedLanguage == "System" ? "english" : selectedLanguage.lowercased()) 
            chatViewModel.fetchChatHistory(language: language) { _ in }
        }
        .sheet(item: $forwardMessagesItem) { item in
            ForwardedMessagesView(messages: item.messages)
        }
        .alert("Saved Successfully".localized, isPresented: $showSavedSuccessfullyAlert) {
            Button("Ok".localized, role: .cancel) {
                saveFavoriteChat()
                favoriteName = ""
                selectedMessages.removeAll()
            }
        } message: {
            Text("Your Favorite Chat Are Saved Successfully".localized)
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("Ok".localized, role: .cancel) {}
        } message: {
            Text(chatViewModel.errorMessage ?? "Failed to fetch response.".localized)
        }
    }

    private func toggleSelection(of message: SelectableMessage) {
        if selectedMessages.contains(message) {
            selectedMessages.remove(message)
        } else {
            selectedMessages.insert(message)
        }
    }

    private func sendMessage() {
        let message = ChatMessage(text: newMessage, isUser: true)
        modelContext.insert(message)
        try? modelContext.save()
        autoSaveMessage(message)

        let language = isTranslationOn ? transLanguage.lowercased() : (selectedLanguage == "System" ? "english" : (selectedLanguage.lowercased() == "english" ? "english" : "arabic"))
        chatViewModel.fetchChatHistory(language: language) { history in
            if let history = history {
                if history.isEmpty {
                    let botReply = ChatMessage(
                        text: language == "arabic" ?
                            "لا يوجد سجل محادثات متاح. حاول تغيير اللغة أو إرسال رسالة جديدة.".localized :
                            "Hello My Names is Ahmed.".localized,
                        isUser: false
                    )
                    modelContext.insert(botReply)
                    try? modelContext.save()
                    autoSaveMessage(botReply)
                } else {
                    let lastMessage = history.last!
                    let botText = isTranslationOn && transLanguage.lowercased() == "arabic" ?
                        (lastMessage.arabicText ?? lastMessage.englishText ?? "No response".localized) :
                        (lastMessage.englishText ?? lastMessage.arabicText ?? "No response".localized)
                    let botReply = ChatMessage(text: botText, isUser: false)
                    modelContext.insert(botReply)
                    try? modelContext.save()
                    autoSaveMessage(botReply)
                }
            } else {
                self.showErrorAlert = true
            }
        }

        newMessage = ""
    }

    private func autoSaveMessage(_ message: ChatMessage) {
        let activeFavoriteChats = favoriteChats.filter { chat in
            viewModel.activeTracking[chat.name] == true
        }

        for chat in activeFavoriteChats {
            chat.messages.append(message)
            chat.lastMessage = message.text
            chat.timestamp = getCurrentTime()
        }

        try? modelContext.save()

        for (name, isTracking) in viewModel.activeTracking where isTracking {
            if let index = viewModel.favoriteChats.firstIndex(where: { $0.name == name }) {
                let messageModel = Message(text: message.text, isUser: message.isUser)
                viewModel.favoriteChats[index].messages.append(messageModel)
                viewModel.favoriteChats[index].lastMessage = message.text
                viewModel.favoriteChats[index].timestamp = getCurrentTime()
            }
        }
    }

    private func saveFavoriteChat() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        let currentTime = formatter.string(from: Date())
        guard !favoriteName.isEmpty else { return }
        let selected: [ChatMessage] = selectedMessages.map { selectable in
            if let local = selectable.originalLocal {
                return local
            } else if let backend = selectable.originalBackend {
                let text = isTranslationOn && transLanguage == "Arabic"
                    ? (backend.arabicText ?? backend.englishText ?? "No text")
                    : (backend.englishText ?? backend.arabicText ?? "No text")
                return ChatMessage(text: text, isUser: false)
            } else {
                return ChatMessage(text: selectable.text, isUser: selectable.isUser)
            }
        }
        let favoriteChat = FavoriteChat(
            name: favoriteName,
            lastMessage: selected.last?.text ?? "",
            timestamp: currentTime,
            iconName: selectedPredefinedIcon,
            messages: selected
        )
        modelContext.insert(favoriteChat)
        try? modelContext.save()
        let newFav = FavChat(
            name: favoriteName,
            lastMessage: selected.last?.text ?? "",
            timestamp: currentTime,
            iconName: Image(systemName: "\(selectedPredefinedIcon).fill"),
            messages: selected.map { Message(text: $0.text, isUser: $0.isUser) }
        )
        viewModel.favoriteChats.append(newFav)
        showFavoriteModal = false
        selectedMessages.removeAll()
        favoriteName = ""
    }

    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter.string(from: Date())
    }
}
//struct Chat: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var chatMessages: [ChatMessage]
//    @Query private var favoriteChats: [FavoriteChat]
//    @ObservedObject var viewModel: FavoritesViewModel
//    @StateObject private var chatViewModel = ChatViewModel()
//
//    @State private var newMessage = ""
//    @State private var selectedMessages: Set<SelectableMessage> = []
//    @State private var showFavoriteModal = false
//    @State private var favoriteName = ""
//    @State private var favoriteIcon: Image? = nil
//    @State private var selectedImageItem: PhotosPickerItem? = nil
//    @State private var selectedPredefinedIcon: String = "person"
//    @State private var forwardMessagesItem: ForwardItem? = nil
//    @State private var showSavedSuccessfullyAlert = false
//    @State private var showErrorAlert = false
//
//    @AppStorage("appearance") private var selectedAppearance: String = "System"
//    @AppStorage("language") private var selectedLanguage: String = "System"
//
//    private var allMessages: [SelectableMessage] {
//        let backend = chatViewModel.chatHistory.map { item in
//            SelectableMessage(
//                id: "backend_\(item.id)",
//                text: item.englishText ?? item.arabicText ?? "No text",
//                isUser: false,
//                source: .backend,
//                originalLocal: nil,
//                originalBackend: item
//            )
//        }
//        let local = chatMessages.map { msg in
//            SelectableMessage(
//                id: msg.id.uuidString,
//                text: msg.text,
//                isUser: msg.isUser,
//                source: .local,
//                originalLocal: msg,
//                originalBackend: nil
//            )
//        }
//        // Sort by timestamp if needed, here just concatenate
//        return backend + local
//    }
//
//    var body: some View {
//        ZStack {
//            Color(.color1).ignoresSafeArea()
//
//            VStack {
//                HStack {
//                    Text("Conversations History".localized)
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(.color)
//                        .padding(.trailing, 120)
//
//                    Button {
//                        if !selectedMessages.isEmpty {
//                            showFavoriteModal = true
//                        }
//                    } label: {
//                        Image(systemName: "plus.message.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 35, height: 35)
//                            .foregroundColor(selectedMessages.isEmpty ? .gray : .color)
//                    }
//                    .disabled(selectedMessages.isEmpty)
//                    .padding(.trailing, 5)
//                }
//
//                ScrollViewReader { scrollView in
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(allMessages) { selectable in
//                                MessageView(
//                                    message: ChatMessage(
//                                        id: UUID(uuidString: selectable.id) ?? UUID(),
//                                        text: selectable.text,
//                                        isUser: selectable.isUser
//                                    ),
//                                    isSelected: selectedMessages.contains(selectable),
//                                    onTap: {
//                                        toggleSelection(of: selectable)
//                                    }
//                                )
//                                .id(selectable.id)
//                            }
//                        }
//                        .padding()
//                    }
//                    .onChange(of: chatViewModel.chatHistory.count + chatMessages.count) { _ in
//                        withAnimation {
//                            if let lastChatMessage = chatMessages.last(where: { $0.text != "Speech recognition failed: NoMatch" }) {
//                                scrollView.scrollTo(lastChatMessage.id, anchor: .bottom)
//                            } else if let lastHistoryItem = chatViewModel.chatHistory.last(where: {
//                                !($0.englishText == "Speech recognition failed: NoMatch" || $0.arabicText == "Speech recognition failed: NoMatch")
//                            }) {
//                                scrollView.scrollTo(lastHistoryItem.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//
//                if !selectedMessages.isEmpty {
//                    Button("Messages Selected (\(selectedMessages.count))".localized) {
//                        let selected = selectedMessages.map { $0.originalLocal ?? ChatMessage(text: $0.text, isUser: $0.isUser) }
//                        forwardMessagesItem = ForwardItem(messages: selected)
//                    }
//                    .padding()
//                    .background(Color.color)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.bottom, 10)
//                }
//
//                HStack {
//                    TextField("Type a message...".localized, text: $newMessage)
//                        .padding(12)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.color, lineWidth: 2))
//                        .padding(.horizontal, 10)
//
//                    Button(action: sendMessage) {
//                        Image(systemName: "paperplane.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.color)
//                            .padding(.trailing, 10)
//                    }
//                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
//                }
//                .padding()
//            }
//
//            if showFavoriteModal {
//                Color.black.opacity(0.5).ignoresSafeArea()
//                    .onTapGesture { showFavoriteModal = false }
//
//                VStack {
//                    Spacer()
//                    VStack(spacing: 16) {
//                        Text("Save as Favorite Chat".localized)
//                            .font(.headline)
//                            .foregroundColor(.color)
//                            .padding(.top, 20)
//
//                        TextField("Enter favorite chat name".localized, text: $favoriteName)
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.color, lineWidth: 1))
//
//                        HStack {
//                            ForEach(["person", "star", "heart"], id: \.self) { icon in
//                                Button {
//                                    favoriteIcon = nil
//                                    selectedPredefinedIcon = icon
//                                } label: {
//                                    Image(systemName: "\(icon).fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(selectedPredefinedIcon == icon ? .color : .gray)
//                                }
//                            }
//                        }
//
//                        PhotosPicker(selection: $selectedImageItem, matching: .images) {
//                            if let icon = favoriteIcon {
//                                icon.resizable().scaledToFit().frame(width: 50, height: 50).clipShape(.circle)
//                            } else {
//                                Text("Select an icon from Gallery".localized)
//                                    .foregroundColor(.color)
//                                    .padding()
//                                    .background(Color.color1)
//                                    .cornerRadius(10)
//                            }
//                        }
//                        .onChange(of: selectedImageItem) { newItem in
//                            Task {
//                                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                                   let uiImage = UIImage(data: data) {
//                                    favoriteIcon = Image(uiImage: uiImage)
//                                }
//                            }
//                        }
//
//                        Button("Save".localized) {
//                            showSavedSuccessfullyAlert = true
//                        }
//                        .padding()
//                        .background(favoriteName.isEmpty ? Color.gray : Color.color)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .disabled(favoriteName.isEmpty)
//
//                        Button("Cancel".localized) {
//                            favoriteName = ""
//                            selectedMessages.removeAll()
//                            showFavoriteModal = false
//                        }
//                        .padding(.bottom, 20)
//                        .foregroundColor(.red)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(20)
//                    .frame(width: 300)
//                    .transition(.scale)
//                }
//                .animation(.smooth, value: showFavoriteModal)
//            }
//        }
//        .onAppear {
//            applyTheme(selectedAppearance)
//            let language = selectedLanguage == "System" ? "english" : selectedLanguage.lowercased()
//            chatViewModel.fetchChatHistory(language: language) { _ in }
//        }
//        .sheet(item: $forwardMessagesItem) { item in
//            ForwardedMessagesView(messages: item.messages)
//        }
//        .alert("Saved Successfully".localized, isPresented: $showSavedSuccessfullyAlert) {
//            Button("Ok".localized, role: .cancel) {
//                saveFavoriteChat()
//                favoriteName = ""
//                selectedMessages.removeAll()
//            }
//        } message: {
//            Text("Your Favorite Chat Are Saved Successfully".localized)
//        }
//        .alert("Error", isPresented: $showErrorAlert) {
//            Button("Ok".localized, role: .cancel) {}
//        } message: {
//            Text(chatViewModel.errorMessage ?? "Failed to fetch response.".localized)
//        }
//    }
//
//    private func toggleSelection(of message: SelectableMessage) {
//        if selectedMessages.contains(message) {
//            selectedMessages.remove(message)
//        } else {
//            selectedMessages.insert(message)
//        }
//    }
//
//    private func sendMessage() {
//        let message = ChatMessage(text: newMessage, isUser: true)
//        modelContext.insert(message)
//        try? modelContext.save()
//        autoSaveMessage(message)
//
//        let language = selectedLanguage == "System" ? "english" : (selectedLanguage.lowercased() == "english" ? "english" : "arabic")
//        chatViewModel.fetchChatHistory(language: language) { history in
//            if let history = history {
//                if history.isEmpty {
//                    let botReply = ChatMessage(
//                        text: language == "arabic" ?
//                            "لا يوجد سجل محادثات متاح. حاول تغيير اللغة أو إرسال رسالة جديدة.".localized :
//                            "Hello My Names is Ahmed.".localized,
//                        isUser: false
//                    )
//                    modelContext.insert(botReply)
//                    try? modelContext.save()
//                    autoSaveMessage(botReply)
//                } else {
//                    let lastMessage = history.last!
//                    let botText = language == "english" ?
//                        (lastMessage.englishText ?? lastMessage.arabicText ?? "No response".localized) :
//                        (lastMessage.arabicText ?? lastMessage.englishText ?? "No response".localized)
//                    let botReply = ChatMessage(text: botText, isUser: false)
//                    modelContext.insert(botReply)
//                    try? modelContext.save()
//                    autoSaveMessage(botReply)
//                }
//            } else {
//                self.showErrorAlert = true
//            }
//        }
//
//        newMessage = ""
//    }
//
//    private func autoSaveMessage(_ message: ChatMessage) {
//        let activeFavoriteChats = favoriteChats.filter { chat in
//            viewModel.activeTracking[chat.name] == true
//        }
//
//        for chat in activeFavoriteChats {
//            chat.messages.append(message)
//            chat.lastMessage = message.text
//            chat.timestamp = getCurrentTime()
//        }
//
//        try? modelContext.save()
//
//        for (name, isTracking) in viewModel.activeTracking where isTracking {
//            if let index = viewModel.favoriteChats.firstIndex(where: { $0.name == name }) {
//                let messageModel = Message(text: message.text, isUser: message.isUser)
//                viewModel.favoriteChats[index].messages.append(messageModel)
//                viewModel.favoriteChats[index].lastMessage = message.text
//                viewModel.favoriteChats[index].timestamp = getCurrentTime()
//            }
//        }
//    }
//
//    private func saveFavoriteChat() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm:ss a"
//        let currentTime = formatter.string(from: Date())
//        guard !favoriteName.isEmpty else { return }
//        // Convert all selected messages to ChatMessage
//        let selected: [ChatMessage] = selectedMessages.map { selectable in
//            if let local = selectable.originalLocal {
//                return local
//            } else if let backend = selectable.originalBackend {
//                return ChatMessage(text: backend.englishText ?? backend.arabicText ?? "No text", isUser: false)
//            } else {
//                return ChatMessage(text: selectable.text, isUser: selectable.isUser)
//            }
//        }
//        let favoriteChat = FavoriteChat(
//            name: favoriteName,
//            lastMessage: selected.last?.text ?? "",
//            timestamp: currentTime,
//            iconName: selectedPredefinedIcon,
//            messages: selected
//        )
//        modelContext.insert(favoriteChat)
//        try? modelContext.save()
//        let newFav = FavChat(
//            name: favoriteName,
//            lastMessage: selected.last?.text ?? "",
//            timestamp: currentTime,
//            iconName: Image(systemName: "\(selectedPredefinedIcon).fill"),
//            messages: selected.map { Message(text: $0.text, isUser: $0.isUser) }
//        )
//        viewModel.favoriteChats.append(newFav)
//        showFavoriteModal = false
//        selectedMessages.removeAll()
//        favoriteName = ""
//    }
//
//    private func getCurrentTime() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm:ss a"
//        return formatter.string(from: Date())
//    }
//}

struct ForwardItem: Identifiable {
    let id = UUID()
    let messages: [ChatMessage]
}

struct ForwardedMessagesView: View {
    let messages: [ChatMessage]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                            }

                            Text(message.text)
                                .padding()
                                .background(message.isUser ? Color.color : Color.gray.opacity(0.3))
                                .foregroundColor(message.isUser ? .white : .black)
                                .cornerRadius(10)
                                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)

                            if !message.isUser {
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Favorite Messages".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorite Messages".localized)
                        .foregroundColor(.color)
                        .font(.headline)
                }
            }
        }
    }
}

struct MessageView: View {
    let message: ChatMessage
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            Text(message.text)
                .padding()
                .background(isSelected ? Color.blue.opacity(0.5) :
                                (message.isUser ? Color.color.opacity(0.8) : Color.gray.opacity(0.3)))
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(10)
                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
                .onTapGesture {
                    onTap()
                }

            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    Chat(viewModel: FavoritesViewModel())
}
