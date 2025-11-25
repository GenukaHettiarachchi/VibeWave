//
//  GlowingRecordButton.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct GlowingRecordButton: View {
    let isRecording: Bool
    let action: () -> Void
    
    @State private var pulseAnimation = false
    @State private var glowAnimation = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer glow rings
                if isRecording {
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.red.opacity(0.6),
                                        Color.red.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 180 + CGFloat(index * 40), height: 180 + CGFloat(index * 40))
                            .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                            .opacity(pulseAnimation ? 0 : 0.8)
                            .animation(
                                Animation.easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.3),
                                value: pulseAnimation
                            )
                    }
                }
                
                // Main button circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isRecording ? 
                                [Color.red, Color.red.opacity(0.8)] :
                                [Color.white, Color.white.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                    .overlay(
                        Circle()
                            .stroke(
                                isRecording ? Color.red.opacity(0.3) : Color.white.opacity(0.5),
                                lineWidth: 4
                            )
                    )
                    .shadow(
                        color: isRecording ? .red.opacity(0.6) : .white.opacity(0.4),
                        radius: glowAnimation ? 30 : 20,
                        x: 0,
                        y: 0
                    )
                    .scaleEffect(isRecording ? 0.95 : 1.0)
                
                // Icon
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 70, weight: .medium))
                    .foregroundColor(isRecording ? .white : Color(hex: "4A5568"))
                    .symbolEffect(.bounce, value: isRecording)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            startAnimations()
        }
        .onChange(of: isRecording) { _, _ in
            startAnimations()
        }
    }
    
    private func startAnimations() {
        if isRecording {
            pulseAnimation = true
            
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                glowAnimation.toggle()
            }
        } else {
            withAnimation(.easeOut(duration: 0.3)) {
                pulseAnimation = false
                glowAnimation = false
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "4FD1C5"), Color(hex: "805AD5")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 50) {
            GlowingRecordButton(isRecording: false) {}
            GlowingRecordButton(isRecording: true) {}
        }
    }
}
