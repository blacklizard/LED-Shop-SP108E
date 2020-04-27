//
//  Throttler.swift
//  LED Shop
//
//  Created by blacklizard on 26/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//
// based on https://www.craftappco.com/blog/2018/5/30/simple-throttling-in-swift

import Foundation

class Throttler {
	
	private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
	private var previousRun: Date = Date.distantPast
	private let queue: DispatchQueue
	private let minimumDelay: TimeInterval
	
	init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
		self.minimumDelay = minimumDelay
		self.queue = queue
	}
	
	func throttle(_ block: @escaping () -> Void) {
		// Cancel any existing work item if it has not yet executed
		workItem.cancel()
		
		// Re-assign workItem with the new block task, resetting the previousRun time when it executes
		workItem = DispatchWorkItem() {
			[weak self] in
			self?.previousRun = Date()
			block()
		}
		
		// If the time since the previous run is more than the required minimum delay
		// => execute the workItem immediately
		// else
		// => delay the workItem execution by the minimum delay time
		let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
		queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
	}
}
