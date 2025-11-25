//
//  EnhancedHomeView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct EnhancedHomeView: View {
    @StateObject private var audioRecorder = AudioRecorderManager()
    @StateObject private var musicPlayer = MusicPlayerManager()
    @State private var moodDetectionService = MoodDetectionService()
    
    @State private var detectedMood: Mood?
    @State private var isAnalyzing = false
    @State private var showMusicPlayer = false
    @State private var showMoodFix = false
    @State private var showSettings = false
    @State private var permissionDenied = false
    @State private var animateElements = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic gradient background
                backgroundGradient
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Main content
                    mainContent
                    
                    Spacer()
                    
                    // Bottom section
                    bottomSection
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showMusicPlayer) {
                if let mood = detectedMood {
                    EnhancedMusicPlayerView(musicPlayer: musicPlayer, mood: mood)
                }
            }
            .sheet(isPresented: $showMoodFix) {
                if let mood = detectedMood {
                    MoodFixView(musicPlayer: musicPlayer, mood: mood)
                }
            }
            .sheet(isPresented: $showSettings) {
                EnhancedSettingsView()
            }
            .alert("Microphone Access Required", isPresented: $permissionDenied) {
                Button("OK", role: .cancel) { }
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("Please enable microphone access in Settings to record your voice.")
            }
            .alert("Detection Error", isPresented: $showError) {
                Button("Try Again", role: .cancel) {
                    HapticManager.shared.impact()
                    resetToRecording()
                }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    animateElements = true
                }
            }
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        Group {
            if let mood = detectedMood {
                mood.gradient
            } else {
                LinearGradient(
                    colors: [
                        Color(hex: "4FD1C5"), // Teal
                        Color(hex: "805AD5")  // Violet
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 1.2), value: detectedMood)
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("VibeWave")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(headerSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .opacity(animateElements ? 1 : 0)
            .offset(x: animateElements ? 0 : -20)
            
            Spacer()
            
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
            }
            .opacity(animateElements ? 1 : 0)
            .offset(x: animateElements ? 0 : 20)
        }
    }
    
    private var headerSubtitle: String {
        if isAnalyzing {
            return "Analyzing your vibe..."
        } else if detectedMood != nil {
            return "Your mood is detected!"
        } else {
            return "Let's catch your vibe 🎧"
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        Group {
            if isAnalyzing {
                analyzingView
            } else if let mood = detectedMood {
                moodResultView(mood: mood)
            } else {
                recordingView
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Recording View
    private var recordingView: some View {
        VStack(spacing: 40) {
            // Waveform animation
            if audioRecorder.isRecording {
                WaveformView(isRecording: audioRecorder.isRecording)
                    .frame(width: 200, height: 80)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Glowing record button
            GlowingRecordButton(
                isRecording: audioRecorder.isRecording,
                action: handleRecordAction
            )
            .opacity(animateElements ? 1 : 0)
            .scaleEffect(animateElements ? 1 : 0.8)
            
            // Instructions
            VStack(spacing: 12) {
                Text(audioRecorder.isRecording ? "Recording..." : "Tap to record your voice")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if audioRecorder.isRecording {
                    Text(String(format: "%.1f / 10.0 sec", audioRecorder.recordingTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                } else {
                    Text("(10 seconds)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .opacity(animateElements ? 1 : 0)
            .offset(y: animateElements ? 0 : 20)
        }
    }
    
    // MARK: - Analyzing View
    private var analyzingView: some View {
        VStack(spacing: 40) {
            // Animated loading indicator
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 100 + CGFloat(index * 40), height: 100 + CGFloat(index * 40))
                        .rotationEffect(.degrees(Double(index * 120)))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.2),
                            value: animateElements
                        )
                }
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .symbolEffect(.pulse)
            }
            
            VStack(spacing: 12) {
                Text("Analyzing your mood...")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Using AI to detect emotions")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    // MARK: - Mood Result View
    private func moodResultView(mood: Mood) -> some View {
        VStack(spacing: 40) {
            // Mood emoji with animated glow rings
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
                            lineWidth: 3
                        )
                        .frame(width: 200 + CGFloat(index * 50), height: 200 + CGFloat(index * 50))
                        .scaleEffect(animateElements ? 1.2 : 1.0)
                        .opacity(animateElements ? 0 : 0.6)
                        .animation(
                            Animation.easeOut(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.3),
                            value: animateElements
                        )
                }
                
                // Glow background
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                
                // Emoji
                Text(mood.emoji)
                    .font(.system(size: 120))
                    .scaleEffect(animateElements ? 1.05 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                        value: animateElements
                    )
            }
            
            VStack(spacing: 16) {
                Text("You sound")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(mood.rawValue + "!")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(mood.description)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            if detectedMood != nil {
                // Show mood fix option for sad/angry moods
                if detectedMood == .sad || detectedMood == .angry {
                    // Lift Mood button (primary for sad/angry)
                    Button(action: {
                        showMoodFix = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "sun.max.fill")
                                .font(.title2)
                            Text("Lift My Mood")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color(hex: "FFD700"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                        )
                    }
                    .scaleEffect(animateElements ? 1 : 0.95)
                    
                    // Play Matching Music button (secondary)
                    Button(action: {
                        guard let mood = detectedMood else { return }
                        musicPlayer.loadPlaylist(tracks: mood.musicTracks)
                        musicPlayer.play()
                        showMusicPlayer = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.circle")
                                .font(.headline)
                            Text("Play Matching Music")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                } else {
                    // Play Music button (primary for other moods)
                    Button(action: {
                        guard let mood = detectedMood else { return }
                        musicPlayer.loadPlaylist(tracks: mood.musicTracks)
                        musicPlayer.play()
                        showMusicPlayer = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                            Text("Play Music")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(detectedMood?.primaryColor ?? Color(hex: "805AD5"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                        )
                    }
                    .scaleEffect(animateElements ? 1 : 0.95)
                }
                
                // Try Again button (always shown)
                Button(action: resetToRecording) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.headline)
                        Text("Try Again")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.25))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    )
                }
            } else if audioRecorder.hasRecording && !audioRecorder.isRecording && !isAnalyzing {
                // Detect Mood button
                Button(action: analyzeMood) {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                        Text("Detect Mood")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(hex: "805AD5"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 20)
    }
    
    // MARK: - Helper Methods
    private func handleRecordAction() {
        HapticManager.shared.mediumImpact()
        
        if audioRecorder.isRecording {
            audioRecorder.stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        audioRecorder.requestPermission { granted in
            if granted {
                HapticManager.shared.impact()
                audioRecorder.startRecording()
            } else {
                HapticManager.shared.error()
                permissionDenied = true
            }
        }
    }
    
    private func analyzeMood() {
        guard let recordingURL = audioRecorder.getRecordingURL() else {
            showErrorAlert("Couldn't find recording. Please try again.")
            return
        }
        
        HapticManager.shared.impact()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isAnalyzing = true
        }
        
        moodDetectionService.detectMood(from: recordingURL) { mood in
            withAnimation(.easeInOut(duration: 0.5)) {
                detectedMood = mood
                isAnalyzing = false
                HapticManager.shared.success()
            }
        }
    }
    
    private func resetToRecording() {
        HapticManager.shared.impact()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            detectedMood = nil
            audioRecorder.deleteRecording()
        }
    }
    
    private func showErrorAlert(_ message: String) {
        HapticManager.shared.error()
        errorMessage = message
        showError = true
        isAnalyzing = false
    }
}

#Preview {
    EnhancedHomeView()
}

