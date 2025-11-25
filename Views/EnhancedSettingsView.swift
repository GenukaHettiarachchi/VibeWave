//
//  EnhancedSettingsView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct EnhancedSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticEnabled") private var hapticEnabled = true
    @AppStorage("autoPlayNext") private var autoPlayNext = true
    
    @State private var animateElements = false
    @State private var showAbout = false
    @State private var showPrivacy = false
    
    var body: some View {
        ZStack {
            // Light gradient with blur background
            LinearGradient(
                colors: [
                    Color(hex: "F0F9FF"),
                    Color(hex: "F5F3FF")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // App icon and title
                        appHeaderView
                            .padding(.top, 20)
                        
                        // Settings sections
                        VStack(spacing: 16) {
                            // About section
                            SettingsCard(
                                icon: "info.circle.fill",
                                iconColor: Color(hex: "60A5FA"),
                                title: "About VibeWave",
                                subtitle: "Learn more about the app",
                                action: { showAbout = true }
                            )
                            
                            // Sound Preferences
                            SettingsCard(
                                icon: "speaker.wave.3.fill",
                                iconColor: Color(hex: "A78BFA"),
                                title: "Sound Preferences",
                                subtitle: "Customize audio settings",
                                hasDisclosure: false,
                                content: {
                                    soundPreferencesContent
                                }
                            )
                            
                            // Privacy Policy
                            SettingsCard(
                                icon: "lock.shield.fill",
                                iconColor: Color(hex: "34D399"),
                                title: "Privacy Policy",
                                subtitle: "How we protect your data",
                                action: { showPrivacy = true }
                            )
                            
                            // Feedback
                            SettingsCard(
                                icon: "envelope.fill",
                                iconColor: Color(hex: "F87171"),
                                title: "Feedback",
                                subtitle: "Share your thoughts with us",
                                action: { sendFeedback() }
                            )
                        }
                        .padding(.horizontal)
                        
                        // Version number
                        versionView
                            .padding(.top, 30)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyView()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateElements = true
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Text("Settings ⚙️")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "374151"))
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(Color(hex: "6B7280"))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
            }
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : -20)
    }
    
    // MARK: - App Header
    private var appHeaderView: some View {
        VStack(spacing: 16) {
            // App icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "60A5FA"),
                                Color(hex: "A78BFA")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text("VibeWave")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "374151"))
            
            Text("Feel the music that feels you")
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
        }
        .opacity(animateElements ? 1 : 0)
        .scaleEffect(animateElements ? 1 : 0.9)
    }
    
    // MARK: - Sound Preferences Content
    private var soundPreferencesContent: some View {
        VStack(spacing: 16) {
            SettingsToggle(
                title: "Sound Effects",
                isOn: $soundEnabled,
                icon: "speaker.wave.2.fill"
            )
            
            SettingsToggle(
                title: "Haptic Feedback",
                isOn: $hapticEnabled,
                icon: "hand.tap.fill"
            )
            
            SettingsToggle(
                title: "Auto-play Next Track",
                isOn: $autoPlayNext,
                icon: "play.circle.fill"
            )
        }
        .padding(.top, 12)
    }
    
    // MARK: - Version View
    private var versionView: some View {
        VStack(spacing: 8) {
            Text("Version 1.0")
                .font(.caption)
                .foregroundColor(Color(hex: "9CA3AF"))
            
            Text("Made with ❤️ for your wellbeing")
                .font(.caption2)
                .foregroundColor(Color(hex: "D1D5DB"))
        }
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Helper Methods
    private func sendFeedback() {
        if let url = URL(string: "mailto:feedback@vibewave.app") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Settings Card Component
struct SettingsCard<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var hasDisclosure: Bool = true
    var action: (() -> Void)? = nil
    let content: () -> Content
    
    @State private var isExpanded = false
    
    private var hasCustomContent: Bool {
        !(Content.self == EmptyView.self)
    }
    
    // Action-only initializer (no custom content)
    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        hasDisclosure: Bool = true,
        action: (() -> Void)?
    ) where Content == EmptyView {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.hasDisclosure = hasDisclosure
        self.action = action
        self.content = { EmptyView() }
    }
    
    // Content initializer (expandable)
    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        hasDisclosure: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.hasDisclosure = hasDisclosure
        self.action = action
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                if hasCustomContent {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } else if let action = action {
                    action()
                }
            }) {
                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(iconColor.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(iconColor)
                    }
                    
                    // Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(Color(hex: "374151"))
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    
                    Spacer()
                    
                    // Disclosure indicator
                    if hasDisclosure || hasCustomContent {
                        Image(systemName: hasCustomContent ? (isExpanded ? "chevron.up" : "chevron.down") : "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                }
                .padding(20)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable content
            if hasCustomContent, isExpanded {
                content()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
}

// MARK: - Settings Toggle Component
struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color(hex: "374151"))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "60A5FA"))
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "F0F9FF"), Color(hex: "F5F3FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("About VibeWave")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "374151"))
                        
                        VStack(alignment: .leading, spacing: 16) {
                            AboutSection(
                                icon: "waveform",
                                title: "What is VibeWave?",
                                description: "VibeWave is an innovative app that detects your mood through voice analysis and recommends music to match or improve your emotional state."
                            )
                            
                            AboutSection(
                                icon: "brain.head.profile",
                                title: "How it Works",
                                description: "Using advanced AI technology, we analyze your voice patterns to understand your current mood and suggest the perfect music for you."
                            )
                            
                            AboutSection(
                                icon: "heart.fill",
                                title: "Our Mission",
                                description: "We believe music has the power to heal, uplift, and transform. Our goal is to make emotional wellbeing accessible through personalized music experiences."
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AboutSection: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "60A5FA"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "374151"))
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "6B7280"))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Privacy View
struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "F0F9FF"), Color(hex: "F5F3FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "374151"))
                        
                        VStack(alignment: .leading, spacing: 20) {
                            PrivacySection(
                                title: "Your Data is Safe",
                                content: "All voice recordings are processed locally on your device and are never uploaded to our servers."
                            )
                            
                            PrivacySection(
                                title: "No Personal Information",
                                content: "We don't collect any personal information. Your mood data stays on your device."
                            )
                            
                            PrivacySection(
                                title: "Microphone Access",
                                content: "We only access your microphone when you tap the record button. You can revoke this permission anytime in Settings."
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct PrivacySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(Color(hex: "34D399"))
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "374151"))
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    EnhancedSettingsView()
}
