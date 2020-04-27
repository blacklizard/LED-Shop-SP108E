//
//  BinUtils.swift
//  BinUtils
//
//  Created by Nicolas Seriot on 12/03/16.
//  Copyright © 2016 Nicolas Seriot. All rights reserved.
//

import Foundation
import CoreFoundation

extension String {
	subscript (from:Int, to:Int) -> String {
		return NSString(string: self).substring(with: NSMakeRange(from, to-from))
	}
}

extension Data {
	var bytes : [UInt8] {
		return [UInt8](self)
	}
}

public func unhexlify(_ string:String) -> Data? {
	
	// similar to unhexlify() in Python's binascii module
	// https://docs.python.org/2/library/binascii.html
	
	let s = string.uppercased().replacingOccurrences(of: " ", with: "")
	
	let nonHexCharacterSet = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
	if let range = s.rangeOfCharacter(from: nonHexCharacterSet) {
		print("-- found non hex character at range \(range)")
		return nil
	}
	
	var data = Data(capacity: s.count / 2)
	
	for i in stride(from: 0, to:s.count, by:2) {
		let byteString = s[i, i+2]
		let byte = UInt8(byteString.withCString { strtoul($0, nil, 16) })
		data.append([byte] as [UInt8], count: 1)
	}
	return data
}

