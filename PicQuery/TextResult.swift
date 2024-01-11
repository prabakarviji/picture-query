//
//  TextResult.swift
//  PicQuery
//
//  Created by Prabakaran Marimuthu on 10/01/24.
//

import Foundation

class TextResult: Identifiable {
	var text: String = ""
}


class RecognizedContent: ObservableObject {
	@Published var result = TextResult()
}
