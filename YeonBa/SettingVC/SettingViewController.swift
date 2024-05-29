import UIKit
import SnapKit
import Then
import Kingfisher

class SettingViewController: UIViewController {
    private enum Constant {
        static let thumbnailSize = 170.0
        static let thumbnailCGSize = CGSize(width: Constant.thumbnailSize, height: Constant.thumbnailSize)
        static let borderWidth = 5.0
        static let spacing = 10.0
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let imageView = UIImageView().then {
        //$0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = (Constant.thumbnailSize - Constant.spacing * 2) / 2.0
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "연바"
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
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 20.0
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .black
        $0.contentHorizontalAlignment = .center
    }
    private let button2 = UIButton().then {
        $0.setTitle(" 남은 화살 수: 5개", for: .normal)
        $0.layer.cornerRadius = 20.0
        $0.backgroundColor = .primary
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setImage(UIImage(named: "arrowProfile")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .center
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
       guard
         self.containerView.bounds != .zero,
         self.containerView.layer.sublayers?.contains(where: { $0 is CAGradientLayer }) == false
       else { return }

       let gradient = CAGradientLayer()
       gradient.frame = CGRect(origin: CGPoint.zero, size: Constant.thumbnailCGSize)
        gradient.colors = [UIColor.primary, UIColor.secondary].map(\.?.cgColor)

       let shape = CAShapeLayer()
       shape.lineWidth = Constant.borderWidth
       shape.path = UIBezierPath(
         roundedRect: self.containerView.bounds.insetBy(dx: Constant.borderWidth, dy: Constant.borderWidth),
         cornerRadius: Constant.thumbnailSize / 2.0
       ).cgPath
       shape.strokeColor = UIColor.black.cgColor
       shape.fillColor = UIColor.clear.cgColor
       gradient.mask = shape

       self.containerView.layer.addSublayer(gradient)
     }
    
    //MARK: - UI Layout
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(containerView, nameLabel, horizontalStackView)
        containerView.addSubview(imageView)
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
                                //self.applyGradientBorder()
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
    
    
    func configUI() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(Constant.thumbnailSize)
        }
        imageView.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).offset(Constant.spacing)
            make.right.equalTo(containerView.snp.right).offset(-Constant.spacing)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Constant.spacing)
            make.top.equalTo(containerView.snp.top).offset(Constant.spacing)
            //make.width.height.equalTo(142)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
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
