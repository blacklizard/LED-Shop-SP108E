//
//  Dictionary.swift
//  LED Shop
//
//  Created by blacklizard on 27/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//
// https://stackoverflow.com/a/50007091

import Foundation

extension Dictionary where Value : Hashable {
	
	func swapKeyValues() -> [Value : Key] {
		assert(Set(self.values).count == self.keys.count, "Values must be unique")
		var newDict = [Value : Key]()
		for (key, value) in self {
			newDict[value] = key
		}
		return newDict
	}
}
