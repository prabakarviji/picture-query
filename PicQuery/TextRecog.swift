//
//  TextRecog.swift
//  PicQuery
//
//  Created by Prabakaran Marimuthu on 09/01/24.
//

import Foundation
import SwiftUI
import Vision

struct TextRecog {
	var image:Data
	@ObservedObject var recognizedContent: RecognizedContent
	var didFinishRecognition: () -> Void
	
	func recognizeText() {
		let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
		queue.async {
			guard let cgImage = UIImage(data:image)?.cgImage else { return }
			let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
			
			do {
				let textResult = TextResult()
				try requestHandler.perform([recognizeTextHandler(with:textResult)])
				DispatchQueue.main.async {
					recognizedContent.result = textResult
				}
			} catch {
				print(error.localizedDescription)
			}
			
			DispatchQueue.main.async {
				didFinishRecognition()
			}
		}
	}
	
	func clearText(){
		recognizedContent.result.text = ""
	}
	
	
	private func recognizeTextHandler(with textResult:TextResult) -> VNRecognizeTextRequest {
		let request = VNRecognizeTextRequest { request, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let observations = request.results as? [VNRecognizedTextObservation] 
			else { return }
			
			observations.forEach { observation in
				guard let recognizedText = observation.topCandidates(1).first else { return }
				
				textResult.text += recognizedText.string
				textResult.text += "\n"
			}
		}
		request.recognitionLevel = .accurate
		request.usesLanguageCorrection = true
		
		return request
	}
	
	
}
