// StopWatch.swift
// Original file from
// https://gist.github.com/programmingwithswift/0303decba01bba1189e66d4943dda4a3
// Was Build upon first swiftUI beta
// Modified and add more funcitonalities by Mingtian Yang for working on current SwiftUI build

import Combine
import Foundation
import SwiftUI

class StopWatch: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    
    var maxTimeInSec:Int?
    
    @Published private(set) var stopWatchTime = "00:00:00"
    @Published private(set) var progressPercent = CGFloat(1)
    
    var paused = true
    
    var laps = [StopWatchLap]()
    
    private var currentLaps = [StopWatchLap]() {
        didSet {
            self.laps = currentLaps.reversed()
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
        
        if let _ = sourceTimer {
            self.resumeTimer()
            return
        } else {
            self.startTimer()
            return
        }
        
    }
    
    func pause() {
        self.paused = true
        self.sourceTimer?.suspend()
    }
    
    func lap() {
        if let firstLap = self.laps.first {
            let difference = self.counter - firstLap.count
            self.currentLaps.append(StopWatchLap(count: self.counter, diff: difference))
        } else {
            self.currentLaps.append(StopWatchLap(count: self.counter))
        }
    }
    
    func reset() {
        self.stopWatchTime = "00:00:00"
        self.progressPercent = CGFloat(0)
        self.counter = 0
        self.currentLaps = [StopWatchLap]()
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        if (!StopWatch.isCountMeetMaxTimeInSec(counter: self.counter, maxTimeInSec: self.maxTimeInSec)) {
            self.sourceTimer?.schedule(deadline: .now(), repeating: 0.01)
            self.sourceTimer?.resume()
        }
    }
    
    private func updateTimer() {
        
        if (!StopWatch.isCountMeetMaxTimeInSec(counter: self.counter, maxTimeInSec: self.maxTimeInSec)) {
            self.counter += 1
            
            DispatchQueue.main.async {
                self.progressPercent = StopWatch.calculateProgressPercent(counter: self.counter, maxTimeInSec: self.maxTimeInSec)
                self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter)
            }
        } else {
            self.pause()
        }
        

    }
}

extension StopWatch {
    struct StopWatchLap {
        let uuid = UUID()
        let count: Int
        let stringTime: String
        
        init(count: Int, diff: Int = -1) {
            self.count = count
            
            if diff < 0 {
                self.stringTime = StopWatch.convertCountToTimeString(counter: count)
            } else {
                self.stringTime = StopWatch.convertCountToTimeString(counter: diff)
            }
        }
    }
}

extension StopWatch {
    
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
