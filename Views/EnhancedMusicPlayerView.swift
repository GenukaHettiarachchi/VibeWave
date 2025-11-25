//
//  EnhancedMusicPlayerView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct EnhancedMusicPlayerView: View {
    @ObservedObject var musicPlayer: MusicPlayerManager
    @Environment(\.dismiss) var dismiss
    let mood: Mood
    
    @State private var animateElements = false
    @State private var pulseGlow = false
    @State private var showMoodFix = false
    
    var body: some View {
        ZStack {
            // Mood-based gradient background
            mood.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Spacer()
                
                // Album art / Mood visualization
                albumArtView
                
                Spacer()
                
                // Equalizer
                if musicPlayer.isPlaying {
                    EqualizerView(isPlaying: musicPlayer.isPlaying)
                        .frame(height: 80)
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 20)
                }
                
                // Track info
                trackInfoView
                    .padding(.horizontal)
                
                // Progress bar
                progressView
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                // Playback controls
                controlsView
                    .padding(.horizontal)
                    .padding(.top, 40)
                
                // Volume control
                volumeView
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                // Boost My Mood (for sad/angry)
                if mood == .sad || mood == .angry {
                    Button(action: {
                        HapticManager.shared.impact()
                        showMoodFix = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "sun.max.fill")
                                .font(.headline)
                            Text("Boost My Mood")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                        )
                        .padding(.horizontal)
                        .padding(.top, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(animateElements ? 1 : 0)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showMoodFix) {
            MoodFixView(musicPlayer: musicPlayer, mood: mood)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateElements = true
            }
            startGlowAnimation()
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Music to match your vibe 💫")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(mood.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : -20)
    }
    
    // MARK: - Album Art
    private var albumArtView: some View {
        ZStack {
            // Outer glow rings
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 240 + CGFloat(index * 40), height: 240 + CGFloat(index * 40))
                    .scaleEffect(pulseGlow ? 1.1 : 1.0)
                    .opacity(pulseGlow ? 0 : 0.6)
                    .animation(
                        Animation.easeOut(duration: 2.0)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.3),
                        value: pulseGlow
                    )
            }
            
            // Main circle with gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 240, height: 240)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 3)
                )
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            // Mood emoji - rotates when playing
            Text(mood.emoji)
                .font(.system(size: 100))
                .rotationEffect(.degrees(musicPlayer.isPlaying ? 360 : 0))
                .animation(
                    musicPlayer.isPlaying ?
                        Animation.linear(duration: 10.0).repeatForever(autoreverses: false) : .default,
                    value: musicPlayer.isPlaying
                )
        }
        .scaleEffect(animateElements ? 1 : 0.8)
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Track Info
    private var trackInfoView: some View {
        VStack(spacing: 12) {
            Text(musicPlayer.currentTrack?.name ?? "No Track")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.title3)
                Text(mood.rawValue + " Vibes")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 20)
    }
    
    // MARK: - Progress Bar
    private var progressView: some View {
        VStack(spacing: 12) {
            // Progress slider
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 6)
                    
                    // Progress fill
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * CGFloat(musicPlayer.currentTime / max(musicPlayer.duration, 1)),
                            height: 6
                        )
                        .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newTime = Double(value.location.x / geometry.size.width) * musicPlayer.duration
                            musicPlayer.seek(to: newTime)
                        }
                )
            }
            .frame(height: 6)
            
            // Time labels
            HStack {
                Text(formatTime(musicPlayer.currentTime))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .monospacedDigit()
                
                Spacer()
                
                Text(formatTime(musicPlayer.duration))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .monospacedDigit()
            }
        }
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Controls
    private var controlsView: some View {
        HStack(spacing: 50) {
            // Previous button
            ControlButton(
                icon: "backward.fill",
                size: 28,
                action: { musicPlayer.previous() }
            )
            
            // Play/Pause button (larger, glowing)
            Button(action: {
                HapticManager.shared.mediumImpact()
                musicPlayer.togglePlayPause()
            }) {
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 90, height: 90)
                        .blur(radius: 10)
                        .scaleEffect(pulseGlow ? 1.1 : 1.0)
                    
                    // Button background
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                    
                    // Icon
                    Image(systemName: musicPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(mood.primaryColor)
                        .offset(x: musicPlayer.isPlaying ? 0 : 2)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Next button
            ControlButton(
                icon: "forward.fill",
                size: 28,
                action: { musicPlayer.next() }
            )
        }
        .opacity(animateElements ? 1 : 0)
        .scaleEffect(animateElements ? 1 : 0.9)
    }
    
    // MARK: - Volume
    private var volumeView: some View {
        HStack(spacing: 15) {
            Image(systemName: "speaker.fill")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Slider(value: Binding(
                get: { musicPlayer.volume },
                set: { musicPlayer.setVolume($0) }
            ), in: 0...1)
            .tint(.white)
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func startGlowAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            pulseGlow = true
        }
    }
}

// MARK: - Control Button Component
struct ControlButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: size, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EnhancedMusicPlayerView(
        musicPlayer: MusicPlayerManager(),
        mood: .happy
    )
}

