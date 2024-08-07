import UIKit
import SnapKit
import Then

protocol Ad1ViewControllerDelegate: AnyObject {
    func ad1ViewControllerDidClose(_ controller: Ad1ViewController)
}

class Ad1ViewController: UIViewController {

    weak var delegate: Ad1ViewControllerDelegate?
    private var imageView = UIImageView().then {
        $0.image = UIImage(named: "ad1")
        $0.contentMode = .scaleAspectFill
    }
    private var timerButton = UIButton().then {
        $0.setTitle("5", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        $0.backgroundColor = UIColor.white
        $0.setTitleColor(.black, for: .normal)
        $0.layer.masksToBounds = true
    }
    
    var closeTimer: Timer?
    var remainingSeconds: Int = 5  // 타이머 초기 시간 설정
    let closeButton = UIButton(type: .system)  // 닫기 버튼

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isTranslucent = true
        setupView()
        setupLayout()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTimerButtonSize()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    func setupView() {
        view.addSubview(imageView)
        view.addSubview(timerButton)

        // 닫기 버튼 설정
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
        closeButton.isEnabled = false  // 초기에 버튼 비활성화
        view.addSubview(closeButton)

        // 1초마다 타이머 업데이트
        closeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        timerButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.width.height.equalTo(50)  // Initial size
        }
    }

    func updateTimerButtonSize() {
        let circleSize = view.bounds.width * 0.1  // Adjust this value to control the size
        timerButton.layer.cornerRadius = circleSize / 2
        timerButton.snp.updateConstraints {
            $0.width.height.equalTo(circleSize)
        }
    }

    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timerButton.setTitle("\(remainingSeconds)", for: .normal)
        } else {
            timerButton.setTitle("X", for: .normal)
            timerButton.removeTarget(self, action: nil, for: .allEvents)
            timerButton.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
            closeTimer?.invalidate() 
        }
    }

    @objc func closeAd() {
        print("1번광고")
        delegate?.ad1ViewControllerDidClose(self)
        navigationController?.popViewController(animated: true)
    }

    deinit {
        closeTimer?.invalidate()  // 뷰 컨트롤러 해제 시 타이머 비활성화
    }
}
