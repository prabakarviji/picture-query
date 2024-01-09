//  ContentView.swift
//  Mahizh
//  Created by Prabakaran Marimuthu on 18/11/23.

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
	@State var selectedPhoto: PhotosPickerItem?
	@Environment(\.colorScheme) var colorScheme
	@State private var selectedImage: Data? = nil

	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "lasso.badge.sparkles")
					.font(.largeTitle)
				Text("PicQuery")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				PhotosPicker(selection: $selectedPhoto) {
					Image(systemName: "photo.badge.plus")
						.font(.title)
						.foregroundColor(.blue)
				}
			}.task(id:selectedPhoto) {
				selectedImage = try? await selectedPhoto?.loadTransferable(type: Data.self)
			}

			Spacer().frame(height: 5)
			HStack {
				TextField("Message", text: $message) {}
					.padding()
					.background(colorScheme == .dark ? .gray.opacity(0.2) : .gray.opacity(0.1))
					.cornerRadius(10)
				Button{
					TextRecog().recognizeText(image: selectedImage!)
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

}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
