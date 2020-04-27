//
//  TCPSocket.swift
//  LED Shop
//
//  Created by blacklizard on 25/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation
import Socket

class TCPSocket {
	static let shared = TCPSocket()
	
	func send(data: String, expectResponse: Bool = false, expectString: Bool = false) -> String? {
		do {
			let socket = try Socket.create(family: Socket.ProtocolFamily.inet)
			try socket.connect(to: UserDefaults.standard.string(forKey: "endpoint")!, port: 8189, timeout: 2000)
			let byte = unhexlify(data)!
			try socket.write(from: byte)

			if(expectResponse) {
				let response:NSMutableData = NSMutableData()
				_ = try socket.read(into: response)
				socket.close()
				let responsePointer = UnsafeRawBufferPointer(start: response.bytes, count: response.length)
				var format = "%02x"
				if(expectString) {
					format = "%c"
				}
				var result = ""
				for (_ , byte) in responsePointer.enumerated() {
					result += String(format: format, byte)
				}
				
				return result
			}
		}
		catch {
			print("Unexpected error: \(error).")
		}
		
		return nil
	}
}
