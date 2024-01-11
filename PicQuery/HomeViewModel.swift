//
//  HomeViewModel.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 06/01/24.
//

import Foundation

@Observable
class HomeViewModel {
	
	var mlModel = MLQAModel()
	
	func submitQuestion(question:String,textContent:String) -> String {
		
		var answer = ""
		DispatchQueue.global(qos: .userInitiated).async {
			answer = String(self.mlModel.extractAnswer(for: question, in: textContent))
			print(answer,"#1###")
		}
		print(answer,"####")
		return answer
		
	}
	
}
