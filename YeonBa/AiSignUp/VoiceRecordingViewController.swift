//
//  VoiceViewController.swift
//  YeonBa
//
//  Created by jin on 5/21/24.
//
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
    //MARK: - UI Comaponents
    var waveformView = WaveformView().then{
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then{
        $0.text = "AI 음역대 측정"
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    let backButton = UIButton(type: .system).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "BackButton")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.black
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
    
    var audioEngine: AVAudioEngine!
    var audioRecorder: AVAudioRecorder?
    var recordingTimer: Timer?
    var recordingDuration: TimeInterval = 0
    let maxRecordingDuration: TimeInterval = 10
    var result : Int?  = 1
    var voiceMode : String = "중음"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaveformView()
        setupUI()
        addSubViews()
        configUI()
        setupAudioEngine()
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
            make.top.equalTo(recordingLabel.snp.bottom).offset(20)
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
    
    private func stopRecording() {
        // 녹음 중지
        audioRecorder?.stop()
        stopRecordingTimer()
        if let url = try? AVAudioFile(forReading: audioRecorder!.url).url {
            analyzeAudioFile(url: url)
        }
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        let image = UIImage(systemName: "mic.circle.fill", withConfiguration: imageConfig)
        recordButton.setImage(image, for: .normal)
        recordButton.backgroundColor = .white
        recordButton.tintColor = UIColor.primary
        presentPopup()
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
    
    func loadAudioFile(url: URL) -> AVAudioPCMBuffer? {
        let audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            print("Error loading audio file: \(error)")
            return nil
        }
        
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount) else {
            print("Unable to create PCM buffer")
            return nil
        }
        
        do {
            try audioFile.read(into: audioBuffer)
        } catch {
            print("Error reading audio file into buffer: \(error)")
            return nil
        }
        
        return audioBuffer
    }
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) -> [Float] {
        guard let channelData = buffer.floatChannelData?.pointee else {
            print("Error accessing channel data")
            return []
        }
        
        let frameLength = Int(buffer.frameLength)
        var window = [Float](repeating: 0.0, count: frameLength)
        var fftMagnitudes = [Float](repeating: 0.0, count: frameLength / 2)
        
        // Hann window 적용
        vDSP_hann_window(&window, vDSP_Length(frameLength), Int32(vDSP_HANN_NORM))
        vDSP_vmul(channelData, 1, window, 1, &window, 1, vDSP_Length(frameLength))
        
        // FFT 설정
        let log2n = vDSP_Length(round(log2(Double(frameLength))))
        guard let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2)) else {
            print("Error creating FFT setup")
            return []
        }
        
        var realBuffer = [Float](repeating: 0.0, count: frameLength)
        var imagBuffer = [Float](repeating: 0.0, count: frameLength)
        var splitComplexBuffer = DSPSplitComplex(realp: &realBuffer, imagp: &imagBuffer)
        
        window.withUnsafeBufferPointer { windowPointer in
            channelData.withMemoryRebound(to: DSPComplex.self, capacity: frameLength) { complexData in
                vDSP_ctoz(complexData, 2, &splitComplexBuffer, 1, vDSP_Length(frameLength / 2))
            }
            
            // FFT 수행
            vDSP_fft_zrip(fftSetup, &splitComplexBuffer, 1, log2n, Int32(FFT_FORWARD))
            vDSP_zvmags(&splitComplexBuffer, 1, &fftMagnitudes, 1, vDSP_Length(frameLength / 2))
        }
        
        vDSP_destroy_fftsetup(fftSetup)
        return fftMagnitudes
    }
    
    
    func calculateAverageFrequency(magnitudes: [Float], sampleRate: Double) -> Double {
        let binCount = magnitudes.count
        var totalFrequency: Double = 0.0
        var totalMagnitude: Float = 0.0
        
        for i in 0..<binCount {
            let frequency = Double(i) * sampleRate / Double(2 * binCount)
            totalFrequency += frequency * Double(magnitudes[i])
            totalMagnitude += magnitudes[i]
        }
        
        if totalMagnitude > 0 {
            return totalFrequency / Double(totalMagnitude)
        } else {
            return 0.0 // 또는 다른 값을 반환할 수 있습니다.
        }
    }
    
    func analyzeAudioFile(url: URL) {
        guard let audioBuffer = loadAudioFile(url: url) else {
            print("Failed to load audio file")
            return
        }
        
        let magnitudes = processAudioBuffer(audioBuffer)
        let sampleRate = audioBuffer.format.sampleRate
        let averageFrequency = calculateAverageFrequency(magnitudes: magnitudes, sampleRate: sampleRate) - 300
        
        print("Average Frequency: \(averageFrequency) Hz")
        
        if(SignDataManager.shared.gender == "남"){
            
            if(averageFrequency <= 100){
                voiceMode = "저음"
                SignDataManager.shared.vocalRange = voiceMode
            }
            else if(averageFrequency <= 150){
                voiceMode = "중음"
                SignDataManager.shared.vocalRange = voiceMode
            }
            else{
                voiceMode = "고음"
                SignDataManager.shared.vocalRange = voiceMode
            }
        }
        else {
            
            if(averageFrequency <= 200){
                voiceMode = "저음"
                SignDataManager.shared.vocalRange = voiceMode
            }
            else if(averageFrequency <= 250){
                voiceMode = "중음"
                SignDataManager.shared.vocalRange = voiceMode
            }
            else{
                voiceMode = "고음"
                SignDataManager.shared.vocalRange = voiceMode
            }
        }
    }
    
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        let mainMixer = audioEngine.mainMixerNode
        let eqNode = AVAudioUnitEQ(numberOfBands: 2)
        
        // Low-cut filter
        let lowCut = eqNode.bands[0]
        lowCut.filterType = .highPass
        lowCut.frequency = 100.0
        lowCut.bypass = false
        
        // High-cut filter
        let highCut = eqNode.bands[1]
        highCut.filterType = .lowPass
        highCut.frequency = 300.0
        highCut.bypass = false
        
        audioEngine.attach(eqNode)
        audioEngine.connect(inputNode, to: eqNode, format: format)
        audioEngine.connect(eqNode, to: mainMixer, format: format)
        audioEngine.connect(mainMixer, to: audioEngine.outputNode, format: format)
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
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
