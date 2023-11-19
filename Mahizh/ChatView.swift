//
//  ChatView.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 19/11/23.
//

import SwiftUI

struct ChatView: View {
    var message: ChatMessage
    var body: some View {
            HStack{
                    if message.sender == .me{Spacer()}
                    Text(message.content)
                        .foregroundColor(message.sender == .me ? .white : nil)
                        .padding()
                        .background(message.sender == .me ? .black : .gray.opacity(0.4))
                        .cornerRadius(15)
                    if message.sender == .chatGPT{Spacer()}
            }
        }
           
}

struct ChatViewPreview:PreviewProvider{
    
    static var previews: some View{
        let myMessage = ChatMessage(id: UUID().uuidString, content: "Create a reminder", createdAt: Date(), sender: .me)
        ChatView(message: myMessage)
    }
}
