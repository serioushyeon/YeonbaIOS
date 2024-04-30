import UIKit
import SnapKit
import Then

class NicknameSettingViewController: UIViewController {

    let instructionLabel = UILabel().then {
        $0.text = "닉네임을 입력해 주세요."
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let instructionLabel2 = UILabel().then {
        $0.text = "닉네임은 한글, 영어, 숫자 모두 가능해요"
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.numberOfLines = 0
    }

    let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임 입력"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.textAlignment = .center
        $0.borderStyle = .roundedRect
    }

    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "회원가입"
    }

    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(instructionLabel2)
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        instructionLabel2.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-55)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    @objc func nextButtonTapped() {
        // Validate the nickname and if valid, proceed to the next screen
        let nextVC = GenderSelectionViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
