//
//  TickCountingTimer.swift
//  SpatialTuner
//
//  Created by Matt Pfeiffer on 3/16/24.
//

import Foundation

/// Book-keeping timer that fires off events based on the tick counting
@Observable
public class TickCountingTimer {
    // MARK: public members
    public var tickEventCallback: ((_ type: TickEventType) -> Void)?
    public var isRunning: Bool = false
    public var currentMeter: Int = 4 // The number of beats per bar
    public var subdivision: Subdivision = .one
    public var tempoBPM: Double = 120 {
        didSet {
            throttledUpdater?.update()
            hypermeterManager.tempoArray[currentMeasure] = tempoBPM
        }
    }
    public var currentTick: UInt32 = 0
    public var currentBeat: Int = 0 //treat as index (starting from 0)
    
    public var hypermeterManager = HypermeterManager()
    public var currentMeasure: Int = 0 //treat as index (starting from 0)
    public var queuedBar: QueuedBars = .none
    
    // MARK: private members
    private let ticksPerHit: UInt32 = 24 // sets resolution - more reliable when as as low as possible
    private var throttledUpdater: ThrottledUpdater? // throttles bpm updates
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "com.SpatialTuner.clockTimer", attributes: .concurrent)
    private var ticksPerSubdivision: UInt32 {
        ticksPerHit / subdivision.divisionsPerBeat
    }
 
    public init() {
        createTimer()
        throttledUpdater = ThrottledUpdater(interval: 0.05) {
            let tickInterval = (60.0 / self.tempoBPM) / Double(self.ticksPerHit)
            self.timer?.schedule(deadline: .now(), repeating: tickInterval)
        }
    }
    
    deinit {
        // this seems weird... should it be only cancel if it is running? Why are we resuming to then cancel?
        if !isRunning { timer?.resume() }
        timer?.cancel()
        timer = nil
    }
    
    func pause() {
        if isRunning {
            timer?.suspend()
            isRunning = false
        }
    }
    
    func resume() {
        currentBeat = 0
        currentTick = 0
        tickEventCallback?(hypermeterManager.hyperArray[currentMeasure][0])
        if !isRunning {
            timer?.resume()
            isRunning = true
        }
    }
    
    func createTimer() {
        if isRunning {
            timer?.suspend()
        }

        let tickInterval = (60.0 / tempoBPM) / Double(ticksPerHit)
        
        if timer == nil {
            timer = DispatchSource.makeTimerSource(queue: queue)
            timer?.setEventHandler { [weak self] in
                self?.tick()
            }
        }

        timer?.schedule(deadline: .now(), repeating: tickInterval, leeway: .nanoseconds(0))
    }
    
    func tick() {
        currentTick += 1
        
        if currentTick % ticksPerSubdivision == 0 && currentTick % ticksPerHit != 0 {
                    tickEventCallback?(.subdivision)
                }
        // check if we've got a beat at this location
        var currentHit = currentBeat
        if currentTick % ticksPerHit == 0 {
            currentHit += 1
            //currentBeat at this point is the number of the previously sounded beat, because beat has yet to be updated.
            if currentHit % hypermeterManager.hyperArray[currentMeasure].count == 0 { // restart at downbeat
                currentTick = 0
                tickEventCallback?(hypermeterManager.hyperArray[currentMeasure][0])
                DispatchQueue.main.async {
                    self.queueBar(self.queuedBar)
                    self.queuedBar = .none
                }
            } else { // other beats
                tickEventCallback?(hypermeterManager.hyperArray[currentMeasure][currentBeat+1])
                DispatchQueue.main.async {
                    self.currentBeat = currentHit
                }
            }
        }
    }
    
    func queueBar(_ queuedBar: QueuedBars) {
        switch queuedBar {
        case .none:
            self.currentBeat = 0
        case .next:
            self.nextBar()
        case .previous:
            self.previousBar()
        }
    }
    
    func nextBar() {
        if self.currentMeasure < self.hypermeterManager.tempoArray.count - 1 {
            self.currentMeasure += 1
            self.currentBeat = 0
            self.tempoBPM = self.hypermeterManager.tempoArray[currentMeasure]
        } else {self.currentBeat = 0}
    }
    
    func previousBar() {
        if currentMeasure > 0 {
            currentMeasure -= 1
            currentBeat = 0
            tempoBPM = hypermeterManager.tempoArray[currentMeasure]
        } else {self.currentBeat = 0}
    }
    
}

// MARK: TickEventType
public enum TickEventType {
    case primary, secondary, tertiary, subdivision, silent
}

public enum QueuedBars {
    case none, next, previous
}
