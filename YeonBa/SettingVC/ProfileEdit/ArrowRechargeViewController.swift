import UIKit
import SnapKit
import Then

class ArrowRechargeViewController: UIViewController, Ad1ViewControllerDelegate, Ad2ViewControllerDelegate, Ad3ViewControllerDelegate {
    
    private func updateArrowCountLabel() {
        nextChargeButton.setTitle(" 남은 화살 수: \(ArrowCountManager.shared.arrowCount)개", for: .normal)
    }

    func ad3ViewControllerDidClose(_ controller: Ad3ViewController) {
        rechargeOptionButtons.forEach { button in
            button.deactivate()
        }
        ArrowCountManager.shared.incrementArrowCount(by: 5)
        updateArrowCountLabel()
    }
    
    func ad2ViewControllerDidClose(_ controller: Ad2ViewController) {
        if rechargeOptionButtons.indices.contains(1) {
            rechargeOptionButtons[1].deactivate()
        }
        if rechargeOptionButtons.indices.contains(2) {
            rechargeOptionButtons[2].activate()
        }
        ArrowCountManager.shared.incrementArrowCount(by: 5)
        updateArrowCountLabel()
    }
    
    func ad1ViewControllerDidClose(_ controller: Ad1ViewController) {
        if rechargeOptionButtons.indices.contains(0) {
            rechargeOptionButtons[0].deactivate()
        }
        if rechargeOptionButtons.indices.contains(1) {
            rechargeOptionButtons[1].activate()
        }
        ArrowCountManager.shared.incrementArrowCount(by: 5)
        updateArrowCountLabel()
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "화살 무료충전소에서 광고를 시청하면 화살 5개가 충전 됩니다. 하루에 화살 무료 충전소를 최대 3개까지 이용 가능합니다."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let rechargeStationTitleLabel = UILabel().then {
        $0.text = "화살충전소"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    private let nextChargeButton = UIButton().then {
        $0.setTitle(" 남은 화살 수: \(ArrowCountManager.shared.arrowCount)개", for: .normal)
        $0.backgroundColor = .systemPink
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "arrowProfile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    private var rechargeOptionButtons: [ChangeGradientButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupRechargeOptionButtons()
        setupLayout()
        view.layoutIfNeeded()
        updateArrowCountLabel()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "화살 충전"
    }
    
    private func setupRechargeOptionButtons() {
        rechargeOptionButtons = (0..<3).map { index in  // 0부터 시작하도록 변경
            let button = ChangeGradientButton().then {
                $0.setTitle("화살 무료 충전소 \(index + 1)", for: .normal)  // 유저에게 보이는 번호는 1부터 시작
                $0.setTitleColor(.white, for: .normal)
                $0.layer.cornerRadius = 30
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                $0.isEnabled = index == 0  // 첫 번째 버튼만 처음에 활성화
                $0.tag = index
                $0.addTarget(self, action: #selector(rechargeOptionButtonTapped), for: .touchUpInside)
                $0.applyGradient(isActive: index == 0)
            }
            return button
        }
    }
    
    private func setupLayout() {
        view.addSubview(rechargeStationTitleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nextChargeButton)
        rechargeOptionButtons.forEach(view.addSubview)
        
        rechargeStationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(62)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rechargeStationTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        nextChargeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
        
        var previousButton: UIButton?
        for button in rechargeOptionButtons {
            button.snp.makeConstraints { make in
                if let previous = previousButton {
                    make.top.equalTo(previous.snp.bottom).offset(24)
                } else {
                    make.top.equalTo(nextChargeButton.snp.bottom).offset(73)
                }
                make.centerX.equalToSuperview()
                make.width.equalTo(350)
                make.height.equalTo(80)
            }
            previousButton = button
        }
    }
    
    @objc private func rechargeOptionButtonTapped(sender: ChangeGradientButton) {
        guard let index = rechargeOptionButtons.firstIndex(of: sender) else { return }

        switch index {
        case 0:  // 첫 번째 버튼인 경우
            let ad1ViewController = Ad1ViewController()
            ad1ViewController.modalPresentationStyle = .fullScreen
            ad1ViewController.delegate = self
            self.present(ad1ViewController, animated: true, completion: nil)
        case 1:  // 두 번째 버튼인 경우
            let ad2ViewController = Ad2ViewController()
            ad2ViewController.modalPresentationStyle = .fullScreen
            ad2ViewController.delegate = self
            self.present(ad2ViewController, animated: true, completion: nil)
        case 2:  // 세 번째 버튼인 경우
            let ad3ViewController = Ad3ViewController()
            ad3ViewController.modalPresentationStyle = .fullScreen
            ad3ViewController.delegate = self
            self.present(ad3ViewController, animated: true, completion: nil)
        default:
            break
        }
    }
}
