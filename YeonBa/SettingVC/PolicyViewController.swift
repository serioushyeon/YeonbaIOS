import UIKit
import SnapKit
import Then

class PolicyViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    
    private let termsTextView = UITextView().then {
        $0.text = """
        연바 이용약관

        제 1 조 (목적)
        본 약관은 연바(이하 "앱")가 제공하는 모든 서비스의 이용과 관련하여 앱과 이용자의 권리, 의무 및 책임 사항을 규정하는 것을 목적으로 합니다.

        제 2 조 (정의)
        1. "앱"이란 연바에서 제공하는 모든 서비스를 의미합니다.
        2. "이용자"란 본 약관에 따라 앱이 제공하는 서비스를 이용하는 자를 말합니다.
        3. "계정"이란 이용자가 서비스를 이용하기 위해 등록한 이메일 주소와 비밀번호의 조합을 의미합니다.

        제 3 조 (이용약관의 효력 및 변경)
        1. 본 약관은 앱에 게시하거나 기타의 방법으로 공지함으로써 효력이 발생합니다.
        2. 앱은 필요한 경우 법령을 위배하지 않는 범위 내에서 본 약관을 변경할 수 있습니다. 변경된 약관은 공지사항을 통해 공지하며, 이용자가 명시적으로 거부하지 않는 한 효력이 발생합니다.

        제 4 조 (이용계약의 성립)
        1. 이용계약은 이용자가 약관 내용에 동의한 후 이용신청을 하고 앱이 이를 승낙함으로써 성립합니다.
        2. 앱은 다음 각 호에 해당하는 경우 이용신청을 거절할 수 있습니다.
           - 실명이 아니거나 타인의 명의를 이용한 경우
           - 허위의 정보를 기재하거나, 앱이 요구하는 내용을 기재하지 않은 경우
           - 기타 관련 법령을 위반한 경우

        제 5 조 (서비스의 이용)
        1. 서비스 이용은 앱의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간 운영을 원칙으로 합니다.
        2. 앱은 정기점검 등의 필요로 인해 사전에 공지한 경우 서비스의 제공을 일시적으로 중단할 수 있습니다.

        제 6 조 (서비스의 변경 및 중단)
        1. 앱은 서비스의 내용, 시스템, 기타 사항을 변경할 수 있으며, 이러한 변경은 사전에 공지합니다.
        2. 앱은 천재지변, 비상사태, 기술적 문제 등 불가피한 사유로 인해 서비스 제공이 어려운 경우, 서비스의 전부 또는 일부를 제한하거나 중단할 수 있습니다.

        제 7 조 (이용자의 의무)
        1. 이용자는 다음 행위를 하여서는 안 됩니다.
           - 타인의 개인정보를 도용하거나 부정하게 사용하는 행위
           - 앱의 운영을 방해하거나 고의로 시스템을 손상시키는 행위
           - 불법적이거나 부당한 행위
        2. 이용자는 본 약관 및 관계 법령을 준수하여야 하며, 앱의 업무에 방해가 되는 행위를 해서는 안 됩니다.

        제 8 조 (개인정보 보호)
        1. 앱은 이용자의 개인정보를 보호하기 위해 노력하며, 개인정보 보호정책에 따라 이용자의 개인정보를 처리합니다.
        2. 이용자는 언제든지 자신의 개인정보를 열람하거나 수정할 수 있으며, 앱의 개인정보 처리에 대한 자세한 사항은 개인정보 보호정책을 참조하십시오.

        제 9 조 (면책조항)
        1. 앱은 천재지변, 비상사태, 불가항력 등 앱의 통제 범위를 벗어난 사유로 인해 서비스를 제공할 수 없는 경우, 서비스 제공에 관한 책임이 면제됩니다.
        2. 앱은 이용자의 귀책사유로 인해 발생한 손해에 대해 책임을 지지 않습니다.

        제 10 조 (준거법 및 관할법원)
        본 약관에 관한 분쟁은 대한민국 법을 준거법으로 하며, 관할 법원은 대한민국의 법원으로 합니다.

        부칙
        1. 본 약관은 2024년 5월 21일부터 시행됩니다.
        """
        $0.isEditable = false
        $0.isScrollEnabled = false
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
        contentView.addSubview(termsTextView)
    }
    
    private func layoutViews() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(1250)
        }
    }
}
