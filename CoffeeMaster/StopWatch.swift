//
//  StopWatch.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/21/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class StopWatch: ObservableObject {
    private var counter: Int = 0
    private var timer: Timer? = nil
    var maxTimeInSec:Int?
    
    @Published private(set) var stopWatchTime = "00:00:00"
    @Published private(set) var stopWatchTimeInSec = 0
    @Published private(set) var progressPercent = CGFloat(1)
    
    var paused = true
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(StopWatch.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if (!StopWatch.isCountMeetMaxTimeInSec(counter: self.counter, maxTimeInSec: self.maxTimeInSec)) {
            self.counter += 1
            
            DispatchQueue.main.async {
                self.progressPercent = StopWatch.calculateProgressPercent(counter: self.counter, maxTimeInSec: self.maxTimeInSec)
                self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
                self.stopWatchTimeInSec = self.counter / 100
            }
        }
    }
    
    func setTimeInSet(timeInSet: Int) {
        let counter = timeInSet * 100
        self.counter = counter
    }
    
    
    func setMaxTimeInSec(maxTimeInSec: Int) {
        self.maxTimeInSec = maxTimeInSec
    }
    
    func start() {
        self.paused = false

        self.runTimer()
    }
    
    func pause() {
        self.timer?.invalidate()
        self.paused = true
    }
    
    func reset() {
        self.timer?.invalidate()
        self.stopWatchTime = "00:00:00"
        self.stopWatchTimeInSec = 0
        self.progressPercent = CGFloat(0)
        self.counter = 0
    }
    
    func isPaused() -> Bool {
        return self.paused
    }

    
    static func calculateProgressPercent(counter: Int, maxTimeInSec: Int?) -> CGFloat {
        let seconds = counter / 100
        
        if (maxTimeInSec == nil) {
            return CGFloat(1)
        }
         
        return CGFloat(seconds) / CGFloat(maxTimeInSec!)
    }
    static func isCountMeetMaxTimeInSec(counter: Int, maxTimeInSec: Int?) -> Bool {
        let seconds = counter / 100
        
        if (maxTimeInSec == nil) {
            return false
        }
        
        if (seconds >= maxTimeInSec!) {
            return true
        }
        
        return false
    }
    static func convertCountToTimeString(counter: Int) -> String {
        let millseconds = counter % 100
        let seconds = counter / 100
        let minutes = seconds / 60
        
        var millsecondsString = "\(millseconds)"
        var secondsString = "\(seconds % 60)"
        var minutesString = "\(minutes)"
        
        if millseconds < 10 {
            millsecondsString = "0" + millsecondsString
        }
        
        if (seconds % 60) < 10 {
            secondsString = "0" + secondsString
        }
        
        if minutes < 10 {
            minutesString = "0" + minutesString
        }
        
        return "\(minutesString):\(secondsString):\(millsecondsString)"
    }
}
