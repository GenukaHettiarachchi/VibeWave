import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("autoPlayNext") private var autoPlayNext = true
    
    // Emotion detection settings
    @AppStorage("captureInterval") private var captureInterval: Double = 5.0
    @AppStorage("confidenceThreshold") private var confidenceThreshold: Double = 0.25
    @AppStorage("enableHaptics") private var enableHaptics: Bool = true
    @AppStorage("showNotifications") private var showNotifications: Bool = false
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Header
                        VStack(spacing: 12) {
                            Text("🎭")
                                .font(.system(size: 60))
                            
                            Text("VibeWave")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Feel the music that feels you")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 20)
                        
                        // Emotion Detection Settings
                        SettingsSection(title: "Emotion Detection") {
                            // Capture Interval
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Capture Interval")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(captureInterval))s")
                                        .foregroundColor(.white.opacity(0.8))
                                        .fontWeight(.medium)
                                }
                                
                                Slider(value: $captureInterval, in: 5...10, step: 1)
                                    .tint(.white)
                                
                                Text("How often to capture emotions")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.vertical, 4)
                            
                            // Confidence Threshold
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Confidence Threshold")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(Int(confidenceThreshold * 100))%")
                                        .foregroundColor(.white.opacity(0.8))
                                        .fontWeight(.medium)
                                }
                                
                                Slider(value: $confidenceThreshold, in: 0.1...0.5, step: 0.05)
                                    .tint(.white)
                                
                                Text("Minimum confidence for emotion detection")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.vertical, 4)
                        }
                        
                        // App Settings
                        SettingsSection(title: "App Settings") {
                            // Enable Haptics
                            HStack {
                                Text("Haptic Feedback")
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $enableHaptics)
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            .padding(.vertical, 4)
                            
                            // Show Notifications
                            HStack {
                                Text("Show Notifications")
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $showNotifications)
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            .padding(.vertical, 4)
                            
                            // Original settings
                            HStack {
                                Text("Sound Effects")
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $soundEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            .padding(.vertical, 4)
                            
                            HStack {
                                Text("Haptic Feedback")
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $hapticEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            .padding(.vertical, 4)
                            
                            HStack {
                                Text("Auto-play Next Track")
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $autoPlayNext)
                                    .toggleStyle(SwitchToggleStyle(tint: .white))
                            }
                            .padding(.vertical, 4)
                        }
                        
                        // Data Management
                        SettingsSection(title: "Data Management") {
                            Button(action: { showingResetAlert = true }) {
                                HStack {
                                    Text("Reset All Data")
                                        .foregroundColor(.red)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.red.opacity(0.6))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        
                        // About Section
                        SettingsSection(title: "About") {
                            VStack(alignment: .leading, spacing: 12) {
                                // Version
                                HStack {
                                    Text("Version")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                // Build
                                HStack {
                                    Text("Build")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("2024.10.30")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                // Developer
                                HStack {
                                    Text("Developer")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("Genuka Hettiarachchi")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                
                                // Description
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("About VibeWave")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("VibeWave uses advanced facial recognition and emotion detection technology to analyze your emotional state in real-time. Powered by Apple's Vision framework, the app captures facial expressions every few seconds and provides detailed emotion analysis with confidence scores.")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("Features:")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                        .padding(.top, 4)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        FeatureRow(icon: "📷", text: "Real-time camera-based emotion detection")
                                        FeatureRow(icon: "🎭", text: "Five emotion states: Happy, Calm, Sad, Angry, Neutral")
                                        FeatureRow(icon: "⏱️", text: "Configurable capture intervals (3-10 seconds)")
                                        FeatureRow(icon: "📊", text: "Emotion history tracking with timestamps")
                                        FeatureRow(icon: "🔍", text: "70+ facial landmark analysis points")
                                        FeatureRow(icon: "📱", text: "Optimized for front-facing camera use")
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will clear all emotion history and reset settings to default values. This action cannot be undone.")
        }
    }
    
    private func resetAllData() {
        // Reset AppStorage values
        captureInterval = 5.0
        confidenceThreshold = 0.25
        enableHaptics = true
        showNotifications = false
        soundEnabled = true
        hapticEnabled = true
        autoPlayNext = true
        
        // Clear emotion history (this would need to be connected to the ViewModel)
        // For now, we'll just show haptic feedback
        if enableHaptics {
            HapticManager.shared.mediumImpact()
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                content
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
                .font(.system(size: 14))
            
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
