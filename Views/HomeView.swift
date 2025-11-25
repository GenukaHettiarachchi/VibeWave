//
//  HomeView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var audioRecorder = AudioRecorderManager()
    @StateObject private var musicPlayer = MusicPlayerManager()
    @State private var moodDetectionService = MoodDetectionService()
    
    @State private var detectedMood: Mood?
    @State private var isAnalyzing = false
    @State private var showMusicPlayer = false
    @State private var showSettings = false
    @State private var permissionDenied = false
    @State private var animateWave = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                backgroundGradient
                
                VStack(spacing: 30) {
                    // Header
                    headerView
                    
                    Spacer()
                    
                    // Main content
                    if isAnalyzing {
                        analyzingView
                    } else if let mood = detectedMood {
                        moodResultView(mood: mood)
                    } else {
                        recordingView
                    }
                    
                    Spacer()
                    
                    // Bottom action button
                    actionButton
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showMusicPlayer) {
                if let mood = detectedMood {
                    MusicPlayerView(musicPlayer: musicPlayer, mood: mood)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
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
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        Group {
            if let mood = detectedMood {
                mood.gradient
            } else {
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 1.0), value: detectedMood)
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("VibeWave")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Discover music for your mood")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
    
    // MARK: - Recording View
    private var recordingView: some View {
        VStack(spacing: 30) {
            // Animated wave icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateWave ? 1.2 : 1.0)
                    .opacity(animateWave ? 0 : 1)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false),
                        value: animateWave
                    )
                
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                Image(systemName: audioRecorder.isRecording ? "waveform" : "mic.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .symbolEffect(.pulse, isActive: audioRecorder.isRecording)
            }
            .onAppear { animateWave = true }
            
            VStack(spacing: 10) {
                Text(audioRecorder.isRecording ? "Recording..." : "Tap to Record")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if audioRecorder.isRecording {
                    Text(String(format: "%.1f / 5.0 sec", audioRecorder.recordingTime))
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .monospacedDigit()
                } else {
                    Text("Record a 5-second voice clip")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
    
    // MARK: - Analyzing View
    private var analyzingView: some View {
        VStack(spacing: 30) {
            ProgressView()
                .scaleEffect(2)
                .tint(.white)
            
            Text("Analyzing your mood...")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Using AI to detect emotions")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Mood Result View
    private func moodResultView(mood: Mood) -> some View {
        VStack(spacing: 30) {
            // Mood emoji with animation
            Text(mood.emoji)
                .font(.system(size: 100))
                .scaleEffect(animateWave ? 1.1 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                    value: animateWave
                )
            
            VStack(spacing: 10) {
                Text("You're feeling")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(mood.rawValue)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(mood.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            // Play music button
            Button(action: {
                musicPlayer.loadPlaylist(tracks: mood.musicTracks)
                musicPlayer.play()
                showMusicPlayer = true
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Play Music")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(Color(hex: "1a1a2e"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button(action: handleMainAction) {
            HStack {
                Image(systemName: getActionIcon())
                Text(getActionText())
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(getActionColor())
            .cornerRadius(15)
        }
        .disabled(isAnalyzing)
        .opacity(isAnalyzing ? 0.6 : 1.0)
    }
    
    // MARK: - Helper Methods
    private func handleMainAction() {
        if audioRecorder.isRecording {
            audioRecorder.stopRecording()
            analyzeMood()
        } else if detectedMood != nil {
            resetToRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        audioRecorder.requestPermission { granted in
            if granted {
                audioRecorder.startRecording()
            } else {
                permissionDenied = true
            }
        }
    }
    
    private func analyzeMood() {
        guard let recordingURL = audioRecorder.getRecordingURL() else { return }
        
        isAnalyzing = true
        
        moodDetectionService.detectMood(from: recordingURL) { mood in
            detectedMood = mood
            isAnalyzing = false
        }
    }
    
    private func resetToRecording() {
        withAnimation {
            detectedMood = nil
            audioRecorder.deleteRecording()
        }
    }
    
    private func getActionIcon() -> String {
        if audioRecorder.isRecording {
            return "stop.fill"
        } else if detectedMood != nil {
            return "arrow.counterclockwise"
        } else {
            return "mic.fill"
        }
    }
    
    private func getActionText() -> String {
        if audioRecorder.isRecording {
            return "Stop Recording"
        } else if detectedMood != nil {
            return "Record Again"
        } else {
            return "Start Recording"
        }
    }
    
    private func getActionColor() -> Color {
        if audioRecorder.isRecording {
            return Color.red
        } else if detectedMood != nil {
            return Color.white.opacity(0.3)
        } else {
            return Color.white.opacity(0.2)
        }
    }
}

#Preview {
    HomeView()
}

