//
//  VoiceViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/30/24.
//

import UIKit
import SnapKit
import Then

protocol VoiceViewControllerDelegate: AnyObject {
    func voiceSelectedRowAt(indexPath: Int)
}
final class VoiceViewController: UIViewController {
    private var selectedCellIndex: Int?

    weak var delegate: VoiceViewControllerDelegate?
    private let customTransitioningDelegate = VoiceDelegate()
    private var currentMode: VoiceMode
    private let titleLabel = UILabel().then {
        $0.text = "음역대"
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 26)
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    private let finishButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 15)
        $0.setTitleColor(UIColor.customgray3, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor.gray2?.cgColor
        $0.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    private let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 15)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.register(VoiceTableViewCell.self,
                           forCellReuseIdentifier: "modalCell")
        return tableView
    }()
    
    init(passMode: VoiceMode) {
        self.currentMode = passMode
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func setupInitialView() {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.bounds.height / 15
    }
    
    @objc private func finishButtonTapped() {
        // Finish 버튼을 터치했을 때의 동작
        delegate?.voiceSelectedRowAt(indexPath: self.selectedCellIndex!)
        self.dismiss(animated: true)
        
    }
    @objc private func nextButtonTapped() {
        self.dismiss(animated: true)
    }
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}
//MARK: -- 신고하기 UITableViewDelegate,UITableViewDataSource

extension VoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "modalCell",
                                                       for: indexPath) as? VoiceTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: .none)
        }
        let mode = VoiceMode.allCases[indexPath.row]
        // 이미지를 설정하여 셀에 전달
        cell.setup(label: mode.title)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        finishButton.layer.borderWidth = 2
        finishButton.layer.borderColor = UIColor.black.cgColor
        finishButton.titleLabel?.textColor = UIColor.black
        finishButton.layer.backgroundColor = UIColor.white.cgColor
        selectedCellIndex = indexPath.row
        currentMode = VoiceMode(rawValue: indexPath.row)!
        //dismissView()
    }
    
}

// MARK: 음역대 Setup Layout
extension VoiceViewController {
    private func setupView() {
        setupInitialView()
        setupTableView()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(finishButton)
        horizontalStackView.addArrangedSubview(nextButton)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(horizontalStackView.snp.top)
        }
        horizontalStackView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        
    }
}
