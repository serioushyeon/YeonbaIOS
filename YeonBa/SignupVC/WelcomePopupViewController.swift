import UIKit
import SnapKit
import Then

class WelcomePopupViewController: UIViewController {

    private let messageLabel = UILabel().then {
        $0.text = "연바에 오신걸 환영합니다🩷 \n화살 30개를 제공해드릴게요~!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    
    private let closeButton = ActualGradientButton().then {
        $0.setTitle("💘 이상형 찾으러 GO~GO! ", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.layer.cornerRadius = 30
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let popupView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
        }

        view.addSubview(popupView)
        popupView.addSubview(messageLabel)
        popupView.addSubview(closeButton)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(60)
        }
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
