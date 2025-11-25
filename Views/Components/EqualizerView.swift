//
//  EqualizerView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct EqualizerView: View {
    let isPlaying: Bool
    let barCount: Int = 7
    
    @State private var barHeights: [CGFloat] = []
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(0..<barCount, id: \.self) { index in
                EqualizerBar(
                    height: barHeights.indices.contains(index) ? barHeights[index] : 0.3,
                    isPlaying: isPlaying
                )
            }
        }
        .onAppear {
            initializeHeights()
            if isPlaying {
                startAnimation()
            }
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    private func initializeHeights() {
        barHeights = (0..<barCount).map { _ in 0.3 }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if !isPlaying {
                timer.invalidate()
                return
            }
            
            withAnimation(.easeInOut(duration: 0.15)) {
                barHeights = (0..<barCount).map { _ in
                    CGFloat.random(in: 0.2...1.0)
                }
            }
        }
    }
    
    private func stopAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            barHeights = (0..<barCount).map { _ in 0.3 }
        }
    }
}

struct EqualizerBar: View {
    let height: CGFloat
    let isPlaying: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white,
                        Color.white.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 4, height: 60 * height)
            .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
    }
}

#Preview {
    ZStack {
        Color.purple
        VStack(spacing: 40) {
            EqualizerView(isPlaying: false)
            EqualizerView(isPlaying: true)
        }
    }
}
