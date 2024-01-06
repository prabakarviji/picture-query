//
//  ChatMessage.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 19/11/23.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let createdAt: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case chatGPT
}



extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample message from me", createdAt: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample message from chatGPT", createdAt: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message from me", createdAt: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample message from chatGPT", createdAt: Date(), sender: .chatGPT),
        ChatMessage(id: UUID().uuidString, content: "Sample message from me", createdAt: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample message from chatGPT", createdAt: Date(), sender: .chatGPT),
    ]
}
