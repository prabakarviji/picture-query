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
                        .cornerRadius(24)
                    if message.sender == .chatGPT{Spacer()}
            }
        }
           
}
