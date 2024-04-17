//
//  PhotoSelectionViewController.swift
//  YeonBa
//
//  Created by jin on 3/14/24.
//

import UIKit
import SnapKit
import Then
import Charts
import AVFoundation
import Photos
import PhotosUI

class PhotoSelectionViewController: UIViewController, PhotoPlaceholderViewDelegate {
    
    // MARK: - UI Components
    
    let backButton = UIButton(type: .system).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "BackButton")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.black
    }
    
    let instructionLabel = UILabel().then {
        $0.text = "회원님의 사진 2장을 선택해 주세요."
        $0.font = UIFont.pretendardBold(size: 26)
        $0.numberOfLines = 0
    }
    
    let subInstructionLabel = UILabel().then {
        $0.text = "업로드한 사진과 셀카의 유사도를 분석하는 단계입니다. 사진 등록 가이드를 참고하시고 사진을 골라 주세요."
        $0.textColor = UIColor(hex: "616161")
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.numberOfLines = 0
    }
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    let photoPlaceholderView = PhotoPlaceholderView().then {
        $0.setHintText("대표")
    }
    
    let essentialPlaceHolderView = PhotoEssentialView().then {
        $0.setHintText("필수")
    }
    
    let addButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "AddProfileImage")
        $0.setImage(image, for: .normal)
    }
    
    let deleteIcon = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "DeleteIcon")
        $0.setImage(image, for: .normal)
    }
    
    let progressCircleView = PieChartView()
    
    let similarityLabel = UILabel().then {
        $0.text = "0/2"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 18)
    }
    
    let photoGuideButton = UIButton().then {
        $0.setTitle("사진 등록 가이드 >", for: .normal)
        $0.backgroundColor = .secondary
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 20
    }
    
    let goToCameraButton = UIButton().then {
        $0.setTitle("셀카 찍으러 가기", for: .normal)
        $0.setTitleColor(UIColor(hex: "616161"), for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.backgroundColor = UIColor(hex: "EFEFEF")
        $0.layer.cornerRadius = 20
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configUI()
        setupActions()
        setupInitialPieChart()
        photoPlaceholderView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - UI Layout
    private func addSubViews(){
        // Add subviews
        [backButton, instructionLabel, subInstructionLabel, horizontalStackView, progressCircleView, photoGuideButton, goToCameraButton, addButton, deleteIcon, similarityLabel].forEach {
            view.addSubview($0)
        }
        horizontalStackView.addArrangedSubview(photoPlaceholderView)
        horizontalStackView.addArrangedSubview(essentialPlaceHolderView)
    }
    
    private func configUI() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(57)
            make.leading.equalToSuperview().offset(21)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(139)
            make.leading.equalToSuperview().offset(20)
        }
        
        subInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(10)
            make.leading.equalTo(instructionLabel.snp.leading)
            make.width.equalTo(300)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(subInstructionLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(210)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(photoPlaceholderView.snp.top).offset(-12.5)
            make.right.equalTo(photoPlaceholderView.snp.right).offset(12.5)
        }
        
        deleteIcon.snp.makeConstraints { make in
            make.top.equalTo(essentialPlaceHolderView.snp.top).offset(-12.5)
            make.right.equalTo(essentialPlaceHolderView.snp.right).offset(12.5)
        }
        
        progressCircleView.snp.makeConstraints { make in
            make.top.equalTo(essentialPlaceHolderView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        similarityLabel.snp.makeConstraints { make in
            make.top.equalTo(essentialPlaceHolderView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        photoGuideButton.snp.makeConstraints { make in
            make.top.equalTo(progressCircleView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(46)
            make.width.equalTo(146)
        }
        
        goToCameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    // MARK: - Setup
    func updateAddButton() {
        addButton.isHidden = true
    }
    func didUpdatePhotoCount(_ count: Int, total: Int) {
        similarityLabel.text = "\(count)/\(total)"
    }
    
    func setupInitialPieChart() {
        let entries = [PieChartDataEntry(value: 100)]
        let dataSet = PieChartDataSet(entries: entries)
        if let grayColor = UIColor(named: "gray2") {
            let nsGrayColor = NSUIColor(cgColor: grayColor.cgColor)
            dataSet.colors = [nsGrayColor]
        }
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        let data = PieChartData(dataSet: dataSet)
        progressCircleView.data = data
        progressCircleView.holeRadiusPercent = 0.8
        progressCircleView.holeColor = UIColor.clear
        progressCircleView.legend.enabled = false
    }
    // MARK: - SetupPieChart
    func updatePieChart(with percentage: Double) {
        let remainingValue = 100 - percentage
        let entries = [
            PieChartDataEntry(value: percentage),
            PieChartDataEntry(value: remainingValue)
        ]
        
        let dataSet = PieChartDataSet(entries: entries)
        if let customPinkColor = UIColor.primary,
           let otherColor = UIColor(named: "gray2") {
            let nsCustomPinkColor = NSUIColor(cgColor: customPinkColor.cgColor)
            let nsOtherColor = NSUIColor(cgColor: otherColor.cgColor)
            dataSet.colors = [nsCustomPinkColor, nsOtherColor]
        }
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        let data = PieChartData(dataSet: dataSet)
        progressCircleView.holeRadiusPercent = 0.8
        progressCircleView.holeColor = UIColor.clear // 배경색을 투명하게 설정
        progressCircleView.data = data
        progressCircleView.legend.enabled = false
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
        photoGuideButton.addTarget(self, action: #selector(didTapPhotoGuide), for: .touchUpInside)
        goToCameraButton.addTarget(self, action: #selector(didTapGoToCamera), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapAddPhoto() {
        // Handle add photo action
    }
    
    @objc func didTapPhotoGuide() {
        let guideVC = GuideViewController()
        navigationController?.pushViewController(guideVC, animated: true)
    }
    
    @objc func didTapGoToCamera() {
        let AnaysisSyncVC = AnalysisSyncViewController()
        navigationController?.pushViewController(AnaysisSyncVC, animated: true)
    }
}

class DottedBorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.addDottedBorder()
    }
}

extension CALayer {
    func addDottedBorder() {
        // 새로운 CAShapeLayer를 생성하기 전에 기존의 dotted layer를 제거합니다.
        sublayers?.filter { $0.name == "dotted" }.forEach { $0.removeFromSuperlayer() }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "dotted"
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineDashPattern = [5,5]
        shapeLayer.frame = bounds
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        addSublayer(shapeLayer)
    }
}
