//
//  ChatDetailView.swift
//  GraduationProject
//
//  Created by Khalid Gad on 07/04/2025.
//

import SwiftUI

struct ChatDetailView: View {
    var favChat: FavChat // Passing the selected favorite chat
    
    var body: some View {
        
        ZStack {
            Color(.color1).ignoresSafeArea()
            
            VStack {
                // Header with chat name and icon
                HStack(spacing: 16) {
                    favChat.iconName
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.color)
                        .background(Circle().fill(Color.color.opacity(0.1)))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(favChat.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(favChat.timestamp)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Scrollable list of messages
                ScrollView {
                    ForEach(favChat.messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                            }
                            Text(message.text)
                                .padding()
                                .background(message.isUser ? Color.color : Color.gray.opacity(0.3))
                                .foregroundColor(message.isUser ? .white : .black)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
                            if !message.isUser {
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            .navigationBarTitle(favChat.name, displayMode: .inline) // Set the title of the screen to the chat name
           // .navigationBarTitleDisplayMode(<#T##displayMode: NavigationBarItem.TitleDisplayMode##NavigationBarItem.TitleDisplayMode#>)
          //  .background(Color(.color1).ignoresSafeArea()) // Set the background color
        }
    }
}

#Preview {
    ChatDetailView(favChat: FavChat(
        id: UUID(),
        name: "John Doe",
        lastMessage: "Hey, how are you?",
        timestamp: "10:45 AM",
        iconName: Image(systemName: "person.fill"),
        messages: [
            Message(text: "Hey there!", isUser: true),
            Message(text: "Hello! How are you?", isUser: false),
            Message(text: "I'm doing well, thanks for asking!", isUser: true)
        ]
    ))
}

