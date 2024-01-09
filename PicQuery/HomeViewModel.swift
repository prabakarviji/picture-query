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
	
	func submitQuestion() {
		
		DispatchQueue.global(qos: .userInitiated).async {
			
			let searchText = "What are the alternative names?"
			
			var details = "HackerNews site was created by Paul Graham in February 2007.[2] Initially called Startup News or occasionally News.YC., it became known by its current name on August 14, 2007.[3] It developed as a project of Graham's company Y Combinator, functioning as a real-world application of the Arc programming language which Graham co-developed.At the end of March 2014, Graham stepped away from his leadership role at Y Combinator, leaving Hacker News administration in the hands of other staff members.[5][6] The site is currently moderated by Daniel Gackle who posts under the username dang.[7] Gackle co-moderated Hacker News with Scott Bell (username sctb) until 2019 when Bell stopped working on the site.[8]"
			
			// Utilize our ML model to extract  the answer.
			let answer = self.mlModel.extractAnswer(for: searchText, in: details)
			print(answer)
			
			// Update the UI on the main queue.
			//DispatchQueue.main.async {
			//	if answer.base == detail.body, let textView = self.documentTextView {
					
					// Highlight the answer substring in the original text.
//					let semiTextColor = UIColor(named: "Semi Text Color")!
//					let helveticaNeue17 = UIFont(name: "HelveticaNeue", size: 17)!
//					let bodyFont_mlModel	Mahizh.MLQAModel	0x000060000000c290 = UIFontMetrics(forTextStyle: .body).scaledFont(for: helveticaNeue17)
//
//					let mutableAttributedText = NSMutableAttributedString(string: detail.body,
//																																attributes: [.foregroundColor: semiTextColor,
//																																						 .font: bodyFont])
//					
//					let location = answer.startIndex.utf16Offset(in: detail.body)
//					let length = answer.endIndex.utf16Offset(in: detail.body) - location
//					let answerRange = NSRange(location: location, length: length)
//					let fullTextColor = UIColor(named: "Full Text Color")!
//					
//					mutableAttributedText.addAttributes([.foregroundColor: fullTextColor],
//																							range: answerRange)
//					textView.attributedText = mutableAttributedText
//				}
//				textField.text = String(answer)
//				textField.placeholder = placeholder
			//}
		}
	}
	
}
