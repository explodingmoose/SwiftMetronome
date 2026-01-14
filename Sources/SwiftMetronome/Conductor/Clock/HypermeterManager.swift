//
//  HypermeterManager.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/7/26.
//

import Foundation


@Observable public class HypermeterManager {
    public var hyperArray: [[TickEventType]] = [[.primary, .tertiary, .tertiary, .tertiary], [.primary, .tertiary, .tertiary]] //Each bar's rhythm
    public var tempoArray: [Double] = [120, 90] //Each bar's tempo

    
    public func addBar(meter: Int, measure: Int, tempo: Double) {
        hyperArray.insert([TickEventType.primary], at: measure) //Add a downbeat of the bar before the given measure number
        for _ in 2...meter {
            hyperArray[measure].append(.tertiary) //add the rest of the beats
        }
        tempoArray.insert(tempo, at: measure)
    }
    
    public func deleteBar(measure: Int) {
        hyperArray.remove(at: measure)
        tempoArray.remove(at: measure)
    }
    
    public func changeTickEventType(currentMeasure: Int, currentBeat: Int) {
        let oldBeat:TickEventType = hyperArray[currentMeasure][currentBeat]
        switch oldBeat {
        case .primary:
            hyperArray[currentMeasure][currentBeat] = .secondary
        case .secondary:
            hyperArray[currentMeasure][currentBeat] = .tertiary
        case .tertiary:
            hyperArray[currentMeasure][currentBeat] = .silent
        case .silent:
            hyperArray[currentMeasure][currentBeat] = .primary
        case .subdivision:
            return
        }
    }
    
}
