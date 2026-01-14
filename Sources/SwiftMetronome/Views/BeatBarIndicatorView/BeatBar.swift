//
//  BeatBar.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/10/26.
//
import SwiftUI

struct BeatBar: View {
    let hypermeterManager: HypermeterManager
    
    let isRunning: Bool
    let currentMeasure: Int
    let currentBeat: Int
    let index: Int
    
    
    let beatPadding: CGFloat = 3
    
    var beatBarHeight: Int {
        let beatType = hypermeterManager
            .hyperArray[currentMeasure][index]
        switch beatType {
        case .primary:
            return 3
        case .secondary:
            return 2
        case .tertiary:
            return 1
        case .silent:
            return 0
        case .subdivision:
            return 0
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((0..<3).reversed(), id: \.self) { barHeight in
                Rectangle()
                    .stroke(.cyan, lineWidth: beatBarHeight <= barHeight ? 1 : 0)
                    .fill(beatBarHeight > barHeight ? (isRunning && index == currentBeat ? .cyan : .white) : .black)
            }
        }
        .frame(height: 45)
        .onTapGesture {
            hypermeterManager.changeTickEventType(currentMeasure: currentMeasure, currentBeat: index)
        }
    }
}

#Preview {
    BeatBar(hypermeterManager: HypermeterManager(), isRunning: false, currentMeasure: 0, currentBeat: 0, index: 0)
}
