//
//  FaceDetectionViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 4/17/24.
//

import UIKit
import AVFoundation
import Vision

class FaceDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var sequenceHandler = VNSequenceRequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 설정 및 시작
        setupCamera()
    }
    
    func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegate 메서드
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Vision 요청 생성
        let request = VNDetectFaceRectanglesRequest { [unowned self] request, error in
            guard error == nil else {
                print("Face detection error: \(error!.localizedDescription)")
                return
            }
            self.handleFaceDetectionResults(request.results)
        }
        
        // 시퀀스 핸들러 사용하여 이미지 분석
        try? sequenceHandler.perform([request], on: pixelBuffer, orientation: .leftMirrored)
    }
    
    func handleFaceDetectionResults(_ results: [Any]?) {
        guard let faceObservations = results as? [VNFaceObservation] else { return }
        
        // UI 업데이트는 메인 쓰레드에서 수행
        DispatchQueue.main.async { [unowned self] in
            self.view.layer.sublayers?.removeSubrange(1...)
            
            for face in faceObservations {
                // 카메라 피드에서 검출된 얼굴의 위치에 맞는 레이어를 추가
                let faceRect = self.transformRect(fromRect: face.boundingBox, toViewRect: self.view)
                let faceLayer = self.createFaceLayer(withRect: faceRect)
                
                self.view.layer.addSublayer(faceLayer)
            }
        }
    }
    
    func transformRect(fromRect: CGRect, toViewRect view: UIView) -> CGRect {
        let width = view.bounds.width * fromRect.size.width
        let height = view.bounds.height * fromRect.size.height
        let x = view.bounds.width * fromRect.origin.x
        let y = view.bounds.height * (1 - fromRect.origin.y) - height 
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func createFaceLayer(withRect rect: CGRect) -> CALayer {
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = rect.width / 2
        return layer
    }
}


