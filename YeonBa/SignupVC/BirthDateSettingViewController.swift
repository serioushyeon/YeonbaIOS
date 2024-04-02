import UIKit
import SnapKit
import Then

class BirthDateSettingViewController: UIViewController {

    let instructionLabel = UILabel().then {
        $0.text = "생년월일을 입력해 주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }

    let yearTextField = UITextField().then {
        $0.placeholder = "YYYY"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
    }

    let monthTextField = UITextField().then {
        $0.placeholder = "MM"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
    }

    let dayTextField = UITextField().then {
        $0.placeholder = "DD"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
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
        view.addSubview(yearTextField)
        view.addSubview(monthTextField)
        view.addSubview(dayTextField)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }

        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.top)
            make.left.equalTo(yearTextField.snp.right).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }

        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.top)
            make.left.equalTo(monthTextField.snp.right).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    @objc func nextButtonTapped() {
        // Validate the date and transition to the next screen if successful
    }
}
