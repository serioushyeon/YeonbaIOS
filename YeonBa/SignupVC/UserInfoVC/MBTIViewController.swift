//
//  MBTIViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 5/9/24.
//

import UIKit
import SnapKit
import Then
//MARK: -- 6/6
protocol MBTIViewControllerDelegate: AnyObject {
    func mbtiSelected(_ mode: MbtiMode)
}

class MBTIViewController: UIViewController {
    private var selectedMode: MbtiMode?
    weak var delegate: MBTIViewControllerDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "MBTI"
        $0.textColor = UIColor.black
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 26)
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    let horizontalStackView1 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    let horizontalStackView2 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    let horizontalStackView3 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    let horizontalStackView4 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    private let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 15)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
    }
    
//    init(passMode: MbtiMode) {
//        super.init(nibName: nil, bundle: nil)
//        
//        selectedMode = passMode
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupInitialView() {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc private func mbtiButtonTapped(_ sender: UIButton) {
        guard let mode = MbtiMode(rawValue: sender.tag) else { return }
        self.selectedMode = mode
        updateButtonSelection()
        updateFinishButtonState()
    }
    
    @objc private func nextButtonTapped() {
        // Finish 버튼을 터치했을 때의 동작
        delegate?.mbtiSelected(selectedMode!)
        self.dismiss(animated: true)
    }
    private func updateButtonSelection() {
        // 모든 버튼의 선택 상태 초기화
        for case let horizontalStackView as UIStackView in verticalStackView.arrangedSubviews {
            for case let button as UIButton in horizontalStackView.arrangedSubviews {
                button.isSelected = false
                button.layer.borderColor = UIColor.customgray2?.cgColor
                button.setTitleColor(.customgray2, for: .normal)
            }
        }
        
        // 선택한 버튼만 선택 상태로 변경
        if let selectedMode = selectedMode,
           let button = findButton(for: selectedMode) {
            button.isSelected = true
            button.layer.borderColor = UIColor.primary?.cgColor
            button.setTitleColor(.primary, for: .normal) // 선택된 버튼의 텍스트 색상을 프라이머리 색상으로 변경
            nextButton.isEnabled = true
        }
    }
    private func updateFinishButtonState() {
        if selectedMode?.title == nil {
            nextButton.isEnabled = false
            nextButton.layer.backgroundColor = UIColor.gray2?.cgColor
        } else {
            nextButton.layer.borderWidth = 2
            nextButton.layer.borderColor = UIColor.black.cgColor
            nextButton.titleLabel?.textColor = UIColor.black
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    private func findButton(for mode: MbtiMode) -> UIButton? {
        for case let horizontalStackView as UIStackView in verticalStackView.arrangedSubviews {
            for case let button as UIButton in horizontalStackView.arrangedSubviews {
                if button.tag == mode.rawValue {
                    return button
                }
            }
        }
        return nil
    }
}

// MARK: mbti 버튼 Setup Layout
extension MBTIViewController {
    private func setupView() {
        setupInitialView()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(verticalStackView)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nextButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(169)
        }
        horizontalStackView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        verticalStackView.addArrangedSubview(horizontalStackView1)
        verticalStackView.addArrangedSubview(horizontalStackView2)
        verticalStackView.addArrangedSubview(horizontalStackView3)
        verticalStackView.addArrangedSubview(horizontalStackView4)
        // 버튼을 생성하고 verticalStackView에 추가합니다.
        let modes = MbtiMode.allCases
        for (index, mode) in modes.enumerated() {
            if(mode.title == nil){
                continue
            }
            let button = UIButton()
            button.setTitle(mode.title, for: .normal)
            button.setTitleColor(.customgray2, for: .normal)
            button.setTitleColor(.primary, for: .selected)
            button.titleLabel?.font = UIFont.pretendardMedium(size: 16)
            button.layer.borderColor = UIColor.customgray2?.cgColor
            button.layer.borderWidth = 1
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10
            button.tag = mode.rawValue
            button.addTarget(self, action: #selector(mbtiButtonTapped(_:)), for: .touchUpInside)
            
            // index를 통해 버튼을 적절한 verticalStackView에 추가합니다.
            if index < 4 {
                horizontalStackView1.addArrangedSubview(button)
            } else if index < 8 {
                horizontalStackView2.addArrangedSubview(button)
            } else if index < 12 {
                horizontalStackView3.addArrangedSubview(button)
            }
            else
            {
                horizontalStackView4.addArrangedSubview(button)
            }
        }
    }
}




