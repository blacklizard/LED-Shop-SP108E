//
//  String.swift
//  LED Shop
//
//  Created by blacklizard on 27/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation
import AppKit
import CoreGraphics

extension String {
	private func matches(pattern: String) -> Bool {
		let regex = try! NSRegularExpression(pattern: pattern,options: [.caseInsensitive])
		return regex.firstMatch(
			in: self,
			options: [],
			range: NSRange(location: 0, length: utf16.count)) != nil
	}
	
	func isValidIPv4() -> Bool {
		var sin = sockaddr_in()
		if self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
			return true
		}
		return false
	}
	
	func isValidRGBHEX() -> Bool {
		return self.matches(pattern: "^[0-9A-Fa-f]{6}+$")
	}
}

extension String {
	var length: Int {
		return count
	}
	
	subscript (i: Int) -> String {
		return self[i ..< i + 1]
	}
	
	func substring(fromIndex: Int) -> String {
		return self[min(fromIndex, length) ..< length]
	}
	
	func substring(toIndex: Int) -> String {
		return self[0 ..< max(0, toIndex)]
	}
	
	subscript (r: Range<Int>) -> String {
		let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
											upper: min(length, max(0, r.upperBound))))
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		return String(self[start ..< end])
	}
}

extension String {
	func hexStringToInt() -> Int? {
		let scanner = Scanner(string: self)
		var value: UInt64 = 0
		
		if scanner.scanHexInt64(&value) {
			return Int(value)
		}
		return nil
	}
}

extension String {
	func toNSColor() -> NSColor? {
		if(!self.isValidRGBHEX()) {
			return nil;
		}
		let red = Float(self[0..<2].hexStringToInt()!)
		let green = Float(self[2..<4].hexStringToInt()!)
		let blue = Float(self[4..<6].hexStringToInt()!)
		return NSColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha:1.0)
	}
}
