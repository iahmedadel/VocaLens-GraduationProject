import SwiftUI
import _PhotosUI_SwiftUI
import SwiftData

struct Favorites: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteChats: [FavoriteChat]
    @ObservedObject var viewModel: FavoritesViewModel
    
    @AppStorage("appearance") private var selectedAppearance: String = "System"
    @AppStorage("language") private var selectedLanguage: String = "System"
    
    @State private var showCreateFavoriteModal = false
    @State private var favoriteName = ""
    @State private var selectedPredefinedIcon: String = "person"
    @State private var favoriteIcon: Image? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showSavedSuccessfullyAlert = false
    @State private var searchText = ""
    @AppStorage("paging") var paging: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.color1).ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Favorite Chats")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.color)
                            .padding(.trailing, 80)
                        
                        Button {
                            showCreateFavoriteModal = true
                        } label: {
                            Image(systemName: "plus.message.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.color)
                        }
                        .padding(.trailing, 5)
                    }
                    .padding(.top, 20)
                    
                    // Search Bar
                    TextField("Search", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.color, lineWidth: 1))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Filtered list based on searchText
                    List {
                        ForEach(favoriteChats.filter { chat in
                            searchText.isEmpty || chat.name.lowercased().contains(searchText.lowercased())
                        }) { chat in
                            NavigationLink(destination: ChatDetailView(favChat: convertToFavChat(chat))) {
                                VStack {
                                    HStack(spacing: 8) {
                                        Image(systemName: chat.iconName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.color)
                                            .background(Circle().fill(Color.color.opacity(0.1)))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(chat.name)
                                                .font(.headline)
                                                .foregroundColor(.color)
                                                .padding(.top, 8)
        
                                            Text(chat.lastMessage)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(chat.timestamp)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            
                                            Text("\(chat.messages.count) messages")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                    
                                    // Toggle Section below icon
                                    HStack {
                                        Spacer()
                                        Toggle(isOn: Binding(
                                            get: { viewModel.activeTracking[chat.name] ?? false },
                                            set: { newValue in viewModel.activeTracking[chat.name] = newValue }
                                        )) {
                                            Text("Auto Save Messages")
                                                .font(.subheadline)
                                                .foregroundColor(.color)
                                        }
                                        .toggleStyle(SwitchToggleStyle(tint: .color))
                                        .padding()
                                    }
                                    .background(Color(.white))
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                .padding(.top, 5)
                            }
                            .listRowBackground(Color(.color).opacity(0.3))
                        }
                        .onDelete { indexSet in
                            deleteFavoriteChats(at: indexSet)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                
                // Modal at the bottom of the screen
                if showCreateFavoriteModal {
                    Color.black.opacity(0.5).ignoresSafeArea()
                        .onTapGesture {
                            showCreateFavoriteModal = false
                        }
                    
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Text("Create a Favorite Chat")
                                .font(.headline)
                                .foregroundColor(.color)
                                .padding(.top, 20)
                            
                            TextField("Enter favorite chat name", text: $favoriteName)
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
                                    icon.resizable().scaledToFit().frame(width: 50, height: 50).clipShape(Circle())
                                } else {
                                    Text("Select an icon from Gallery")
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
                            
                            Button("Create") {
                                createFavoriteChat()
                            }
                            .padding()
                            .background(favoriteName.isEmpty ? Color.gray : Color.color)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .disabled(favoriteName.isEmpty)
                            
                            Button("Cancel") {
                                favoriteName = ""
                                showCreateFavoriteModal = false
                            }
                            .padding(.bottom, 20)
                            .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .frame(width: 300)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showCreateFavoriteModal)
                    }
                }
            }
        }
        .onAppear {
            applyTheme(selectedAppearance)
            syncFavoriteChats()
        }
    }
    
    private func createFavoriteChat() {
        let currentTime = getCurrentTime()
        
        // Create SwiftData FavoriteChat
        let favoriteChat = FavoriteChat(
            name: favoriteName,
            lastMessage: "",
            timestamp: currentTime,
            iconName: selectedPredefinedIcon,
            messages: []
        )
        
        modelContext.insert(favoriteChat)
        try? modelContext.save()
        
        // Update FavoritesViewModel
        let newFav = FavChat(
            name: favoriteName,
            lastMessage: "",
            timestamp: currentTime,
            iconName: Image(systemName: "\(selectedPredefinedIcon).fill"),
            messages: []
        )
        viewModel.favoriteChats.append(newFav)
        
        showCreateFavoriteModal = false
        favoriteName = ""
    }
    
    private func deleteFavoriteChats(at offsets: IndexSet) {
        offsets.forEach { index in
            let chatToDelete = favoriteChats[index]
            modelContext.delete(chatToDelete)
            try? modelContext.save()
            
            // Also remove from viewModel
            viewModel.favoriteChats.removeAll { $0.name == chatToDelete.name }
        }
    }
    
    private func syncFavoriteChats() {
        // Sync SwiftData chats with viewModel
        for chat in favoriteChats {
            if !viewModel.favoriteChats.contains(where: { $0.name == chat.name }) {
                let favChat = FavChat(
                    name: chat.name,
                    lastMessage: chat.lastMessage,
                    timestamp: chat.timestamp,
                    iconName: Image(systemName: chat.iconName),
                    messages: chat.messages.map { Message(text: $0.text, isUser: $0.isUser) }
                )
                viewModel.favoriteChats.append(favChat)
            }
        }
    }
    
    private func convertToFavChat(_ chat: FavoriteChat) -> FavChat {
        FavChat(
            name: chat.name,
            lastMessage: chat.lastMessage,
            timestamp: chat.timestamp,
            iconName: Image(systemName: chat.iconName),
            messages: chat.messages.map { Message(text: $0.text, isUser: $0.isUser) }
        )
    }
}

private func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: Date())
}

#Preview {
    Favorites(viewModel: FavoritesViewModel())
}
