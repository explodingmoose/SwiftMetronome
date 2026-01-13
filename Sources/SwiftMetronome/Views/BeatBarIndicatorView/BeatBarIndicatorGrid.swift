//
//  BeatBarIndicatorGrid.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/10/26.
//

import SwiftUI

struct BeatBarIndicatorGrid: View {
    let clock: TickCountingTimer
    var numberOfBeats: Int {
        clock.hypermeterManager.hyperArray[clock.currentMeasure-1].count
    }
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    let firstRowUpperBound = numberOfBeats > 6 ? 6 : numberOfBeats //allows for a second row for space
                    HStack(spacing: 6) {
                        ForEach(0..<firstRowUpperBound, id: \.self) { index in
                                BeatBar(hypermeterManager: clock.hypermeterManager,
                                        isRunning: clock.isRunning, currentMeasure: clock.currentMeasure, currentBeat: clock.currentBeat, index: index)
                        }
                    }
                    .frame(minHeight: 45, alignment: .center)
                    Spacer(minLength: 0)
                }
                .padding(1)
                if (numberOfBeats > 6) {
                HStack {
                    Spacer()
                        HStack(spacing: 6) {
                            ForEach(6..<numberOfBeats, id: \.self) { index in
                                ZStack {
                                    BeatBar(hypermeterManager: clock.hypermeterManager,
                                            isRunning: clock.isRunning, currentMeasure: clock.currentMeasure, currentBeat: clock.currentBeat, index: index)
                                }
                                .frame(minHeight: 45, alignment: .center)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }

#Preview {
    BeatBarIndicatorGrid(clock: TickCountingTimer())
}
