import UIKit
import SnapKit
import Then

class AttendancePopupViewController: UIViewController {

    private let messageLabel = UILabel().then {
        $0.text = "오늘의 출석을 환영합니다🤗\n화살 10개 제공해드릴게요.\n지금 바로 좋은 인연을 찾으러 가보세요🫶🏻"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    
    private let receiveButton = ActualGradientButton().then {
        $0.setTitle("💘 화살 10개 받기 💘", for: .normal)
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
        popupView.addSubview(receiveButton)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(20)
        }

        receiveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(60)
        }
    }

    private func setupActions() {
        receiveButton.addTarget(self, action: #selector(receiveButtonTapped), for: .touchUpInside)
    }

    @objc private func receiveButtonTapped() {
        dismiss(animated: true, completion: nil)
        
        ArrowCountManager.shared.incrementArrowCount(by: 10)
    }
}
