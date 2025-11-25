//
//  CameraPreview.swift
//  VibeWave
//
//  Placeholder camera preview. Replace with AVCaptureSession-backed view later.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let manager: CameraManager
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = manager.session
        view.videoPreviewLayer.videoGravity = .resizeAspect
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        // No-op
    }
}

final class PreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}
