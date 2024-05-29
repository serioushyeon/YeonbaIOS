import UIKit
import SnapKit
import Then

class ArrowRechargeViewController: UIViewController, Ad1ViewControllerDelegate, Ad2ViewControllerDelegate, Ad3ViewControllerDelegate {
    
    private let descriptionLabel = UILabel().then {
        $0.text = "화살 무료충전소에서 광고를 시청하면 화살 5개가 충전 됩니다. \n하루에 화살 무료 충전소를 최대 3개까지 이용 가능합니다."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let rechargeStationTitleLabel = UILabel().then {
        $0.text = "화살충전소"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    private let nextChargeButton = UIButton().then {
        $0.setTitle(" 남은 화살 수: 5개", for: .normal)
        $0.backgroundColor = .systemPink
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(named: "arrowProfile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    private let button1 = ChangeGradientButton().then {
        $0.setTitle("화살 무료 충전소", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.tag = 1
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        $0.setCircleLabelText("1")
    }
    
    private let button2 = ChangeGradientButton().then {
        $0.setTitle("화살 무료 충전소", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.tag = 2
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        $0.isEnabled = false
        $0.setCircleLabelText("2")
    }
    
    private let button3 = ChangeGradientButton().then {
        $0.setTitle("화살 무료 충전소", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.tag = 3
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        $0.isEnabled = false
        $0.setCircleLabelText("3")
    }
    
    // rechargeOptionButtons 배열 선언
    private lazy var rechargeOptionButtons: [ChangeGradientButton] = [button1, button2, button3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
        initializeButtonStates()
        updateArrowCountLabel()
        //nextChargeButton.setTitle("남은 화살 수: \(arrowCount)개", for: .normal)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(descriptionLabel)
        view.addSubview(rechargeStationTitleLabel)
        view.addSubview(nextChargeButton)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        rechargeStationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rechargeStationTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        nextChargeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button1.snp.makeConstraints { make in
            make.top.equalTo(nextChargeButton.snp.bottom).offset(75)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
    }
    
    private func setupActions() {
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func initializeButtonStates() {
        button1.isEnabled = true
        button2.isEnabled = false
        button3.isEnabled = false
        button1.activate()
        button2.deactivate()
        button3.deactivate()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        if sender == button1 {
            let ad1VC = Ad1ViewController()
            ad1VC.delegate = self
            navigationController?.pushViewController(ad1VC, animated: true)
        } else if sender == button2 {
            let ad2VC = Ad2ViewController()
            ad2VC.delegate = self
            navigationController?.pushViewController(ad2VC, animated: true)
        } else if sender == button3 {
            let ad3VC = Ad3ViewController()
            ad3VC.delegate = self
            navigationController?.pushViewController(ad3VC, animated: true)
        }
    }
    
    func ad1ViewControllerDidClose(_ controller: Ad1ViewController) {
        if rechargeOptionButtons.indices.contains(0) {
            rechargeOptionButtons[0].deactivate()
        }
        if rechargeOptionButtons.indices.contains(1) {
            rechargeOptionButtons[1].activate()
            rechargeOptionButtons[1].isEnabled = true
        }
        NetworkService.shared.mypageService.chargeArrow { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    print("요청 성공")
                    ArrowCountManager.shared.incrementArrowCount(by: 5)
                    self.updateArrowCountLabel()
                }
            case .requestErr(let statusResponse):
                print("요청 에러: \(statusResponse.message)")
            case .pathErr:
                print("경로 에러")
            case .serverErr:
                print("서버 에러")
            case .networkErr:
                print("네트워크 에러")
            case .failure:
                print("실패")
            }
        }
        
    }
    
    func ad2ViewControllerDidClose(_ controller: Ad2ViewController) {
        if rechargeOptionButtons.indices.contains(1) {
            rechargeOptionButtons[1].deactivate()
        }
        if rechargeOptionButtons.indices.contains(2) {
            rechargeOptionButtons[2].activate()
            rechargeOptionButtons[2].isEnabled = true
        }
        NetworkService.shared.mypageService.chargeArrow { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    print("요청 성공")
                    ArrowCountManager.shared.incrementArrowCount(by: 5)
                    self.updateArrowCountLabel()
                }
            case .requestErr(let statusResponse):
                print("요청 에러: \(statusResponse.message)")
            case .pathErr:
                print("경로 에러")
            case .serverErr:
                print("서버 에러")
            case .networkErr:
                print("네트워크 에러")
            case .failure:
                print("실패")
            }
        }
        updateArrowCountLabel()
    }
    
    func ad3ViewControllerDidClose(_ controller: Ad3ViewController) {
        rechargeOptionButtons.forEach { button in
            button.deactivate()
        }
        ArrowCountManager.shared.incrementArrowCount(by: 5)
        NetworkService.shared.mypageService.chargeArrow { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    print("요청 성공")
                    ArrowCountManager.shared.incrementArrowCount(by: 5)
                    self.updateArrowCountLabel()
                }
            case .requestErr(let statusResponse):
                print("요청 에러: \(statusResponse.message)")
            case .pathErr:
                print("경로 에러")
            case .serverErr:
                print("서버 에러")
            case .networkErr:
                print("네트워크 에러")
            case .failure:
                print("실패")
            }
        }
        updateArrowCountLabel()
    }
    
    private func updateArrowCountLabel() {
        let arrowCount = ArrowCountManager.shared.arrowCount ?? 0
        nextChargeButton.setTitle(" 남은 화살 수: \(arrowCount)개", for: .normal)
    }
}
