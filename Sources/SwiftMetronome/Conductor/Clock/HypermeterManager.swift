//
//  HypermeterManager.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/7/26.
//

import Foundation


@Observable public class HypermeterManager {
    public var hyperArray: [[TickEventType]] = [[.primary, .tertiary, .tertiary, .tertiary]] //Each bar's rhythm
    public var tempoArray: [Double] = [120] //Each bar's tempo

    
    func addBar(meter: Int, measure: Int, tempo: Double) {
        hyperArray.insert([TickEventType.primary], at: measure-1) //Add a downbeat of the bar before the given measure number
        for beat in 2...meter {
            hyperArray[measure-1].append(.tertiary) //add the rest of the beats
        }
        tempoArray.insert(tempo, at: measure-1)
    }
    
    func deleteBar(measure: Int) {
        hyperArray.remove(at: measure-1)
        tempoArray.remove(at: measure-1)
    }
    
    public func changeTickEventType(currentMeasure: Int, currentBeat: Int) {
        let oldBeat:TickEventType = hyperArray[currentMeasure-1][currentBeat]
        switch oldBeat {
        case .primary:
            hyperArray[currentMeasure-1][currentBeat] = .secondary
        case .secondary:
            hyperArray[currentMeasure-1][currentBeat] = .tertiary
        case .tertiary:
            hyperArray[currentMeasure-1][currentBeat] = .silent
        case .silent:
            hyperArray[currentMeasure-1][currentBeat] = .primary
        }
    }
    
}
