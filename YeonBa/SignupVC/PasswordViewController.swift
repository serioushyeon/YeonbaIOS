import UIKit
import SnapKit
import Then

class PasswordViewController: UIViewController {

    let instructionLabel = UILabel().then {
        $0.text = "비밀번호를 설정해 주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }

    let passwordInstructionLabel = UILabel().then {
        $0.text = "비밀번호는 영문 대소문자, 숫자, 특수문자(-)(_)를 포함하여 8~20자로 설정해주세요."
        $0.textColor = .darkGray
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = " 비밀번호 입력"
        $0.isSecureTextEntry = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 8
    }

    let confirmPasswordTextField = UITextField().then {
        $0.placeholder = " 비밀번호 확인"
        $0.isSecureTextEntry = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    let errorLabel = UILabel().then {
        $0.text = "비밀번호가 일치하지 않거나 조건을 만족하지 않습니다!"
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.isHidden = true // 기본적으로는 숨겨진 상태
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
        setupViews()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
          navigationItem.title = "회원가입"
      }

    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(passwordInstructionLabel)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        passwordInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordInstructionLabel.snp.bottom).offset(66)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    
    @objc func nextButtonTapped() {
//        guard let password = passwordTextField.text,
//              let confirmPassword = confirmPasswordTextField.text,
//              isPasswordValid(password),
//              password == confirmPassword else {
//            // 비밀번호 유효성 검사 실패 혹은 비밀번호가 일치하지 않을 경우
//            errorLabel.isHidden = false
//            return
//        }
//
//        // 모든 검사를 통과했을 경우 에러 라벨을 숨기고 다음 화면으로 넘어간다
//        errorLabel.isHidden = true
        let emailSettingVC = EmailSettingViewController()
        navigationController?.pushViewController(emailSettingVC, animated: true)
    }

}
