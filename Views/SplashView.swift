//
//  SplashView.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import SwiftUI

struct SplashView: View {
    @State private var animateGradient = false
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            if showMainApp {
                LiveEmotionDetectionView()
                    .transition(.opacity)
            } else {
                splashContent
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: showMainApp)
    }
    
    private var splashContent: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground(animate: $animateGradient)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo with wave icon
                logoView
                
                // App title
                Text("VibeWave")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(animateText ? 1 : 0)
                    .scaleEffect(animateText ? 1 : 0.8)
                
                // Tagline
                Text("Feel the music that feels you.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                Spacer()
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private var logoView: some View {
        ZStack {
            // Outer glow rings
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140 + CGFloat(index * 30), height: 140 + CGFloat(index * 30))
                    .scaleEffect(animateLogo ? 1.2 : 0.8)
                    .opacity(animateLogo ? 0 : 0.6)
                    .animation(
                        Animation.easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: animateLogo
                    )
            }
            
            // Main logo circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 140)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 3)
                )
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
            
            // Wave icon
            Image(systemName: "waveform")
                .font(.system(size: 60, weight: .medium))
                .foregroundColor(.white)
                .symbolEffect(.pulse, options: .repeating, value: animateLogo)
        }
        .scaleEffect(animateLogo ? 1 : 0.5)
        .opacity(animateLogo ? 1 : 0)
    }
    
    private func startAnimations() {
        // Start gradient animation immediately
        animateGradient = true
        
        // Logo animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
            animateLogo = true
        }
        
        // Text animation
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            animateText = true
        }
        
        // Transition to main app after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showMainApp = true
        }
    }
}

// Animated gradient background component
struct AnimatedGradientBackground: View {
    @Binding var animate: Bool
    @State private var gradientRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color(hex: "B8E6F6"), // Pastel blue
                    Color(hex: "C8B6E2"), // Purple
                    Color(hex: "FFB6C1")  // Pink
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated overlay gradients
            LinearGradient(
                colors: [
                    Color(hex: "E0BBE4").opacity(0.6), // Lavender
                    Color(hex: "FFDFD3").opacity(0.6), // Peach
                    Color(hex: "C7CEEA").opacity(0.6)  // Periwinkle
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .animation(
                Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                value: animate
            )
            
            // Subtle shimmer effect
            LinearGradient(
                colors: [
                    Color.white.opacity(0.1),
                    Color.clear,
                    Color.white.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .rotationEffect(.degrees(gradientRotation))
            .animation(
                Animation.linear(duration: 8.0).repeatForever(autoreverses: false),
                value: gradientRotation
            )
            .onAppear {
                gradientRotation = 360
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
