//
//  SwiftUIView.swift
//
//
//  Created by Matt Pfeiffer on 3/21/24.
//

import SwiftUI

public struct MetronomeRootView: View {
    @State var metronome: MetronomeConductor
    
    public init(metronome: MetronomeConductor) {
        self.metronome = metronome
    }
    
    @State private var isShowingSettings = false
    
    public var body: some View {
        let showErrorAlert = Binding<Bool>(
            get: { metronome.errorMessage != nil },
            set: { newValue in
                if !newValue {
                    metronome.errorMessage = nil
                }
            }
        )
        
        Group {
            if isShowingSettings {
                MetronomeSettingsView(soundType: $metronome.soundType, boostType: $metronome.boostType)
            } else {
                ArcKnobView(tempo: $metronome.clock.tempoBPM, bounds: 15...400, sensitivity: 4)
            }
        }
        .frame(minWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: 300)
        Button("Settings", systemImage: isShowingSettings ? "clock" : "gearshape.fill") {
            isShowingSettings.toggle()
        }
        .labelStyle(.iconOnly)
        
        Button("Play and Pause", systemImage: metronome.clock.isRunning ? "pause.fill" : "play.fill") {
            print("isRunning value: \(metronome.clock.isRunning)")
            if !metronome.clock.isRunning {
                metronome.resume()
            } else {
                metronome.pause()
            }
        }
        .labelStyle(.iconOnly)
        .alert("Error", isPresented: showErrorAlert) {
            Button("OK", action: {})
        } message: {
            Text(metronome.errorMessage ?? "Something went wrong")
        }
    }
}

#Preview {
    MetronomeRootView(metronome: MetronomeConductor())
}
