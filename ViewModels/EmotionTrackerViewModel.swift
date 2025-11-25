//
//  EmotionTrackerViewModel.swift
//  VibeWave
//
//  Created by Cascade on 10/30/25.
//

import Foundation
import SwiftUI
internal import Combine
import AVFoundation

final class EmotionTrackerViewModel: ObservableObject {
    @Published var currentMood: Mood = .neutral
    @Published var confidence: Double = 0.0
    @AppStorage("autoPlayMusic") var autoPlayMusic: Bool = false
    @AppStorage("captureInterval") private var captureInterval: Double = 5.0
    @Published var permissionDenied: Bool = false
    
    // 5-second interval capture system
    @Published var capturedEmotions: [CapturedEmotion] = []
    @Published var lastCapturedEmotion: CapturedEmotion?
    @Published var isCapturing: Bool = false
    @Published var nextCaptureIn: Int = 5
    
    // Timed scan state
    @Published var isScanning: Bool = false
    @Published var scanSecondsRemaining: Int = 0
    @Published var finalScanMood: Mood? = nil
    @Published var finalScanConfidence: Double = 0.0
    
    // Camera + Detection
    let cameraManager = CameraManager()
    private let detector = EmotionDetectionService()
    
    private var cancellables = Set<AnyCancellable>()
    private var demoTimer: AnyCancellable?
    private var scanTimer: AnyCancellable?
    private var captureTimer: AnyCancellable?
    
    // Throttle and smoothing
    private var lastAnalysisTime: TimeInterval = 0
    private let minAnalysisInterval: TimeInterval = 0.008 // ~120 fps
    private var recentPredictions: [(mood: Mood, conf: Double, t: TimeInterval)] = []
    private let smoothingHorizon: TimeInterval = 0.2 // seconds
    private let minConfidence: Double = 0.25
    
    // Emotion capture state
    private var currentCaptureMood: Mood = .neutral
    private var currentCaptureConfidence: Double = 0.0
    private var emotionHistory: [(mood: Mood, confidence: Double, timestamp: Date)] = []
    
    // Computed property for current capture interval
    var currentCaptureInterval: Int {
        Int(captureInterval)
    }
    
    struct CapturedEmotion: Identifiable {
        let id = UUID()
        let mood: Mood
        let confidence: Double
        let timestamp: Date
        let changed: Bool
    }
    
    // Start real-time emotion detection with improved sensitivity
    func startRealTimeDetection() {
        stopDemoUpdates()
        start5SecondCapture()
        // Ensure the session is running
        if !cameraManager.isRunning { requestCameraAndStart() }
    }
    
    // MARK: - 5-Second Interval Capture System
    
    func start5SecondCapture() {
        stop5SecondCapture()
        isCapturing = true
        nextCaptureIn = Int(captureInterval)
        
        captureTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCaptureCountdown()
            }
        
        // Initial capture
        captureEmotion()
    }
    
    func stop5SecondCapture() {
        captureTimer?.cancel()
        captureTimer = nil
        isCapturing = false
        nextCaptureIn = Int(captureInterval)
    }
    
    private func updateCaptureCountdown() {
        nextCaptureIn -= 1
        
        if nextCaptureIn <= 0 {
            captureEmotion()
            nextCaptureIn = Int(captureInterval)
        }
    }
    
    private func captureEmotion() {
        let now = Date()
        
        // Calculate dominant emotion from recent history
        let dominantEmotion = calculateDominantEmotion()
        
        // Check if emotion changed from last capture
        let changed = lastCapturedEmotion?.mood != dominantEmotion.mood
        
        // Create captured emotion record
        let capturedEmotion = CapturedEmotion(
            mood: dominantEmotion.mood,
            confidence: dominantEmotion.confidence,
            timestamp: now,
            changed: changed
        )
        
        // Update published properties
        lastCapturedEmotion = capturedEmotion
        capturedEmotions.append(capturedEmotion)
        
        // Keep only last 10 captures to prevent memory issues
        if capturedEmotions.count > 10 {
            capturedEmotions.removeFirst()
        }
        
        // Update current mood for immediate UI response
        currentMood = dominantEmotion.mood
        confidence = dominantEmotion.confidence
        
        // Clear emotion history for next interval
        emotionHistory.removeAll()
    }
    
    private func calculateDominantEmotion() -> (mood: Mood, confidence: Double) {
        guard !emotionHistory.isEmpty else {
            return (currentMood, confidence)
        }
        
        // Group emotions by type and calculate average confidence
        var emotionGroups: [Mood: [Double]] = [:]
        
        for emotion in emotionHistory {
            if emotionGroups[emotion.mood] == nil {
                emotionGroups[emotion.mood] = []
            }
            emotionGroups[emotion.mood]?.append(emotion.confidence)
        }
        
        // Find emotion with highest average confidence
        var bestEmotion: Mood = .neutral
        var bestConfidence: Double = 0.0
        
        for (mood, confidences) in emotionGroups {
            let avgConfidence = confidences.reduce(0, +) / Double(confidences.count)
            if avgConfidence > bestConfidence {
                bestEmotion = mood
                bestConfidence = avgConfidence
            }
        }
        
        return (bestEmotion, bestConfidence)
    }
    
    // MARK: - Timed Scan (e.g., 10 seconds)
    func startTimedScan(seconds: Int = 10) {
        guard !isScanning else { return }
        finalScanMood = nil
        finalScanConfidence = 0
        isScanning = true
        scanSecondsRemaining = seconds
        recentPredictions.removeAll()
        
        // Ensure the session is running
        if !cameraManager.isRunning { requestCameraAndStart() }
        
        scanTimer?.cancel()
        scanTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.scanSecondsRemaining = max(0, self.scanSecondsRemaining - 1)
                if self.scanSecondsRemaining == 0 {
                    self.finishTimedScan()
                }
            }
    }
    
    func cancelTimedScan() {
        isScanning = false
        scanTimer?.cancel()
        scanTimer = nil
    }
    
    private func finishTimedScan() {
        scanTimer?.cancel()
        scanTimer = nil
        isScanning = false
        
        // Aggregate predictions during scan window
        var scores: [Mood: Double] = [:]
        for p in recentPredictions where p.conf >= minConfidence {
            scores[p.mood, default: 0] += p.conf
        }
        if let best = scores.max(by: { $0.value < $1.value }) {
            finalScanMood = best.key
            finalScanConfidence = min(1.0, best.value / Double(max(1, recentPredictions.count)))
        } else if let last = recentPredictions.last {
            finalScanMood = last.mood
            finalScanConfidence = last.conf
        } else {
            finalScanMood = .neutral
            finalScanConfidence = 0.0
        }
    }
    
    func stopDemoUpdates() {
        demoTimer?.cancel()
        demoTimer = nil
    }
    
    // MARK: - Live Camera + Detection
    func requestCameraAndStart() {
        cameraManager.requestPermission { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.configureAndStartSession()
            } else {
                self.permissionDenied = true
            }
        }
    }
    
    private func configureAndStartSession() {
        cameraManager.configureSession()
        cameraManager.onSampleBuffer = { [weak self] buffer in
            self?.process(sampleBuffer: buffer)
        }
        cameraManager.startRunning()
    }
    
    func stopSession() {
        cameraManager.stopRunning()
        recentPredictions.removeAll()
    }
    
    func process(sampleBuffer: CMSampleBuffer) {
        let now = CACurrentMediaTime()
        if now - lastAnalysisTime < minAnalysisInterval { return }
        lastAnalysisTime = now
        
        detector.analyze(sampleBuffer: sampleBuffer) { [weak self] mood, conf in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pushPrediction(mood: mood, confidence: conf)
                self.updateSmoothedMood()
            }
        }
    }
    
    private func pushPrediction(mood: Mood, confidence: Double) {
        let ts = CACurrentMediaTime()
        recentPredictions.append((mood, confidence, ts))
        // Drop old entries
        recentPredictions.removeAll { ts - $0.t > smoothingHorizon }
        
        // Add to emotion history for 5-second capture
        if isCapturing {
            emotionHistory.append((mood: mood, confidence: confidence, timestamp: Date()))
            // Keep only last 5 seconds of history
            let fiveSecondsAgo = Date().addingTimeInterval(-5.0)
            emotionHistory.removeAll { $0.timestamp < fiveSecondsAgo }
        }
    }
    
    private func updateSmoothedMood() {
        // Only update smoothed mood if not in 5-second capture mode
        // This prevents interference with the capture system
        if !isCapturing {
            // Weight moods by confidence, choose top within horizon
            var scores: [Mood: Double] = [:]
            for p in recentPredictions where p.conf >= minConfidence {
                scores[p.mood, default: 0] += p.conf
            }
            if let best = scores.max(by: { $0.value < $1.value }) {
                currentMood = best.key
                confidence = min(1.0, best.value / Double(max(1, recentPredictions.count)))
            } else if let last = recentPredictions.last {
                currentMood = last.mood
                confidence = last.conf
            }
        }
    }
}
