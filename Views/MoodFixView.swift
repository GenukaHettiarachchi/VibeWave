//
//  MoodFixView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct MoodFixView: View {
    @ObservedObject var musicPlayer: MusicPlayerManager
    @Environment(\.dismiss) var dismiss
    let mood: Mood
    
    @State private var animateElements = false
    @State private var selectedTrack: MusicTrack?
    
    // Uplifting affirmations for each track
    private let affirmations = [
        "Every moment is a fresh beginning 🌅",
        "You are stronger than you think 💪",
        "Better days are coming your way ✨",
        "This too shall pass, and you'll grow 🌱",
        "You deserve happiness and peace 🕊️",
        "Small steps lead to big changes 🌟",
        "Let happiness fill your heart 💛",
        "Choose joy, it's always within you 😊"
    ]
    
    var body: some View {
        ZStack {
            // Light pastel gradient background
            LinearGradient(
                colors: [
                    Color(hex: "B8E6F6"), // Pastel blue
                    Color(hex: "E0BBE4")  // Lavender
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
                    VStack(spacing: 30) {
                        // Empathetic message
                        messageView
                            .padding(.top, 20)
                        
                        // Suggested tracks (show top 3)
                        VStack(spacing: 20) {
                            ForEach(Array(mood.musicTracks.prefix(3).enumerated()), id: \.element.id) { index, track in
                                TrackSuggestionCard(
                                    track: track,
                                    affirmation: affirmations[index % affirmations.count],
                                    isSelected: selectedTrack?.id == track.id,
                                    isPlaying: musicPlayer.isPlaying && musicPlayer.currentTrack?.id == track.id,
                                    action: {
                                        playTrack(track)
                                    }
                                )
                                .opacity(animateElements ? 1 : 0)
                                .offset(y: animateElements ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateElements)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Encouraging note
                        encouragingNote
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                    }
                }
            }
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
            
            Spacer()
        }
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Message View
    private var messageView: some View {
        VStack(spacing: 16) {
            // Sun icon with glow
            ZStack {
                Circle()
                    .fill(Color(hex: "FFD700").opacity(0.3))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: "FFD700"))
                    .symbolEffect(.pulse)
            }
            
            Text("Let's lift your mood 🌤️")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "374151"))
                .multilineTextAlignment(.center)
            
            Text("Here are some uplifting tracks to brighten your day")
                .font(.title3)
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .opacity(animateElements ? 1 : 0)
        .scaleEffect(animateElements ? 1 : 0.9)
    }
    
    // MARK: - Encouraging Note
    private var encouragingNote: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundColor(Color(hex: "F87171"))
            
            Text("Remember, it's okay to feel this way.")
                .font(.headline)
                .foregroundColor(Color(hex: "374151"))
            
            Text("Music can help, but reaching out to someone you trust can make a real difference.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.7))
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
        .padding(.horizontal)
        .opacity(animateElements ? 1 : 0)
    }
    
    // MARK: - Helper Methods
    private func playTrack(_ track: MusicTrack) {
        selectedTrack = track
        musicPlayer.loadPlaylist(tracks: [track])
        musicPlayer.play()
    }
}

// MARK: - Track Suggestion Card
struct TrackSuggestionCard: View {
    let track: MusicTrack
    let affirmation: String
    let isSelected: Bool
    let isPlaying: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
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
            HStack(spacing: 16) {
                // Thumbnail with icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
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
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: isPlaying ? "waveform" : "music.note")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                        .symbolEffect(.pulse, isActive: isPlaying)
                }
                
                // Track info
                VStack(alignment: .leading, spacing: 8) {
                    Text(track.name)
                        .font(.headline)
                        .foregroundColor(Color(hex: "374151"))
                    
                    Text(affirmation)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "6B7280"))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Play indicator
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(hex: "60A5FA"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ? Color(hex: "60A5FA") : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MoodFixView(
        musicPlayer: MusicPlayerManager(),
        mood: .sad
    )
}
