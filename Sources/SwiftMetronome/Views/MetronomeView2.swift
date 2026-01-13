//
//  MetronomeView2.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/10/26.
//

import SwiftUI

public struct SpinningKnobPlayingView: View {
    @State var metronome: MetronomeConductor
    let isTempoLocked: Bool
    
    public init(metronome: MetronomeConductor, isTempoLocked: Bool) {
        self.metronome = metronome
        self.isTempoLocked = isTempoLocked
    }
    
    public var body: some View {
        let showErrorAlert = Binding<Bool>(
            get: { metronome.errorMessage != nil },
            set: { newValue in
                if !newValue {
                    metronome.errorMessage = nil
                }
            }
        )
        VStack {
            BeatBarIndicatorGrid(clock: metronome.clock)
            Divider()
            HStack{
                Button("decrease tempo", systemImage: "minus") {
                    metronome.clock.tempoBPM -= 1
                }
                .labelStyle(.iconOnly)
                Text(String(Int(metronome.clock.tempoBPM)) + " BPM")
                    .frame(alignment: .center)
                Button("increase tempo", systemImage: "plus") {
                    metronome.clock.tempoBPM += 1
                }
                .labelStyle(.iconOnly)
            }
            Divider()
            ZStack{
                SpinnerKnobView(tempo: $metronome.clock.tempoBPM)
                Button("Play and Pause", systemImage: metronome.clock.isRunning ? "pause.fill" : "play.fill") {
                    print("isRunning value: \(metronome.clock.isRunning)")
                    if !metronome.clock.isRunning {
                        metronome.resume()
                    } else {
                        metronome.pause()
                    }
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .alert("Error", isPresented: showErrorAlert) {
                    Button("OK", action: {})
                } message: {
                    Text(metronome.errorMessage ?? "Something went wrong")
                }
            }
            .frame(minWidth: 300, minHeight: 300)
            HStack{
                Button("Previous Bar") {
                    metronome.clock.queuedBar = .previous
                }
                Button("Next Bar") {
                    metronome.clock.queuedBar = .next
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    SpinningKnobPlayingView(metronome: MetronomeConductor(), isTempoLocked: false)
}
