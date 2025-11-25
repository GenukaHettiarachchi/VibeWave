//
//  CameraManager.swift
//  VibeWave
//
//  Handles AVCaptureSession configuration and sample buffer delivery.
//

import Foundation
import AVFoundation
internal import Combine

final class CameraManager: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let videoOutput = AVCaptureVideoDataOutput()
    
    // Called on videoOutputQueue
    var onSampleBuffer: ((CMSampleBuffer) -> Void)?
    private let videoOutputQueue = DispatchQueue(label: "camera.video.output.queue")
    
    @Published var isRunning: Bool = false
    @Published var permissionDenied: Bool = false
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        default:
            permissionDenied = true
            completion(false)
        }
    }
    
    func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            // Input - prioritize front camera for face detection
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input) else {
                self.session.commitConfiguration()
                return
            }
            self.session.addInput(input)
            
            // Output - optimize for face detection
            self.videoOutput.alwaysDiscardsLateVideoFrames = false // Keep all frames for responsiveness
            self.videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey as String: 640,
                kCVPixelBufferHeightKey as String: 480
            ]
            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
            }
            self.videoOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
            
            // Optimize for face detection - orientation, mirroring, and preferred frame rate
            if let connection = self.videoOutput.connection(with: .video) {
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
                if connection.isVideoMirroringSupported {
                    connection.isVideoMirrored = true
                }
            }
            
            // Set preferred frame rate for ultra-smooth tracking
            let desiredFPS: Double = 120.0
            let desiredDuration = CMTime(value: 1, timescale: CMTimeScale(desiredFPS))
            let supportedRanges = device.activeFormat.videoSupportedFrameRateRanges
            let canSupportDesiredFPS = supportedRanges.contains { range in
                // Some devices expose a range with min/maxFrameRate. Validate desiredFPS is within it.
                return desiredFPS >= range.minFrameRate - .ulpOfOne && desiredFPS <= range.maxFrameRate + .ulpOfOne
            }
            if canSupportDesiredFPS {
                do {
                    try device.lockForConfiguration()
                    device.activeVideoMinFrameDuration = desiredDuration
                    device.activeVideoMaxFrameDuration = desiredDuration
                    device.unlockForConfiguration()
                } catch {
                    // Continue with default settings if configuration fails
                }
            }
            
            self.session.commitConfiguration()
        }
    }
    
    func startRunning() {
        sessionQueue.async {
            guard !self.session.isRunning else { return }
            self.session.startRunning()
            DispatchQueue.main.async { self.isRunning = true }
        }
    }
    
    func stopRunning() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            self.session.stopRunning()
            DispatchQueue.main.async { self.isRunning = false }
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        onSampleBuffer?(sampleBuffer)
    }
}
