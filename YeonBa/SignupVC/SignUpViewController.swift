import UIKit
import SnapKit
import Then

class SignUpViewController: UIViewController {
    
    let logoLabel = UILabel().then {
        $0.text = "YeonBa"
        $0.font = UIFont.pretendardSemiBold(size: 60)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logoimage") // "logoImage"는 해당 이미지의 이름입니다.
        $0.contentMode = .scaleAspectFit
    }

    let descriptionLabel = UILabel().then {
        $0.text = "연애는, 바로 지금, 연바"
        $0.font = UIFont.pretendardSemiBold(size: 26)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인 하기", for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.red, for: .normal)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }
    
    let signUpButton = UIButton().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "가입하기", attributes: attributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }

    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.secondary?.cgColor, UIColor.primary?.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.cornerRadius = 16
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(gradientLayer, at: 0)
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupViews() {
        
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(200)
            make.left.equalToSuperview().offset(100) // 좌측 여백을 100으로 설정
            make.right.equalToSuperview().inset(40) // 우측 여백은 40으로 유지
        }

        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(logoLabel.snp.centerY) // 로고 이미지를 라벨과 수직 중앙으로 정렬합니다.
            make.right.equalTo(logoLabel.snp.left).offset(10) // 로고 라벨의 왼쪽에 위치하도록 합니다.
            make.width.height.equalTo(60) // 로고 이미지의 크기를 설정합니다. 필요에 따라 조정하세요.
        }

        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(70)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 로그인 버튼과 회원가입 버튼에 대한 액션 메서드를 추가하세요.
        // 예를 들어 로그인 버튼에 액션을 추가하는 방법:
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        // 회원가입 버튼에 액션을 추가하는 방법:
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    
}

    // MARK: - Actions
extension SignUpViewController {
    @objc func loginButtonTapped() {
        // 로그인 화면으로 전환하는 로직을 여기에 구현합니다.
    }
    
    @objc func signUpButtonTapped() {
        
        let phonenumberVC = PhoneNumberViewController()
        navigationController?.pushViewController(phonenumberVC, animated: true)
    }
}

