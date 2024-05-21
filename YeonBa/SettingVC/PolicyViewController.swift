import UIKit
import SnapKit
import Then

class PolicyViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "이용 약관/ 개인정보 처리 방침"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    private let termsTextView = UITextView().then {
        $0.text = "여기에 이용 약관의 내용이 들어갑니다.\n\n" // Replace with your actual terms text
        $0.isEditable = false
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar() // 네비게이션 바 설정 메서드 호출
        setupViews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "이용 약관/ 개인정보 처리 방침"
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(termsTextView)
    }
    
    private func layoutViews() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.left.right.equalTo(view)
            make.width.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // Add any additional methods or actions if needed...
}
