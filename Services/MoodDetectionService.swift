//
//  MoodDetectionService.swift
//  VibeWave
//
//  Created by udesh olith ekanayake on 10/30/25.
//

import Foundation
import AVFoundation

class MoodDetectionService {
    
    // Simulates CoreML mood detection
    // In a real app, you would use a trained CoreML model for audio emotion recognition
    func detectMood(from audioURL: URL, completion: @escaping (Mood) -> Void) {
        // Simulate processing time
        DispatchQueue.global(qos: .userInitiated).async {
            // Analyze audio characteristics (simulated)
            let mood = self.analyzeMood(audioURL: audioURL)
            
            // Simulate processing delay
            Thread.sleep(forTimeInterval: 1.5)
            
            DispatchQueue.main.async {
                completion(mood)
            }
        }
    }
    
    private func analyzeMood(audioURL: URL) -> Mood {
        // In a real implementation, this would:
        // 1. Extract audio features (pitch, energy, tempo, spectral features)
        // 2. Feed features to a CoreML model
        // 3. Return the predicted mood
        
        // For demo purposes, we'll use a simple random selection with weighted probabilities
        // You can also analyze basic audio properties like amplitude and frequency
        
        do {
            let audioFile = try AVAudioFile(forReading: audioURL)
            let format = audioFile.processingFormat
            let frameCount = UInt32(audioFile.length)
            
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                return randomMood()
            }
            
            try audioFile.read(into: buffer)
            
            // Analyze audio energy (simplified)
            let channelData = buffer.floatChannelData?[0]
            var totalEnergy: Float = 0
            
            for i in 0..<Int(buffer.frameLength) {
                if let sample = channelData?[i] {
                    totalEnergy += abs(sample)
                }
            }
            
            let averageEnergy = totalEnergy / Float(buffer.frameLength)
            
            // Simple heuristic based on energy levels
            // Higher energy might indicate happy/angry, lower energy might indicate calm/sad
            if averageEnergy > 0.3 {
                return Bool.random() ? .happy : .angry
            } else if averageEnergy > 0.15 {
                return Bool.random() ? .neutral : .calm
            } else {
                return Bool.random() ? .calm : .sad
            }
            
        } catch {
            print("Error analyzing audio: \(error)")
            return randomMood()
        }
    }
    
    private func randomMood() -> Mood {
        // Weighted random selection for demo
        let random = Int.random(in: 1...100)
        
        switch random {
        case 1...25:
            return .happy
        case 26...50:
            return .calm
        case 51...70:
            return .neutral
        case 71...85:
            return .sad
        default:
            return .angry
        }
    }
    
    // Advanced feature: Analyze specific audio characteristics
    private func extractAudioFeatures(from buffer: AVAudioPCMBuffer) -> [String: Float] {
        guard let channelData = buffer.floatChannelData?[0] else {
            return [:]
        }
        
        var features: [String: Float] = [:]
        let frameLength = Int(buffer.frameLength)
        
        // Calculate RMS (Root Mean Square) - energy
        var sumSquares: Float = 0
        for i in 0..<frameLength {
            let sample = channelData[i]
            sumSquares += sample * sample
        }
        features["rms"] = sqrt(sumSquares / Float(frameLength))
        
        // Calculate Zero Crossing Rate - indicates pitch/frequency changes
        var zeroCrossings = 0
        for i in 1..<frameLength {
            if (channelData[i] >= 0 && channelData[i-1] < 0) ||
               (channelData[i] < 0 && channelData[i-1] >= 0) {
                zeroCrossings += 1
            }
        }
        features["zcr"] = Float(zeroCrossings) / Float(frameLength)
        
        return features
    }
}
