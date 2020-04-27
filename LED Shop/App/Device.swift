//
//  Device.swift
//  LED Shop
//
//  Created by blacklizard on 27/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

struct Device {
	var state: Int = 0
	var mode: Int = MODE["STATIC"] ?? 211
	var speed: Int = 0
	var brightness: Int = 0
	var color: String = "FF0000"
}
