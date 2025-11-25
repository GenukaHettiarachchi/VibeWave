//
//  Mood.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

enum Mood: String, CaseIterable {
    case happy = "Happy"
    case calm = "Calm"
    case sad = "Sad"
    case angry = "Angry"
    case neutral = "Neutral"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .sad: return "😢"
        case .angry: return "😠"
        case .neutral: return "😐"
        }
    }
    
    // Expose the two colors used for the gradient so views can pick one safely.
    var gradientColors: [Color] {
        switch self {
        case .happy:
            return [Color(hex: "FFD700"), Color(hex: "FFA500")]
        case .calm:
            return [Color(hex: "87CEEB"), Color(hex: "4682B4")]
        case .sad:
            return [Color(hex: "708090"), Color(hex: "2F4F4F")]
        case .angry:
            return [Color(hex: "FF6347"), Color(hex: "DC143C")]
        case .neutral:
            return [Color(hex: "B0C4DE"), Color(hex: "778899")]
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // A convenient single representative color (first gradient color).
    var primaryColor: Color {
        gradientColors.first ?? .white
    }
    
    var description: String {
        switch self {
        case .happy: return "You're feeling great!"
        case .calm: return "You're in a peaceful state"
        case .sad: return "Let's lift your spirits"
        case .angry: return "Let's help you relax"
        case .neutral: return "You're feeling balanced"
        }
    }
    
    var musicTracks: [MusicTrack] {
        switch self {
        case .happy:
            return [
                MusicTrack(name: "Joyful Vibes", filename: "happy1", mood: .happy),
                MusicTrack(name: "Sunshine Day", filename: "happy2", mood: .happy),
                MusicTrack(name: "Happy Moments", filename: "happy3", mood: .happy)
            ]
        case .calm:
            return [
                MusicTrack(name: "Ocean Waves", filename: "calm1", mood: .calm),
                MusicTrack(name: "Forest Breeze", filename: "calm2", mood: .calm),
                MusicTrack(name: "Peaceful Mind", filename: "calm3", mood: .calm)
            ]
        case .sad:
            return [
                MusicTrack(name: "Rise Up", filename: "uplifting1", mood: .sad),
                MusicTrack(name: "New Beginnings", filename: "uplifting2", mood: .sad),
                MusicTrack(name: "Hope Restored", filename: "uplifting3", mood: .sad),
                MusicTrack(name: "Joyful Vibes", filename: "happy1", mood: .happy),
                MusicTrack(name: "Sunshine Day", filename: "happy2", mood: .happy)
            ]
        case .angry:
            return [
                MusicTrack(name: "Calm Waters", filename: "soothing1", mood: .angry),
                MusicTrack(name: "Inner Peace", filename: "soothing2", mood: .angry),
                MusicTrack(name: "Serenity Now", filename: "soothing3", mood: .angry),
                MusicTrack(name: "Peaceful Mind", filename: "calm3", mood: .calm),
                MusicTrack(name: "Joyful Vibes", filename: "happy1", mood: .happy)
            ]
        case .neutral:
            return [
                MusicTrack(name: "Ambient Flow", filename: "neutral1", mood: .neutral),
                MusicTrack(name: "Gentle Rhythm", filename: "neutral2", mood: .neutral),
                MusicTrack(name: "Balanced Energy", filename: "neutral3", mood: .neutral)
            ]
        }
    }
}

struct MusicTrack: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let filename: String
    let mood: Mood
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

