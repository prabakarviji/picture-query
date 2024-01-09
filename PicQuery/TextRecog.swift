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
	
	//@ObservedObject var recognizedContent: RecognizedContent
	//var didFinishRecognition: () -> Void
	
	
	func recognizeText() {
		let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
		queue.async {
				//guard let cgImage = image.cgImage else { return }
				guard let cgImage = UIImage(named: "Apple.png")?.cgImage else { return }

				
				let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
				
				do {
					try requestHandler.perform([recognizeTextHandler()])
					
					DispatchQueue.main.async {
						//recognizedContent.items.append(textItem)
					}
				} catch {
					print(error.localizedDescription)
				}
				
				DispatchQueue.main.async {
					//didFinishRecognition()
				}
			
		}
	}
	
	
	private func recognizeTextHandler() -> VNRecognizeTextRequest {
		let request = VNRecognizeTextRequest { request, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
			
			observations.forEach { observation in
				guard let recognizedText = observation.topCandidates(1).first else { return }
				print(recognizedText.string)
				
			}
		}
		
		request.recognitionLevel = .accurate
		request.usesLanguageCorrection = true
		
		return request
	}
}
