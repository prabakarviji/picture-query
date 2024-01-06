//
//  MLModel.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 06/01/24.
//

import CoreML

class MLQAModel {
	
	var mlModel: BERTQAFP16 {
		do {
			let defaultConfig = MLModelConfiguration()
			return try BERTQAFP16(configuration: defaultConfig)
		} catch {
			fatalError("Couldn't load BERT model due to: \(error.localizedDescription)")
		}
	}

	func extractAnswer(for question: String, in document: String) -> Substring {
		
		// Prepare the input for the BERT model.
		let bertInput = MLInput(documentString: document, questionString: question)
		
		guard bertInput.totalTokenSize <= MLInput.maxTokens else {
			var message = "Text and question are too long"
			message += " (\(bertInput.totalTokenSize) tokens)"
			message += " for the BERT model's \(MLInput.maxTokens) token limit."
			return Substring(message)
		}
		
		// The MLFeatureProvider that supplies the BERT model with its input MLMultiArrays.
		let modelInput = bertInput.modelInput!
		
		// Make a prediction with the BERT model.
		guard let prediction = try? mlModel.prediction(input: modelInput) else {
			return "The BERT model is unable to make a prediction."
		}
		
		// Analyze the output form the BERT model.
		guard let bestLogitIndices = bestLogitsIndices(from: prediction,
																									 in: bertInput.documentRange) else {
			return "Couldn't find a valid answer. Please try again."
		}
		
		// Find the indices of the original string.
		let documentTokens = bertInput.document.tokens
		let answerStart = documentTokens[bestLogitIndices.start].startIndex
		let answerEnd = documentTokens[bestLogitIndices.end].endIndex
		
		// Return the portion of the original string as the answer.
		let originalText = bertInput.document.original
		return originalText[answerStart..<answerEnd]
	}
}
