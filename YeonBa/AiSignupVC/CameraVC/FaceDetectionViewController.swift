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
    var captureSession = AVCaptureSession()
    var isUsingFrontCamera = false
    var frontCameraInput: AVCaptureDeviceInput!
    var backCameraInput: AVCaptureDeviceInput!
    let cameraToggleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 설정 및 시작
        setupCamera()
        // 카메라 전환 버튼 설정
        setupCameraToggleButton()
    }
    
    func setupCamera() {
        // captureSession은 이미 전역 변수로 정의되어 있으므로 let을 제거합니다.
        captureSession.sessionPreset = .photo
        
        guard let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let backInput = try? AVCaptureDeviceInput(device: backCameraDevice),
              let frontInput = try? AVCaptureDeviceInput(device: frontCameraDevice) else {
            return
        }
        
        backCameraInput = backInput
        frontCameraInput = frontInput
        
        // 기본 카메라로 뒷면 카메라를 설정합니다.
        if captureSession.canAddInput(frontCameraInput) {
            captureSession.addInput(frontCameraInput)
        }

        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
    }
    
    func setupCameraToggleButton() {
        // 버튼 속성 설정
        cameraToggleButton.setTitle("전환", for: .normal)
        cameraToggleButton.backgroundColor = .lightGray
        cameraToggleButton.layer.cornerRadius = 10
        cameraToggleButton.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        
        // 뷰에 버튼 추가
        view.addSubview(cameraToggleButton)
        
        cameraToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraToggleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            cameraToggleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            cameraToggleButton.widthAnchor.constraint(equalToConstant: 60),
            cameraToggleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        view.bringSubviewToFront(cameraToggleButton)
    }
    // AVCaptureVideoDataOutputSampleBufferDelegate 메서드
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // 얼굴 특징을 포함한 얼굴 인식 요청 생성
        let request = VNDetectFaceLandmarksRequest { [unowned self] request, error in
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
        
        DispatchQueue.main.async { [unowned self] in
            self.view.layer.sublayers?.removeSubrange(1...)
            
            for face in faceObservations {
                let faceRect = self.transformRect(fromRect: face.boundingBox, toViewRect: self.view)
                if let landmarks = face.landmarks {
                    // 이미 landmarks가 있는지 확인했으므로 직접 사용할 수 있습니다.
                    let faceLayer = self.createFaceLayer(withRect: faceRect, landmarks: landmarks)
                    self.view.layer.addSublayer(faceLayer)
                    // 눈
                    if let leftEye = landmarks.leftEye {
                        let leftEyeLayer = self.createFeatureLayer(feature: leftEye, faceRect: faceRect, viewRect: self.view)
                        self.view.layer.addSublayer(leftEyeLayer)
                    }
                    
                    if let rightEye = landmarks.rightEye {
                        let rightEyeLayer = self.createFeatureLayer(feature: rightEye, faceRect: faceRect, viewRect: self.view)
                        self.view.layer.addSublayer(rightEyeLayer)
                    }
                    
                    // 코
                    if let nose = landmarks.nose {
                        let noseLayer = self.createFeatureLayer(feature: nose, faceRect: faceRect, viewRect: self.view)
                        self.view.layer.addSublayer(noseLayer)
                    }
                    
                    // 입
                    if let outerLips = landmarks.outerLips {
                        let outerLipsLayer = self.createFeatureLayer(feature: outerLips, faceRect: faceRect, viewRect: self.view)
                        self.view.layer.addSublayer(outerLipsLayer)
                    }
                }
            }
        }
    }
    
    
    func createFeatureLayer(feature: VNFaceLandmarkRegion2D, faceRect: CGRect, viewRect: UIView) -> CALayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        for i in 0..<feature.pointCount {
            let point = feature.normalizedPoints[i]
            let absolutePoint = CGPoint(x: CGFloat(point.x) * faceRect.width + faceRect.origin.x,
                                        y: CGFloat(1 - point.y) * faceRect.height + faceRect.origin.y)
            if i == 0 {
                path.move(to: absolutePoint)
            } else {
                path.addLine(to: absolutePoint)
            }
        }
        path.close()
        
        layer.path = path.cgPath
        layer.strokeColor = UIColor.blue.cgColor // 특징의 경계 색상
        layer.fillColor = nil // 내부 채우기 색상 없음
        layer.lineWidth = 1.0 // 경계 선 두께
        
        return layer
    }
    
    func transformRect(fromRect: CGRect, toViewRect view: UIView) -> CGRect {
        let width = view.bounds.width * fromRect.size.width
        let height = view.bounds.height * fromRect.size.height
        let x = view.bounds.width * fromRect.origin.x
        let y = view.bounds.height * (1 - fromRect.origin.y) - height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    func createFaceLayer(withRect rect: CGRect, landmarks: VNFaceLandmarks2D) -> CALayer {
        let layer = CAShapeLayer()
        layer.frame = rect

        // 얼굴 골격을 그리는 경로를 생성합니다.
        let path = CGMutablePath()
        if let faceContour = landmarks.faceContour {
            for i in 0..<faceContour.pointCount {
                let point = faceContour.normalizedPoints[i]
                if i == 0 {
                    path.move(to: CGPoint(x: point.x * rect.width + rect.origin.x, y: point.y * rect.height + rect.origin.y))
                } else {
                    path.addLine(to: CGPoint(x: point.x * rect.width + rect.origin.x, y: point.y * rect.height + rect.origin.y))
                }
            }
        }
        
        // 경로를 사용하여 얼굴 골격을 레이어에 추가합니다.
        layer.path = path
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = nil
        layer.lineWidth = 2.0

        return layer
    }
    func switchCameraInput() {
        captureSession.beginConfiguration()
        
        // 3. 새로운 카메라 입력을 세션에 추가하고 이전 입력을 제거합니다.
        let newCameraInput: AVCaptureDeviceInput
        if isUsingFrontCamera {
            newCameraInput = frontCameraInput
        } else {
            newCameraInput = backCameraInput
        }
        
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            captureSession.removeInput(currentInput)
            if captureSession.canAddInput(newCameraInput) {
                captureSession.addInput(newCameraInput)
            }
        }
        
        captureSession.commitConfiguration()
    }
    @objc func toggleCamera() {
        // 2. 버튼의 액션 메서드에서 현재 카메라의 전후면 방향을 토글합니다.
        isUsingFrontCamera = !isUsingFrontCamera
        switchCameraInput()
    }
    
}


