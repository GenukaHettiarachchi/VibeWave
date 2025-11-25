//
//  LiveEmotionDetectionView.swift
//  VibeWave
//
//  Created by Cascade on 10/30/25.
//

import SwiftUI

struct LiveEmotionDetectionView: View {
    @StateObject private var viewModel = EmotionTrackerViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        ZStack {
            // Adaptive gradient background
            viewModel.currentMood.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                header
                    .padding(.top, 8)
                    .padding(.horizontal)
                
                // Camera preview area with face overlay box
                ZStack {
                    CameraPreview(manager: viewModel.cameraManager)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        .frame(height: 360)
                        .padding(.horizontal)
                    
                    // Simulated face box overlay
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                        .frame(width: 180, height: 120)
                        .opacity(0.9)
                }
                .padding(.top, 12)
                
                // Real-time mood label with 5-second capture info
                VStack(spacing: 6) {
                    HStack {
                        Text("Capturing emotions every \(viewModel.currentCaptureInterval) seconds")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.95))
                        
                        Spacer()
                        
                        // Countdown timer
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(viewModel.nextCaptureIn)s")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                    
                    // Current captured emotion display
                    if let lastCaptured = viewModel.lastCapturedEmotion {
                        HStack(spacing: 12) {
                            Text(lastCaptured.mood.emoji)
                                .font(.title)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lastCaptured.mood.rawValue)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 8) {
                                    Text(lastCaptured.changed ? "Emotion changed!" : "Same emotion")
                                        .font(.caption)
                                        .foregroundColor(lastCaptured.changed ? .yellow : .white.opacity(0.8))
                                    
                                    Text("•")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                    
                                    Text("\(Int(lastCaptured.confidence * 100))% confidence")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: lastCaptured.changed ? 
                                    [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)] :
                                    [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        HStack(spacing: 8) {
                            Text("🎭")
                                .font(.title)
                            
                            Text("Waiting for first capture...")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 6)
                
                // Captured emotions timeline
                if !viewModel.capturedEmotions.isEmpty {
                    VStack(spacing: 8) {
                        Text("Recent Captures")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.capturedEmotions.suffix(5)) { emotion in
                                    VStack(spacing: 4) {
                                        Text(emotion.mood.emoji)
                                            .font(.title2)
                                        
                                        Text(emotion.changed ? "🔄" : "•")
                                            .font(.caption2)
                                            .foregroundColor(emotion.changed ? .yellow : .white.opacity(0.6))
                                        
                                        Text("\(Int(emotion.confidence * 100))%")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(emotion.changed ? Color.yellow.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                }
                
                // Controls
                VStack(spacing: 16) {
                    // Start 10s scan button
                    Button(action: { HapticManager.shared.mediumImpact(); viewModel.startTimedScan(seconds: 10) }) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.aperture")
                                .font(.title3)
                            Text("Start 10‑sec Emotion Scan")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                        )
                        .padding(.horizontal)
                    }
                    .disabled(viewModel.isScanning)
                    .opacity(viewModel.isScanning ? 0.6 : 1.0)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            // Countdown overlay
            if viewModel.isScanning {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 160, height: 160)
                            .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 3))
                        Text("\(viewModel.scanSecondsRemaining)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Text("Hold steady, we’re reading your vibe…")
                        .foregroundColor(.white.opacity(0.95))
                        .font(.headline)
                }
                .padding()
                .transition(.opacity)
            }
            
            // Final result card
            if let resultMood = viewModel.finalScanMood {
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            Text(resultMood.emoji)
                                .font(.largeTitle)
                            Text("Detected: \(resultMood.rawValue)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.18))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear { viewModel.startRealTimeDetection() }
        .onDisappear { viewModel.stopSession() }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .alert("Camera Access Required", isPresented: $viewModel.permissionDenied) {
            Button("OK", role: .cancel) {}
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("Please enable camera access in Settings to detect your emotion in real time.")
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("VibeWave")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Feel the music that feels you.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            Spacer()
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
    
    private func realTimeLabel(for mood: Mood) -> String {
        switch mood {
        case .happy: return "You look Happy 😊"
        case .calm: return "You look Calm 😌"
        case .sad: return "You look Sad 😢"
        case .angry: return "You look Angry 😠"
        case .neutral: return "You look Neutral 🙂"
        }
    }
}

#Preview {
    LiveEmotionDetectionView()
}
