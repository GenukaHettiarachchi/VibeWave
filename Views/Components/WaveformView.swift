//
//  WaveformView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct WaveformView: View {
    let isRecording: Bool
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5) { index in
                    WaveformBar(
                        height: geometry.size.height,
                        phase: animationPhase,
                        index: index,
                        isRecording: isRecording
                    )
                    .offset(x: CGFloat(index - 2) * 30)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            if isRecording {
                withAnimation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                ) {
                    animationPhase = 1
                }
            }
        }
        .onChange(of: isRecording) { _, newValue in
            if newValue {
                withAnimation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                ) {
                    animationPhase = 1
                }
            } else {
                withAnimation(.easeOut(duration: 0.3)) {
                    animationPhase = 0
                }
            }
        }
    }
}

struct WaveformBar: View {
    let height: CGFloat
    let phase: CGFloat
    let index: Int
    let isRecording: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.9),
                        Color.white.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 6, height: barHeight)
            .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
    }
    
    private var barHeight: CGFloat {
        if !isRecording {
            return 20
        }
        
        let baseHeight: CGFloat = 20
        let maxHeight: CGFloat = height * 0.6
        let variation = sin(phase * .pi + CGFloat(index) * 0.5) * 0.5 + 0.5
        
        return baseHeight + (maxHeight - baseHeight) * variation
    }
}

#Preview {
    ZStack {
        Color.blue
        WaveformView(isRecording: true)
            .frame(width: 200, height: 100)
    }
}
