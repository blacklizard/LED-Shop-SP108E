//
//  KeepAlive.swift
//  LED Shop
//
//  Created by blacklizard on 20/05/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class KeepAlive {
    private var timer: Timer!
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1800 , target: self, selector: #selector(self.checkDevice),userInfo: nil, repeats: true)
    }
    
    @objc func checkDevice() {
        // just send a random get request
        // hoping this will keep the device connected to wifi
        let _ = API.shared.getDeviceConfig()
    }
    
    func stop() {
        timer?.invalidate()
    }
}
