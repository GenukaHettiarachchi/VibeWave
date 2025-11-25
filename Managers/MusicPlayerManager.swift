//
//  MusicPlayerManager.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import AVFoundation
import SwiftUI
internal import Combine

class MusicPlayerManager: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var currentTrack: MusicTrack?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var volume: Float = 0.7
    
    private var audioPlayer: AVAudioPlayer?
    private var playbackTimer: Timer?
    private var playlist: [MusicTrack] = []
    private var currentIndex: Int = 0
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func loadPlaylist(tracks: [MusicTrack]) {
        playlist = tracks
        currentIndex = 0
        if !tracks.isEmpty {
            loadTrack(tracks[0])
        }
    }
    
    private func loadTrack(_ track: MusicTrack) {
        currentTrack = track
        
        // Try to load from bundle
        if let url = Bundle.main.url(forResource: track.filename, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = volume
                duration = audioPlayer?.duration ?? 0
                currentTime = 0
            } catch {
                print("Failed to load audio file: \(error)")
                // Use a fallback silent audio or generate a tone
                generateFallbackAudio()
            }
        } else {
            // Generate fallback audio if file doesn't exist
            generateFallbackAudio()
        }
    }
    
    private func generateFallbackAudio() {
        // Create a simple ambient tone as fallback
        // In a real app, you'd include actual audio files
        print("Using fallback audio for: \(currentTrack?.name ?? "unknown")")
        duration = 180.0 // 3 minutes fallback duration
        currentTime = 0
        // Don't set isPlaying here - let play() control it
    }
    
    func play() {
        if let player = audioPlayer {
            player.play()
            isPlaying = true
            startTimer()
        } else {
            // Fallback: simulate playback for demo
            isPlaying = true
            startFallbackTimer()
        }
    }
    
    func pause() {
        if let player = audioPlayer {
            player.pause()
        }
        isPlaying = false
        stopTimer()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func next() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex + 1) % playlist.count
        let wasPlaying = isPlaying
        stop()
        loadTrack(playlist[currentIndex])
        if wasPlaying {
            play()
        }
    }
    
    func previous() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex - 1 + playlist.count) % playlist.count
        let wasPlaying = isPlaying
        stop()
        loadTrack(playlist[currentIndex])
        if wasPlaying {
            play()
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        currentTime = 0
        stopTimer()
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func setVolume(_ newVolume: Float) {
        // Clamp volume between 0 and 1
        let clampedVolume = max(0.0, min(1.0, newVolume))
        volume = clampedVolume
        audioPlayer?.volume = clampedVolume
    }
    
    private func startTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
            self.duration = player.duration
        }
    }
    
    private func stopTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    private func startFallbackTimer() {
        // Simulate playback when no audio file exists
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            self.currentTime += 0.1
            if self.currentTime >= self.duration {
                self.currentTime = 0
                self.isPlaying = false
                self.stopTimer()
                // Auto-play next track
                self.next()
            }
        }
    }
}

extension MusicPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // Auto-play next track
            next()
        }
    }
}
