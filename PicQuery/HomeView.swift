//  ContentView.swift
//  Mahizh
//  Created by Prabakaran Marimuthu on 18/11/23.

import SwiftUI
import Combine
import PhotosUI
import VisionKit

struct AlertMessage: Identifiable {
	var id: String {title}
	var title: String
	let message: String
}

struct HomeView: View {
	
	var mlModel = MLQAModel()
	@State var question: String = ""
	@State var isLoading: Bool = false
	@State var selectedPhoto: PhotosPickerItem?
	@Environment(\.colorScheme) var colorScheme
	@State private var selectedImage: Data? = nil
	@ObservedObject var recognizedContent = RecognizedContent()
	@State private var showOption = true
	@State var questionText = ""
	@State var answerText = ""
	@State var showAlert:AlertMessage?
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "bolt.fill")
					.font(.title2)
				Text("PicQuery")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				if(self.showOption == false){
					Button{
						self.showOption = true
					} label:{
						Text("Clear").foregroundStyle(.blue)
					}
				}
			}
			Spacer()
			if(isLoading == true){
				ProgressView("Extracting text content from image..")
			}
			else{
				if(self.showOption == true){
					PhotosPicker(selection: $selectedPhoto) {
						VStack{
							Image(systemName: "text.below.photo")
								.font(.custom("String", fixedSize: 150))
								.foregroundColor(.gray)
								.opacity(0.5)
							Text("Upload your image here!")
								.font(.title3)
								.foregroundStyle(.gray)
								.padding(.top,5)
						}
					}
					.onChange(of: selectedPhoto) {
						isLoading = true
						guard let resultImage = selectedPhoto else {
							return
						}
						resultImage.loadTransferable(type: Data.self) { result in
							switch result {
								case .success(let data):
									if let data = data {
										TextRecog(image: data,recognizedContent: recognizedContent) {
											isLoading = false
											self.showOption = false
										}.recognizeText()
										
									} else {
										print("Found nil in data")
									}
								case .failure(let error):
									print(error.localizedDescription)
							}
						}
					}
				}
				else{
					VStack(alignment: .leading){
						Text("Extracted Content")
							.font(.title2)
							.bold()
							.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
						ScrollView{
								Text(recognizedContent.result.text).font(.callout)
						}
						Divider().frame(height: 2).background(Color.gray)
						Spacer()
						if(questionText.isEmpty == false){
							VStack(alignment: .leading){
								if(questionText.isEmpty == false) {
									Text("Q: \(questionText)").font(.callout).bold().padding(.top,1)
								}
								if(answerText.isEmpty == false){
									Text("A: \(answerText)").font(.callout)
								}
							}
						}
					}
				}
			}
			Spacer()
			HStack {
				TextField("Type your question here", text: $question) {}
					.padding()
					.background(colorScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.3))
					.cornerRadius(10)
				Button{
					handleSubmit(question:question)
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
		.alert(item: $showAlert) { show in
			Alert(title: Text(show.title), message: Text(show.message), dismissButton: .cancel())
		}
	}
	
	func handleSubmit(question:String){
		if(question.isEmpty || self.showOption == true){
			showAlert = AlertMessage(title:"Invalid",message:"Please provide valid input")
		}
		else{
			self.questionText = question
			DispatchQueue.global(qos: .userInitiated).async {
				let answer = self.mlModel.extractAnswer(for: question, in: recognizedContent.result.text)
				self.answerText = String(answer)
			}
			self.question = ""
		}
	}

}




struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
