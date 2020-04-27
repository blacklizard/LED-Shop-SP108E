//
//  API.swift
//  LED Shop
//
//  Created by blacklizard on 27/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class API {
	static let shared = API(transport: TCPSocket.shared)
	
	let transport: TCPSocket
	
	private init(transport: TCPSocket) {
		self.transport = transport
	}
	
	func getDeviceConfig() -> Device {
		let config = transport.send(data: "380000001083", expectResponse: true, expectString: false)
		if(config != nil) {
			let state = Int(config![3])
			let mode = config![4..<6].hexStringToInt()
			let speed = config![6..<8].hexStringToInt()
			let brightness = config![8..<10].hexStringToInt()
			let color = config![20..<26]
			
			return Device(state: state!, mode: mode!, speed: speed!, brightness: brightness!, color: color)
		}
		
		return Device()
	}
	
	func toggleOnOff() {
		_ = transport.send(data: "38000000AA83")
	}
	
	func setColor(color: String) {
		_ = transport.send(data: "38"+color+"2283")
	}
	
	func setMonoMode(mode: Int) {
		var result = String(mode, radix: 16)
		if(mode < 16) {
			result = "0"+result
		}
		_ = transport.send(data: "38"+result+"00002C83")
	}
	
	func setBrightness(value: Int) {
		var result = String(value, radix: 16)
		if(value < 16) {
			result = "0"+result
		}
		_ = transport.send(data: "38"+result+"00002A83")
	}
	
	func setSpeed(speed: Int) {
		var result = String(speed, radix: 16)
		if(speed < 16) {
			result = "0"+result
		}
		_ = transport.send(data: "38"+result+"00000383")
	}
}
