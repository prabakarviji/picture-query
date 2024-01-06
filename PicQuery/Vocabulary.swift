//
//  Vocabulary.swift
//  Mahizh
//
//  Created by Prabakaran Marimuthu on 06/01/24.
//

import Foundation

struct Vocabulary {
	static let unkownTokenID = lookupDictionary["[UNK]"]!         // 100
	static let paddingTokenID = lookupDictionary["[PAD]"]!        // 0
	static let separatorTokenID = lookupDictionary["[SEP]"]!      // 102
	static let classifyStartTokenID = lookupDictionary["[CLS]"]!  // 101
	
	
	static func tokenID(of string: String) -> Int {
		let token = Substring(string)
		return tokenID(of: token)
	}
	
	static func tokenID(of token: Substring) -> Int {
		let unkownTokenID = Vocabulary.unkownTokenID
		return Vocabulary.lookupDictionary[token] ?? unkownTokenID
	}
	
	private init() { }
	private static let lookupDictionary = loadVocabulary()

	private static func loadVocabulary() -> [Substring: Int] {
		let fileName = "bert-base-uncased-vocab"
		let expectedVocabularySize = 30_522
		
		guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
			fatalError("Vocabulary file is missing")
		}
		
		guard let rawVocabulary = try? String(contentsOf: url) else {
			fatalError("Vocabulary file has no contents.")
		}
		
		let words = rawVocabulary.split(separator: "\n")
		
		guard words.count == expectedVocabularySize else {
			fatalError("Vocabulary file is not the correct size.")
		}
		
		guard words.first! == "[PAD]" && words.last! == "##～" else {
			fatalError("Vocabulary file contents appear to be incorrect.")
		}
		
		let values = 0..<words.count
		
		let vocabulary = Dictionary(uniqueKeysWithValues: zip(words, values))
		return vocabulary
	}
}

