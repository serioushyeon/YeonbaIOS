import UIKit
import SnapKit
import Then

class EmailSettingViewController: UIViewController {

    let instructionLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }

    let emailTextField = UITextField().then {
        $0.placeholder = "이메일 입력"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.keyboardType = .emailAddress
        $0.borderStyle = .roundedRect
    }

    let emailInstructionLabel = UILabel().then {
        $0.text = "비밀번호 분실시 아래의 이메일 계정을 통해 계정을 찾아드려요. 정확한 이메일을 입력해주세요. 이후 변경은 불가합니다."
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    let errorLabel = UILabel().then {
        $0.text = "이메일 형식에 맞지 않습니다. 다시 설정해주세요."
        $0.textColor = .red
        $0.font = UIFont.pretendardSemiBold(size: 10)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true // 초기에는 라벨을 숨깁니다.
    }
    
    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
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
        view.addSubview(emailTextField)
        view.addSubview(emailInstructionLabel)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        emailInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailInstructionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }

        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    @objc func nextButtonTapped() {
//        guard let email = emailTextField.text, isEmailValid(email) else {
//                errorLabel.isHidden = false // 오류 메시지를 표시합니다.
//                return // 이메일이 유효하지 않으므로 여기서 함수를 종료합니다.
//            }
//            errorLabel.isHidden = true // 이메일이 유효하면 오류 메시지를 숨깁니다.

            // 이메일이 유효하다면 다음 화면으로 넘어갑니다.
            let nextVC = BirthDateSettingViewController()
            navigationController?.pushViewController(nextVC, animated: true)
    }
}


