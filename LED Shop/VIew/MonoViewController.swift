//
//  MonoViewController.swift
//  LED Shop
//
//  Created by blacklizard on 25/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

class MonoViewController: NSViewController {
	
	@IBOutlet weak var controllerIP: NSTextField!
	@IBOutlet weak var brightness: NSSlider!
	@IBOutlet weak var speed: NSSlider!
	@IBOutlet weak var hueSlider: NSSlider!
	@IBOutlet weak var mode: NSPopUpButton!
	
	private var colorSelectionThrottler = Throttler(minimumDelay: 0.009)
	private var device: Device!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		controllerIP.delegate = self
		let endpoint = UserDefaults.standard.string(forKey: "endpoint")
		if(endpoint == nil) {
			controllerIP.backgroundColor = .red
		} else {
			controllerIP.stringValue = endpoint!
			device = API.shared.getDeviceConfig()
			speed.integerValue = device.speed
			brightness.integerValue = device.brightness
			
			let swappedModes = MODE.swapKeyValues()
			mode.selectItem(withTitle: (swappedModes[device.mode] ?? swappedModes[MODE["STATIC"]!])!)
			
			let color = device.color.toNSColor()
			var hue = color!.hueComponent.map(from: 0.0...1.0, to: 0...360)
			hue = hue == 360 ? 0 : hue
			hueSlider.integerValue = Int(hue)
		}
	}
	
	@IBAction func selectWhite(_ sender: NSButton) {
		API.shared.setColor(color: "FFFFFF")
	}
	
	@IBAction func toggleOnOff(_ sender: NSButton) {
		API.shared.toggleOnOff()
	}
	
	@IBAction func monoModeSelected(_ sender: NSPopUpButton) {
		let mode = sender.selectedItem!.identifier!.rawValue as String
		API.shared.setMonoMode(mode: MODE[mode]!)
	}
	
	@IBAction func colorChanged(_ sender: NSSlider) {
		colorSelectionThrottler.throttle {
			let rgb = HSV(h: CGFloat(sender.integerValue), s: CGFloat(1), v: CGFloat(1)).toRGB()
			API.shared.setColor(color: rgb)
		}
	}
	
	@IBAction func brightnessChanged(_ sender: NSSlider) {
		API.shared.setBrightness(value: sender.integerValue)
	}
	
	@IBAction func speedChanged(_ sender: NSSlider) {
		API.shared.setSpeed(speed: sender.integerValue)
	}
}

extension MonoViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ notification: Notification) {
		if let textField = notification.object as? NSTextField {
			if (textField == controllerIP && controllerIP.stringValue.isValidIPv4()) {
				controllerIP.backgroundColor = .none
				UserDefaults.standard.set(controllerIP.stringValue, forKey: "endpoint")
                NotificationCenter.default.post(name: NSNotification.Name("setting.complete"), object: nil)
			} else {
				controllerIP.backgroundColor = .red
			}
		}
	}
}
