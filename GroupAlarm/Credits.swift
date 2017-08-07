//
//  Credits.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 8/4/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class Credits: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var creditsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myLink = "http://www.icons8.com"
        let myText = "Credits to \(myLink) for several icons."
        let myAttributedText = NSMutableAttributedString(string: myText)
        let rangeOfMyLink = myText.range(of: myLink)
        if rangeOfMyLink != nil {
            let nsRange = myText.nsRange(from: rangeOfMyLink!)
            myAttributedText.addAttributes([NSLinkAttributeName : myLink], range: nsRange)
        }
        
        let wholeStringRange = myText.range(of: myText)
        let nsRangeWhole = myText.nsRange(from: wholeStringRange!)
        myAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: nsRangeWhole)
        
//        ,[NSTextAlignment : NSTextAlignment.center], [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)]
        
        creditsTextView.attributedText = myAttributedText
        creditsTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        present(safariVC, animated: true, completion: nil)
        return false
    }
    
}

extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper = UTF16View.Index(range.upperBound, within: utf16)
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
}
