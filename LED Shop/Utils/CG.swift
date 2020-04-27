//
//  CG.swift
//  LED Shop
//
//  Created by blacklizard on 27/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

extension CGFloat {
	func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
		let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
		return result
	}
}
