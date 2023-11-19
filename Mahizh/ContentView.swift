//
//  ContentView.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 18/11/23.
//

import SwiftUI

import SwiftUI
import Combine

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var message: String = ""
    var isLoading: Bool = false
    
    @State var lastMessageID: String = ""
    
    ///- Dark mode/Light mode variable
    @Environment(\.colorScheme) var colorScheme
    
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            HStack {
                Text("mahizh!")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            ChatView(message: message)
                        }
                    }
                }
                .onChange(of: self.lastMessageID) { id in
                    withAnimation{
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $message) {}
                    .padding()
                    .background(colorScheme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.1))
                    .cornerRadius(10)
                Button{
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.black)
                        .padding(.horizontal, 1)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        
                }
            }
        }
        .padding()
    }
        
    func sendMessage (){
        guard message != "" else {return}
        
        let myMessage = ChatMessage(id: UUID().uuidString, content: message, createdAt: Date(), sender: .me)
        chatMessages.append(myMessage)
        lastMessageID = myMessage.id
        
//        openAIService.sendMessage(message: message).sink { completion in
//            /// - Handle Error here
//        } receiveValue: { response in
//            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
//            let chatGPTMessage = ChatMessage(id: response.id, content: textResponse, createdAt: Date(), sender: .chatGPT)
//            
//            chatMessages.append(chatGPTMessage)
//            lastMessageID = chatGPTMessage.id
//        }
//        .store(in: &cancellables)
            
        message = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
