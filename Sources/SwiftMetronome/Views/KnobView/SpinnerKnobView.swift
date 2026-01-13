//
//  KnobView2.swift
//  SwiftMetronome
//
//  Created by Eli Pouliot on 1/10/26.
//

import SwiftUI
import OneFingerRotation
import ResizableVector

struct SpinnerKnobView: View {
    @State private var totalAngle: Double = 0.0
    @Binding var tempo: Double
    var imageName: String
    var imageBundle: Bundle? = nil
    
    init(
        tempo: Binding<Double>,
        imageName: String = "Knob18",
        imageBundle: Bundle? = Bundle.module) {
            self._tempo = tempo
            self.imageName = imageName
            
            if let imageBundle = imageBundle {
                self.imageBundle = imageBundle
            }
        }
    
    var body: some View {
        ResizableVector("Knob18", bundle: imageBundle, keepAspectRatio: true)
            .frame(minWidth: 300, minHeight: 300)
            .valueRotation(
                totalAngle: $totalAngle,
                onAngleChanged: { newAngle in
                    if tempo >= 15 && tempo <= 500 {tempo = floor(newAngle/10) + 120
                    }
                    if tempo < 15 {tempo = 15}
                    if tempo > 500 {tempo = 500}
                }
            )
    }
}

#Preview {
    StatefulPreviewWrapper(120) { value in
        SpinnerKnobView(tempo: value)
    }
    .frame(minWidth: 300, minHeight: 300)
}
