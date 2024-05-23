//
//  VoiceRecordingViewController.swift
//  YeonBa
//
//  Created by jin on 3/6/24.
//

import UIKit
import Foundation
import AVFoundation
import Accelerate
import CoreML


class VoiceRecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: - UI Components
    var waveformView = WaveformView().then{
            $0.backgroundColor = .clear
        }
    
    let recordingIndicatorView = UIView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 5
        $0.isHidden = true
    }
    
    let recordingLabel = UILabel().then {
        $0.text = "녹음 중.."
        $0.isHidden = true
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 79.5
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.white.cgColor
        $0.clipsToBounds = true
    }
    
    let profileImageBGView = UIImageView().then {
        $0.layer.cornerRadius = 87.5
        $0.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 175, height: 175)
        gradientLayer.colors = [UIColor(hex: "FF8F96").cgColor, UIColor(hex: "FF2149").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // 이미지뷰의 배경으로 그라데이션 적용
        $0.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    let instructionLabel = UILabel().then {
        $0.text = "연바에게 목소리를 들려주세요!"
        $0.font = UIFont.pretendardBold(size: 26)
        $0.textAlignment = .center
    }
    
    let detailLabel = UILabel().then {
        $0.text = "녹음한 목소리로 음역대를 측정해 드려요."
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    
    let recordingTimeLabel = UILabel().then {
        $0.text = "00:00"
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textAlignment = .center
    }
    
    let recordButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        let image = UIImage(systemName: "mic.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = UIColor.primary
        $0.layer.cornerRadius = 33.5
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor(hex: "FF2149").cgColor
        $0.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    var audioRecorder: AVAudioRecorder?
    var recordingTimer: Timer?
    var recordingDuration: TimeInterval = 0
    let maxRecordingDuration: TimeInterval = 10
    let model =  try? converted_model(configuration: MLModelConfiguration())
    var result : Int?  = 1
    var voiceMode : String = "중음"
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaveformView()
        setupNavigationBar()
        setupUI()
        addSubViews()
        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup
    func setupUI() {
        setupBGColor()
        setupRecording()
    }
    // MARK: - UI Layout
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "AI 음역대 측정"
    }
    
    // MARK: - UI Layout
    func addSubViews() {
        view.addSubview(recordingIndicatorView)
        view.addSubview(recordingLabel)
        view.addSubview(profileImageBGView)
        view.addSubview(profileImageView)
        view.addSubview(instructionLabel)
        view.addSubview(detailLabel)
        view.addSubview(recordingTimeLabel)
        view.addSubview(recordButton)
        view.addSubview(waveformView)
    }
    
    func configUI() {
        recordingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        
        recordingIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(recordingLabel.snp.centerY)
            make.trailing.equalTo(recordingLabel.snp.leading).offset(-4)
            make.width.height.equalTo(10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageBGView.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(159)
        }
        
        profileImageBGView.snp.makeConstraints { make in
            make.top.equalTo(recordingLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(175)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageBGView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        recordingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
        }
        
        waveformView.snp.makeConstraints { make in
            make.top.equalTo(recordingTimeLabel.snp.bottom).offset(20) // recordingTimeLabel 아래에 위치하도록 설정
            make.leading.trailing.equalToSuperview() // 화면의 가로폭에 맞게 설정
            make.height.equalTo(54) // 원하는 높이로 설정
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(67)
        }
        
        
    }
    func setupBGColor() {
        let gradientLayer = CAGradientLayer()
        
        // 그라데이션 레이어 크기 설정
        gradientLayer.frame = self.view.bounds
        
        // 그라데이션 색상 설정 (FFFFFF와 FFE3E3을 CGColor로 변환)
        gradientLayer.colors = [UIColor(hex: "FFFFFF").cgColor, UIColor(hex: "FFE3E3").cgColor]
        
        // 그라데이션 방향 설정 (위에서 아래로)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // 그라데이션 레이어를 뷰의 백그라운드로 설정
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Actions
    func setupRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("recording.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch {
            print("Error setting up audio recording: \(error.localizedDescription)")
        }
    }
    private func startRecording() {
        // 권한
        AVAudioSession.sharedInstance().requestRecordPermission { (accepted) in
            if accepted {
                print("permission granted")
            }
        }
        // 녹음 시작
        recordingLabel.isHidden = false
        recordingIndicatorView.isHidden = false
        audioRecorder?.record()
        recordButton.backgroundColor = UIColor.clear
        recordButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        recordButton.tintColor = UIColor.primary
        // Start updating waveform view with audio level
        startRecordingTimer()
        startUpdatingWaveform()
    }
    func loadAudioFile(url: URL) -> (sampleRate: Int, data: [Float])? {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let sampleRate = Int(audioFile.fileFormat.sampleRate)
            let frameCount = Int(audioFile.length)
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(sampleRate), channels: 1, interleaved: false)!
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)) else {
                print("Failed to create AVAudioPCMBuffer")
                return nil
            }
            try audioFile.read(into: buffer)
            let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count: frameCount))
            return (sampleRate, floatArray)
        } catch {
            print("Error reading audio file: \(error.localizedDescription)")
            return nil
        }
    }

    func normalizeAndPadData(data: [Float], targetLength: Int) -> [[Float]] {
        let normalizedData = data.map { $0 / 32767.0 } // Assuming the data is 16-bit PCM
        let paddedData = Array(normalizedData.prefix(targetLength)) + Array(repeating: Float(0), count: max(0, targetLength - data.count))
        let reshapedData = stride(from: 0, to: paddedData.count, by: targetLength/8).map { Array(paddedData[$0..<$0+targetLength/8]) }
        return reshapedData
    }
    func convertNormalizedAndPaddedDataToMLMultiArray(data: [[Float]]) -> MLMultiArray? {
        let targetLength = 100000 // 목표 길이
        do {
            let mlMultiArray = try MLMultiArray(shape: [1, 8, targetLength, 1] as [NSNumber], dataType: .float32)
            let pointer = UnsafeMutablePointer<Float>(OpaquePointer(mlMultiArray.dataPointer))
            for (frameIndex, frame) in data.enumerated() {
                guard frame.count == targetLength/8 else {
                    print("Frame \(frameIndex) length is not correct.")
                    return nil
                }
                for (sampleIndex, value) in frame.enumerated() {
                    let index = frameIndex * targetLength/8 + sampleIndex
                    pointer[index] = value
                }
            }
            return mlMultiArray
        } catch {
            print("Error creating MLMultiArray: \(error.localizedDescription)")
            return nil
        }
    }
    private func stopRecording() {
        // 녹음 중지
        audioRecorder?.stop()
        stopRecordingTimer()
        if let url = try? AVAudioFile(forReading: audioRecorder!.url).url,
           let (sampleRate, data) = loadAudioFile(url: url) {
            print("Sample Rate: \(sampleRate)")
            print("Data Length: \(data.count)")
            let normalizedAndPaddedData = normalizeAndPadData(data: data, targetLength: 100000)
            print("Normalized and Padded Data:", data.count)
            if let mlMultiArray = convertNormalizedAndPaddedDataToMLMultiArray(data: normalizedAndPaddedData) {
                print("Successfully converted to MLMultiArray")
                // Use mlMultiArray as needed
                do {
                    let output = try model!.prediction(conv2d_input: mlMultiArray)
                    print(output.IdentityShapedArray.scalars)
                    result = argmax(output.IdentityShapedArray.scalars)
                    print("result: \(result)")
                    if let maxProbabilityIndex = output.IdentityShapedArray.scalars.argmax() {
                        print("Highest probability index:", maxProbabilityIndex)
                    } else {
                        print("Failed to find highest probability index")
                    }
                    switch result {
                    case 0 :
                        voiceMode = "저음"
                        SignDataManager.shared.vocalRange = voiceMode
                    case 1 :
                        voiceMode = "중음"
                        SignDataManager.shared.vocalRange = voiceMode
                    case 2 :
                        voiceMode = "고음"
                        SignDataManager.shared.vocalRange = voiceMode
                    case .none:
                        voiceMode = "중음"
                        SignDataManager.shared.vocalRange = voiceMode
                    case .some(_):
                        voiceMode = "중음"
                        SignDataManager.shared.vocalRange = voiceMode
                    }
                    print("현재 내 목소리: \(String(describing: SignDataManager.shared.vocalRange))")
                } catch {
                    print("모델 예측 도중 오류가 발생했습니다: \(error.localizedDescription)")
                }
            } else {
                print("Failed to convert normalized and padded data to MLMultiArray")
            }
        } else {
            print("Failed to load audio file")
        }
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        let image = UIImage(systemName: "mic.circle.fill", withConfiguration: imageConfig)
        recordButton.setImage(image, for: .normal)
        recordButton.backgroundColor = .white
        recordButton.tintColor = UIColor.primary
        presentPopup()
    }
    func argmax<T: Comparable>(_ array: [T]) -> Int? {
        guard !array.isEmpty else { return nil }
        
        var maxIndex = 0
        var maxValue = array[0]
        
        for (index, value) in array.enumerated() {
            if value > maxValue {
                maxIndex = index
                maxValue = value
            }
        }
        
        return maxIndex
    }
    
    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.recordingDuration += 1
            self?.updateRecordingTimeLabel()
            if self!.recordingDuration >= self!.maxRecordingDuration  {
                self?.stopRecording()
            }
        }
    }
    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        if let audioURL = audioRecorder?.url {
            print("녹음이 완료되었습니다. 녹음 파일의 URL: \(audioURL)")
        }
    }
    
    private func updateRecordingTimeLabel() {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        DispatchQueue.main.async { [weak self] in
            self?.recordingTimeLabel.text = formattedTime
        }
    }
    private func startUpdatingWaveform() {
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateAudioLevel()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func setupWaveformView() {
        waveformView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 54)
    }
    
    private func updateAudioLevel() {
        audioRecorder!.updateMeters() // Update metering levels
        let decibels = audioRecorder!.averagePower(forChannel: 0) // Get average power in decibels
        let normalizedLevel = pow(10, decibels / 20) // Normalize decibels to a value between 0 and 1
        
        DispatchQueue.main.async { [weak self] in
            self?.waveformView.update(withLevel: CGFloat(normalizedLevel))
        }
    }
    
    func presentPopup() {
        // 팝업 뷰 컨트롤러를 생성하고 모달로 띄웁니다.
        let popupViewController = VoicePopupViewcontroller(title: "연방님은 \(voiceMode)입니다!", desc: "연방님은 \(voiceMode)의 음역대를 가지고 계시군요!\n\(voiceMode)의 목소리를 이성에게 어필해 보세요!", navigation: navigationController)
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    @objc func recordButtonTapped() {
        // 권한
        AVAudioSession.sharedInstance().requestRecordPermission { (accepted) in
            if accepted {
                print("permission granted")
            }
        }
        if let recorder = audioRecorder {
            if recorder.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        }
    }
    
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        dismiss(animated: true, completion: nil)
    }
    
    
    //AI 모델 관련 코드
    
    func preprocessData(data: [Float]) -> MLMultiArray? {
        let paddedData = padData(data: data, targetLength: 800000)
        let reshapedData = reshapeData(data: paddedData, rows: 8, columns: 100000)
        return convertToMultiArray(data: reshapedData)
    }
    
    func padData(data: [Float], targetLength: Int) -> [Float] {
        var paddedData = data
        if data.count < targetLength {
            let paddingCount = targetLength - data.count
            paddedData += [Float](repeating: 0, count: paddingCount)
        }
        return paddedData
    }
    //차원 변경
    func reshapeData(data: [Float], rows: Int, columns: Int) -> [[Float]] {
        var reshapedData = [[Float]]()
        for i in 0..<rows {
            let startIndex = i * columns
            let endIndex = (i + 1) * columns
            let row = Array(data[startIndex..<endIndex])
            reshapedData.append(row)
        }
        return reshapedData
    }
    func convertAudioBufferToMLMultiArray(audioBuffer: AVAudioPCMBuffer, targetLength: Int) -> MLMultiArray? {
        guard let floatChannelData = audioBuffer.floatChannelData else {
            print("No channel data found")
            return nil
        }

        let channelData = floatChannelData[0]
        let frameLength = Int(audioBuffer.frameLength)
        
        // Create a float array with the required target length
        var audioData = [Float](repeating: 0.0, count: targetLength)
        
        // Copy the audio buffer data into the float array
        let copyLength = min(frameLength, targetLength)
        for i in 0..<copyLength {
            audioData[i] = channelData[i]
        }
        
        // Create MLMultiArray
        do {
            let mlMultiArray = try MLMultiArray(shape: [1, 8, targetLength, 1] as [NSNumber], dataType: .float32)
            
            // Fill MLMultiArray with audio data
            let pointer = UnsafeMutablePointer<Float>(OpaquePointer(mlMultiArray.dataPointer))
            for i in 0..<audioData.count {
                pointer[i] = audioData[i]
            }
            
            return mlMultiArray
        } catch {
            print("Error creating MLMultiArray: \(error.localizedDescription)")
            return nil
        }
    }
    //모델에 넣기 위한 변환
    func convertToMultiArray(data: [[Float]]) -> MLMultiArray? {
        let multiArray = try? MLMultiArray(shape: [1, 8, 100000, 1] as [NSNumber], dataType: .float32)
        let range = NSRange(location: 0, length: data.count * data[0].count)
        multiArray?.dataPointer.withMemoryRebound(to: Float.self, capacity: data.count * data[0].count) { pointer in
            pointer.assign(from: data.flatMap { $0 }, count: data.count * data[0].count)
        }
        return multiArray
    }
    func computeMFCC(audioBuffer: AVAudioPCMBuffer) -> [Float]? {
        let sampleRate = audioBuffer.format.sampleRate
        let frameLength = Int(0.025 * Double(sampleRate)) // Frame length (25ms)
        let frameStep = Int(0.01 * Double(sampleRate)) // Frame step (10ms)

        guard let audioData = audioBuffer.floatChannelData?[0] else {
            return nil
        }

        let audioDataCount = Int(audioBuffer.frameLength)

        // Debug print statements to ensure the values are correct
        print("Sample Rate: \(sampleRate)")
        print("Frame Length: \(frameLength)")
        print("Frame Step: \(frameStep)")
        print("Audio Data Count: \(audioDataCount)")

        // Split audio data into frames
        var frames = [[Float]]()
        var i = 0
        while i + frameLength <= audioDataCount {
            let frame = Array(UnsafeBufferPointer(start: audioData + i, count: frameLength))
            frames.append(frame)
            i += frameStep
        }

        // Pre-emphasis (optional)
        let preEmphasisCoeff: Float = 0.97
        var preEmphasizedFrames = frames.map { frame -> [Float] in
            var outputFrame = [Float](repeating: 0.0, count: frame.count)
            outputFrame[0] = frame[0]
            for j in 1..<frame.count {
                outputFrame[j] = frame[j] - preEmphasisCoeff * frame[j - 1]
            }
            return outputFrame
        }

        // Hamming window
        var window = [Float](repeating: 0.0, count: frameLength)
        vDSP_hamm_window(&window, vDSP_Length(frameLength), Int32(0))

        // Apply Hamming window to frames
        for i in 0..<preEmphasizedFrames.count {
            var frame = preEmphasizedFrames[i]
            vDSP_vmul(frame, 1, window, 1, &frame, 1, vDSP_Length(frameLength))
            preEmphasizedFrames[i] = frame
        }

        // DCT setup
        guard let dctSetup = vDSP_DCT_CreateSetup(nil, vDSP_Length(frameLength), vDSP_DCT_Type.II) else {
            print("Error creating DCT setup.")
            return nil
        }

        // Compute MFCCs
        var mfccs = [Float]()
        for frame in preEmphasizedFrames {
            var dctInput = frame
            var dctOutput = [Float](repeating: 0, count: frameLength)
            vDSP_DCT_Execute(dctSetup, &dctInput, &dctOutput)

            // Append first 13 coefficients (excluding the 0th coefficient)
            mfccs.append(contentsOf: dctOutput[1..<14])
        }

        return mfccs
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
extension UIFont {
    static func pretendardMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
    }
    static func pretendardBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
    static func pretendardExtraBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Pretendard-ExtraBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
extension Array where Element: Comparable {
    func argmax() -> Index? {
        return indices.max(by: { self[$0] < self[$1] })
    }
    
    func argmin() -> Index? {
        return indices.min(by: { self[$0] < self[$1] })
    }
}

extension Array {
    func argmax(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.max { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
    
    func argmin(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.min { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
}
