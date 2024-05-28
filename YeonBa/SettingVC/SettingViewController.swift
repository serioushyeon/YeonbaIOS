import UIKit
import SnapKit
import Then
import Kingfisher

class SettingViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 70
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.primary?.cgColor
        $0.layer.borderWidth = 3
        
    }
    private lazy var gradientBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 75
        view.layer.masksToBounds = true
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = [UIColor.red.cgColor, UIColor.blue.cgColor] // 원하는 그라데이션 색상 설정
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        return l
    }()
    private lazy var borderLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = 4.0 // Border width
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    private let nameLabel = UILabel().then {
        $0.text = "연바" // 원하는 이름으로 수정
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    private let button1 = UIButton().then {
        $0.setTitle(" 프로필 수정하기", for: .normal)
        $0.layer.borderWidth = 2.0 // 테두리 두께
        $0.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        $0.layer.cornerRadius = 20.0 // 테두리 둥글기 반지름
        $0.setTitleColor(UIColor.black, for: .normal) // 텍스트 색상
        $0.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .black
        $0.contentHorizontalAlignment = .center // 버튼1 이미지를 가로로 가운데 정렬
    }
    private let button2 = UIButton().then {
        $0.setTitle(" 남은 화살 수: 5개", for: .normal)
        $0.layer.cornerRadius = 20.0 // 테두리 둥글기 반지름
        $0.backgroundColor = .primary
        $0.setTitleColor(UIColor.white, for: .normal) // 텍스트 색상
        $0.setImage(UIImage(named: "arrowProfile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .center // 버튼2 이미지를 가로로 가운데 정렬
        $0.isUserInteractionEnabled = false
    }
    private let bottomView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
        setupActions()
        updateUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradientBorder()
    }
    
    //MARK: - UI Layout
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(gradientBorderView, imageView, nameLabel, horizontalStackView)
        horizontalStackView.addArrangedSubview(button1)
        horizontalStackView.addArrangedSubview(button2)
        contentView.addSubview(bottomView)
    }
    
    func updateUserProfile() {
        NetworkService.shared.mypageService.myProfile() { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    self.nameLabel.text = data.name
                    self.button2.setTitle("남은 화살 수: \(data.arrows)개", for: .normal)
                    var profilePhotoUrl = data.profileImageUrl
                    if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
                        print("Loading image from URL: \(url)")
                        self.imageView.kf.setImage(with: url, completionHandler: { result in
                            switch result {
                            case .success(let value):
                                print("Image successfully loaded: \(value.source.url?.absoluteString ?? "")")
                                self.applyGradientBorder()
                            case .failure(let error):
                                print("Error loading image: \(error)")
                            }
                        })
                    } else {
                        print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
                    }
                }
            default:
                print("데이터 안들어옴")
            }
        }
    }
    
    func applyGradientBorder() {
        let radius = imageView.bounds.width / 2
        gradientBorderView.frame = imageView.frame
        gradientLayer.frame = gradientBorderView.bounds
        gradientLayer.cornerRadius = radius
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        borderLayer.path = circularPath.cgPath
        borderLayer.strokeColor = UIColor.clear.cgColor // Hide the temporary color
        
        gradientLayer.mask = borderLayer
    }
    
    func configUI() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        gradientBorderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(150)
        }
        imageView.snp.makeConstraints { make in
            make.center.equalTo(gradientBorderView)
            make.width.height.equalTo(150 - 8) // Adjust size to fit inside border
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(gradientBorderView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        // 하단 스택 뷰 설정
        let views = (0...6).map { index -> UIView in
            let container = UIView()
            
            let label = UILabel()
            label.text = ["알림 설정", "계정 관리", "차단 관리", "화살 충전", "고객 센터", "이용 약관/개인정보 취급 방침", "공지 사항"][index]
            label.textColor = .black
            label.backgroundColor = .gray2
            label.font = UIFont(name: "Pretendard-Medium", size: 18)
            container.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(20)
            }
            
            let button = UIButton()
            button.setImage(UIImage(named: "allow"), for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            button.tag = index
            container.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(20)
                make.width.equalTo(40)
                make.height.equalTo(40)
            }

            // 구분선 추가
            let divider = UIView()
            divider.backgroundColor = .gray3
            container.addSubview(divider)
            
            divider.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            container.snp.makeConstraints { make in
                make.height.equalTo(95)
            }
            
            return container
        }
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .gray2
        
        bottomView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.bottom).offset(20)
        }
    }

    func updateArrowNumber(number: Int) {
        let arrowNumber = number
        button2.setTitle(" 남은 화살수 \(arrowNumber)", for: .normal)
    }
            
    func setupActions() {
        button1.addTarget(self, action: #selector(handleProfileEditTap), for: .touchUpInside)
    }
    func apiDetailProfile(){
        NetworkService.shared.mypageService.profileDetail{ [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                let profileEditViewController = ProfileEditViewController()
                profileEditViewController.profileDetail = data
                navigationController?.pushViewController(profileEditViewController, animated: true)
                print("프로필 상세 조회 성공")
            default:
                print("프로필 상세 조회 실패")
                
            }
        }
    }
    @objc func handleProfileEditTap() {
        apiDetailProfile()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            let viewController = NotificationsettingsViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = AccountManagementViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = BlockingmanagementViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let viewController = ArrowRechargeViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 4:
            let viewController = CustomercenterViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 5:
            let viewController = PolicyViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 6:
            let noticeViewController = NoticeViewController()
            navigationController?.pushViewController(noticeViewController, animated: true)
        default:
            break
        }
    }
}
