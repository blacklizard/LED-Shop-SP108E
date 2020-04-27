//
//  Color.swift
//  LED Shop
//
//  Created by blacklizard on 26/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

//  https://www.cs.rit.edu/~ncs/color/t_convert.html
struct HSV {
	var h: CGFloat // Angle in degrees [0,360] or -1 as Undefined
	var s: CGFloat // Percent [0,1]
	var v: CGFloat // Percent [0,1]
	
	func toRGB() -> String {		
		if s == 0 { // Achromatic grey
			return NSColor(red: v, green: v, blue: v, alpha: 1).toHEX
		}
		
		let angle = (h >= 360 ? 0 : h)
		let sector = angle / 60 // Sector
	
		let i = floor(sector)
		let f = sector - i // Factorial part of h
		
		let p = v * (1 - s)
		let q = v * (1 - (s * f))
		let t = v * (1 - (s * (1 - f)))
		
		var red: CGFloat!
		var green: CGFloat!
		var blue: CGFloat!
		
		switch(i) {
			case 0:
				red = v.map(from: 0.0...1.0, to: 0...255)
				green = t.map(from: 0.0...1.0, to: 0...255)
				blue = p.map(from: 0.0...1.0, to: 0...255)
			case 1:
				red = q.map(from: 0.0...1.0, to: 0...255)
				green = v.map(from: 0.0...1.0, to: 0...255)
				blue = p.map(from: 0.0...1.0, to: 0...255)
			case 2:
				red = p.map(from: 0.0...1.0, to: 0...255)
				green = v.map(from: 0.0...1.0, to: 0...255)
				blue = t.map(from: 0.0...1.0, to: 0...255)
			case 3:
				red = p.map(from: 0.0...1.0, to: 0...255)
				green = q.map(from: 0.0...1.0, to: 0...255)
				blue = v.map(from: 0.0...1.0, to: 0...255)
			case 4:
				red = t.map(from: 0.0...1.0, to: 0...255)
				green = p.map(from: 0.0...1.0, to: 0...255)
				blue = v.map(from: 0.0...1.0, to: 0...255)
			default:
				red = v.map(from: 0.0...1.0, to: 0...255)
				green = p.map(from: 0.0...1.0, to: 0...255)
				blue = q.map(from: 0.0...1.0, to: 0...255)
		}
		return NSString(format: "%02X%02X%02X", Int(round(red!)), Int(round(green!)), Int(round(blue!))) as String
	}
}

extension NSColor {
	var toHEX: String {
		guard let rgbColor = usingColorSpace(NSColorSpace.genericRGB) else {
			return "000000"
		}
		let red = Int(round(rgbColor.redComponent * 0xFF))
		let green = Int(round(rgbColor.greenComponent * 0xFF))
		let blue = Int(round(rgbColor.blueComponent * 0xFF))
		let hexString = NSString(format: "%02X%02X%02X", red, green, blue)
		return hexString as String
	}
}
