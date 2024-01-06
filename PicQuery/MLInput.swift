//
//  MLInput.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 06/01/24.
//

import CoreML

struct MLInput {
	
	static let maxTokens = 384 // max no of tokens the BERT model can process
	
	static private let documentTokenOverhead = 2
	
	static private let totalTokenOverhead = 3
	
	var modelInput: BERTQAFP16Input?
	
	let question: StringTokenizer
	let document: StringTokenizer
	
	private let documentOffset: Int
	
	var documentRange: Range<Int> {
		return documentOffset..<documentOffset + document.tokens.count
	}
	
	var totalTokenSize: Int {
		return MLInput.totalTokenOverhead + document.tokens.count + question.tokens.count
	}
	
	init(documentString: String, questionString: String) {
		document = StringTokenizer(documentString)
		question = StringTokenizer(questionString)
		
		// Save the number of tokens before the document tokens for later.
		documentOffset = MLInput.documentTokenOverhead + question.tokens.count
		
		guard totalTokenSize < MLInput.maxTokens else {
			return
		}
		
		// Start the wordID array with the `classification start` token.
		var wordIDs = [Vocabulary.classifyStartTokenID]
		
		// Add the question tokens and a separator.
		wordIDs += question.tokenIDs
		wordIDs += [Vocabulary.separatorTokenID]
		
		// Add the document tokens and a separator.
		wordIDs += document.tokenIDs
		wordIDs += [Vocabulary.separatorTokenID]
		
		// Fill the remaining token slots with padding tokens.
		let tokenIDPadding = MLInput.maxTokens - wordIDs.count
		wordIDs += Array(repeating: Vocabulary.paddingTokenID, count: tokenIDPadding)
		
		guard wordIDs.count == MLInput.maxTokens else {
			fatalError("`wordIDs` array size isn't the right size.")
		}
		
		// Build the token types array in the same order.
		// The document tokens are type 1 and all others are type 0.
		
		// Set all of the token types before the document to 0.
		var wordTypes = Array(repeating: 0, count: documentOffset)
		
		// Set all of the document token types to 1.
		wordTypes += Array(repeating: 1, count: document.tokens.count)
		
		// Set the remaining token types to 0.
		let tokenTypePadding = MLInput.maxTokens - wordTypes.count
		wordTypes += Array(repeating: 0, count: tokenTypePadding)
		
		guard wordTypes.count == MLInput.maxTokens else {
			fatalError("`wordTypes` array size isn't the right size.")
		}
		
		// Create the MLMultiArray instances.
		let tokenIDMultiArray = try? MLMultiArray(wordIDs)
		let wordTypesMultiArray = try? MLMultiArray(wordTypes)
		
		// Unwrap the MLMultiArray optionals.
		guard let tokenIDInput = tokenIDMultiArray else {
			fatalError("Couldn't create wordID MLMultiArray input")
		}
		
		guard let tokenTypeInput = wordTypesMultiArray else {
			fatalError("Couldn't create wordType MLMultiArray input")
		}
		
		// Create the BERT input MLFeatureProvider.
		let modelInput = BERTQAFP16Input(wordIDs: tokenIDInput,
																		 wordTypes: tokenTypeInput)
		self.modelInput = modelInput
	}
}

