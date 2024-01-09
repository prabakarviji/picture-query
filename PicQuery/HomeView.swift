//  ContentView.swift
//  Mahizh
//  Created by Prabakaran Marimuthu on 18/11/23.

import SwiftUI

import SwiftUI
import Combine
import PhotosUI
import VisionKit



struct HomeView: View {
	@State var chatMessages: [ChatMessage] = []
	@State private var model = HomeViewModel()
	@State var message: String = ""
	var isLoading: Bool = false
	var options: [String] = ["Upload a picture"]
	@State var selectedItems: [PhotosPickerItem] = []

	
	@State var lastMessageID: String = ""
	
	///- Dark mode/Light mode variable
	@Environment(\.colorScheme) var colorScheme
	
	@State var cancellables = Set<AnyCancellable>()
	
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "lasso.badge.sparkles")
					.font(.largeTitle)
				Text("PicQuery")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				PhotosPicker(selection: $selectedItems,
										 matching: .images) {
					Image(systemName: "photo.badge.plus")
						.font(.title)
						.foregroundColor(.blue)
				}
//				Image(systemName: "photo.badge.plus")
//					.font(.title)
//					.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/){
//						PhotosPicker(selection: $selectedItems,
//												 matching: .images) {
//							Text("Select Multiple Photos")
//						}
//					}
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
	

			Spacer().frame(height: 5)
			HStack {
				TextField("Message", text: $message) {}
					.padding()
					.background(colorScheme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.1))
					.cornerRadius(10)
				Button{
					//print(self.$selectedItems)
					//self.model.submitQuestion()
					TextRecog().recognizeText()
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
	
	func setMessage(selectedOption:String){
		message = selectedOption
		sendMessage()
	}
	
	func sendMessage (){
		guard message != "" else {return}
		let myMessage = ChatMessage(id: UUID().uuidString, content: message, createdAt: Date(), sender: .me)
		chatMessages.append(myMessage)
		lastMessageID = myMessage.id
		populateReplyMessage()
		message = ""
	}

	func populateReplyMessage(){
		let myMessage = ChatMessage(id: UUID().uuidString, content: "Copy! What is the message?", createdAt: Date(), sender: .chatGPT)
		chatMessages.append(myMessage)
	}

}


struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
