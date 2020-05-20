//
//  AppDelegate.swift
//  LED Shop
//
//  Created by blacklizard on 25/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	private var settingWindowController: NSWindowController?
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let keepAlive:KeepAlive = KeepAlive()
	
	@IBOutlet weak var statusMenu: NSMenu!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		attachStatusBarMenu()
		registerObserver()
		
		let endpoint = UserDefaults.standard.string(forKey: "endpoint")
		if(endpoint == nil) {
			openSetting()
        } else {
            let startTimer = Timer.scheduledTimer(timeInterval: 5 , target: self, selector: #selector(self.onStartUp),userInfo: nil, repeats: false)
            RunLoop.current.add(startTimer, forMode: RunLoop.Mode.common)
        }
	}
    
    func applicationWillTerminate(_ aNotification: Notification) {
        removeObserver()
        onExit()
    }
	
	@objc private func didWakeNotification(note: NSNotification) {
		Timer.scheduledTimer(timeInterval: 5 , target: self, selector: #selector(self.onStartUp),userInfo: nil, repeats: false)
	}

	@objc private func willSleepNotification(note: NSNotification) {
		onExit()
	}
	
	@objc private func toggle() {
		API.shared.toggleOnOff()
	}
	
	@objc private func onStartUp() {
        print("onStartUp")
        keepAlive.start()
		let device: Device = API.shared.getDeviceConfig()
		
		if(device.state == 0) {
			toggle()
		}
	}
	
	private func onExit() {
        print("onExit")
		let device: Device = API.shared.getDeviceConfig()
		
		if(device.state == 1) {
			toggle()
		}
        
        keepAlive.stop()
	}
	
	private func attachStatusBarMenu() {
		let icon = NSImage(named: "statusBarIcon")
		icon?.isTemplate = true
		statusItem.button?.image = icon
		statusItem.menu = statusMenu
	}
	
	private func registerObserver() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWakeNotification(note:)),name: NSWorkspace.didWakeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleepNotification(note:)),name: NSWorkspace.willSleepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStartUp), name: NSNotification.Name("setting.complete"), object: nil)
	}
	
	private func removeObserver() {
		NotificationCenter.default.removeObserver(self, name: NSWorkspace.didWakeNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSWorkspace.willSleepNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("setting.complete"), object: nil)
	}
	
	@IBAction func toggleClicked(_ sender: NSMenuItem) {
		toggle()
	}
	
	@IBAction func openSetting(_ sender: NSMenuItem = NSMenuItem()) {
		if settingWindowController == nil {
			settingWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SettingWindowController") as? NSWindowController
		}
		NSApp.activate(ignoringOtherApps: true)
		settingWindowController?.showWindow(self)
		settingWindowController?.window?.makeKey()
	}

}

