//
//  MusicPlayerView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct MusicPlayerView: View {
    @ObservedObject var musicPlayer: MusicPlayerManager
    @Environment(\.dismiss) var dismiss
    let mood: Mood
    
    @State private var animateAlbumArt = false
    
    var body: some View {
        ZStack {
            // Background gradient matching mood
            mood.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                Spacer()
                
                // Album art / Mood visualization
                albumArtView
                
                Spacer()
                
                // Track info
                trackInfoView
                
                // Progress bar
                progressView
                
                // Playback controls
                controlsView
                
                // Volume control
                volumeView
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Now Playing")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(mood.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding(.top)
    }
    
    // MARK: - Album Art
    private var albumArtView: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 280, height: 280)
                .scaleEffect(animateAlbumArt ? 1.1 : 1.0)
                .opacity(animateAlbumArt ? 0 : 1)
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: false),
                    value: animateAlbumArt
                )
            
            // Main circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 240, height: 240)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
            
            // Mood emoji
            Text(mood.emoji)
                .font(.system(size: 80))
                .rotationEffect(.degrees(musicPlayer.isPlaying ? 360 : 0))
                .animation(
                    musicPlayer.isPlaying ?
                        Animation.linear(duration: 10.0).repeatForever(autoreverses: false) : .default,
                    value: musicPlayer.isPlaying
                )
        }
        .onAppear { animateAlbumArt = true }
    }
    
    // MARK: - Track Info
    private var trackInfoView: some View {
        VStack(spacing: 8) {
            Text(musicPlayer.currentTrack?.name ?? "No Track")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Ambient Music")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 40)
    }
    
    // MARK: - Progress Bar
    private var progressView: some View {
        VStack(spacing: 8) {
            // Progress slider
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 6)
                    
                    // Progress
                    Capsule()
                        .fill(Color.white)
                        .frame(
                            width: geometry.size.width * CGFloat(musicPlayer.currentTime / max(musicPlayer.duration, 1)),
                            height: 6
                        )
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
                    .foregroundColor(.white.opacity(0.8))
                    .monospacedDigit()
                
                Spacer()
                
                Text(formatTime(musicPlayer.duration))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .monospacedDigit()
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Controls
    private var controlsView: some View {
        HStack(spacing: 40) {
            // Previous button
            Button(action: { musicPlayer.previous() }) {
                Image(systemName: "backward.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            // Play/Pause button
            Button(action: { musicPlayer.togglePlayPause() }) {
                Image(systemName: musicPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
            }
            
            // Next button
            Button(action: { musicPlayer.next() }) {
                Image(systemName: "forward.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 30)
    }
    
    // MARK: - Volume
    private var volumeView: some View {
        HStack(spacing: 15) {
            Image(systemName: "speaker.fill")
                .foregroundColor(.white.opacity(0.7))
            
            Slider(value: Binding(
                get: { musicPlayer.volume },
                set: { musicPlayer.setVolume($0) }
            ), in: 0...1)
            .tint(.white)
            
            Image(systemName: "speaker.wave.3.fill")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 30)
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    MusicPlayerView(
        musicPlayer: MusicPlayerManager(),
        mood: .happy
    )
}
