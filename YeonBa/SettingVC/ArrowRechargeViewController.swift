import UIKit
import SnapKit
import Then

class ArrowRechargeViewController: UIViewController {
    
    // MARK: - UI Components
    private let descriptionLabel = UILabel().then {
        $0.text = "화살 무료충전소에서 광고를 시청하면 화살 5개가 충전 됩니다. 하루에 화살 무료 충전소를 최대 3개까지 이용 가능합니다."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    private let rechargeStationTitleLabel = UILabel().then {
        $0.text = "화살충전소"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold) // Adjust the size and weight as needed
    }
    
    
    private let nextChargeButton = UIButton().then {
        $0.setTitle("남은 화살 수: 31개", for: .normal)
        $0.backgroundColor = .systemPink
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        // Set the button action
        $0.addTarget(self, action: #selector(nextChargeButtonTapped), for: .touchUpInside)
    }
    
    // Assuming you have custom button styles
    private let rechargeOptionButtons = (1...3).map { index in
        ActualGradientButton().then {
            $0.setTitle("화살 무료 충전소 \(index)", for: .normal)
            $0.backgroundColor = .lightGray
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 30
            $0.tag = index
            // Set the button action
            $0.addTarget(self, action: #selector(rechargeOptionButtonTapped), for: .touchUpInside)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "화살 충전"
    }
    
    private func setupLayout() {
        view.addSubview(rechargeStationTitleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nextChargeButton)
        rechargeOptionButtons.forEach(view.addSubview)
        
        rechargeStationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rechargeStationTitleLabel.snp.bottom).offset(10) // Adjust the spacing as needed
            make.left.right.equalToSuperview().inset(20)
        }
        
        nextChargeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        var previousButton: UIButton?
        for button in rechargeOptionButtons {
            button.snp.makeConstraints { make in
                if let previous = previousButton {
                    make.top.equalTo(previous.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(nextChargeButton.snp.bottom).offset(20)
                }
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(50)
            }
            previousButton = button
        }
    }
    
    // MARK: - Actions
    @objc private func nextChargeButtonTapped() {
        // Handle the button tap
    }
    
    @objc private func rechargeOptionButtonTapped(sender: UIButton) {
        // Handle the button tap based on the button's tag
        let index = sender.tag
        print("Recharge option \(index) tapped")
    }
}
